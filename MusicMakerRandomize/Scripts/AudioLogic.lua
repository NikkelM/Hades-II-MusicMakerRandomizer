if not MusicMakerRandomize.Config.Enabled then return end

ModUtil.Path.Wrap("MusicianMusic", function(base, args)
	-- If the chosen song is Song_RandomSong and the Music Maker not already playing something, choose a random track and save it in the currentRun to reset it only after a run ends
	if args.TrackName == "Song_RandomSong" then
		local availableTracks = {}
		-- Choose from all available tracks (even those not yet unlocked/visible to the player)
		if MusicMakerRandomize.Config.AllSongs then
			availableTracks = DeepCopyTable(ScreenData.MusicPlayer.Songs)
		-- Choose only from unlocked tracks
		elseif GameState and GameState.WorldUpgrades then
			for _, songName in ipairs(ScreenData.MusicPlayer.Songs) do
				if GameState.WorldUpgrades[songName] then
					table.insert(availableTracks, WorldUpgradeData[songName].TrackName)
				end
			end
		end

		-- Choose a random song from the available ones, if no other song was chosen yet in this "run"
		if CurrentRun.MusicMakerRandomizeTrackName == nil then
			CurrentRun.MusicMakerRandomizeTrackName = availableTracks[RandomInt(1, #availableTracks)]
		end
		args.TrackName = CurrentRun.MusicMakerRandomizeTrackName
	end
	base(args)
end)
