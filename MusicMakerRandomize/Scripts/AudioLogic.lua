if not MusicMakerRandomizer.Config.Enabled then return end

ModUtil.Path.Wrap("MusicianMusic", function(base, args)
	-- If the chosen song is Song_RandomSong and the Music Maker not already playing something, choose a random track and save it in the currentRun to reset it only after a run ends
	if args.TrackName == "Song_RandomSongTrack" then
		local availableTracks = {}
		if GameState and GameState.WorldUpgrades then
			for _, songName in ipairs(ScreenData.MusicPlayer.Songs) do
				if songName ~= "Song_RandomSong" and (GameState.WorldUpgrades[songName] or MusicMakerRandomizer.Config.AllSongs) then
					table.insert(availableTracks, WorldUpgradeData[songName])
				end
			end
		end

		-- Choose a random song from the available ones, if no other song was chosen yet in this "run"
		if CurrentRun.MusicMakerRandomizerTrackName == nil then
			local chosenTrack = availableTracks[RandomInt(1, #availableTracks)]
			CurrentRun.MusicMakerRandomizerTrackName = chosenTrack.TrackName
			-- To update the description of the Song_RandomSong to include the friendly name of the chosen track
			GameState.MusicMakerRandomizerFriendlyPlayingSong = GetDisplayName({ Text = chosenTrack.Name })
		end

		args.TrackName = CurrentRun.MusicMakerRandomizerTrackName
	else
		-- If we are playing a different song, do not display its name in the description, as it won't get updated when the player chooses the random song, which may be confusing
		GameState.MusicMakerRandomizerFriendlyPlayingSong = GetDisplayName({ Text = GameState.MusicPlayerSongName })
	end

	base(args)
end)
