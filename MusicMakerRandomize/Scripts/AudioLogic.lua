if not MusicMakerRandomize.Config.Enabled then return end

ModUtil.Path.Wrap("MusicianMusic", function(base, args)
	-- If the chosen song is Song_RandomSong and the Music Maker not already playing something, choose a random track and save it in the currentRun to reset it only after a run ends
	if args.TrackName == "Song_RandomSongTrack" then
		local availableTracks = {}
		if MusicMakerRandomize.Config.AllSongs then
			-- Choose from all available tracks (even those not yet unlocked/visible to the player)
			availableTracks = DeepCopyTable(ScreenData.MusicPlayer.Songs)
		elseif GameState and GameState.WorldUpgrades then
			-- Choose only from unlocked tracks
			for _, songName in ipairs(ScreenData.MusicPlayer.Songs) do
				if songName ~= "Song_RandomSong" and GameState.WorldUpgrades[songName] then
					table.insert(availableTracks, WorldUpgradeData[songName])
				end
			end
		end

		-- Choose a random song from the available ones, if no other song was chosen yet in this "run"
		if CurrentRun.MusicMakerRandomizeTrackName == nil then
			local chosenTrack = availableTracks[RandomInt(1, #availableTracks)]
			CurrentRun.MusicMakerRandomizeTrackName = chosenTrack.TrackName
			-- To update the description of the Song_RandomSong to include the friendly name of the chosen track
			GameState.MusicMakerRandomizeFriendlyPlayingSongString = "\n{#Prev}Now playing {#ItalicFormat}" .. GetDisplayName({Text = chosenTrack.Name}) .. "{#Prev}."
		end

		args.TrackName = CurrentRun.MusicMakerRandomizeTrackName
	else
		-- If we are playing a different song, do not display its name in the description, as it won't get updated when the player chooses the random song, which may be confusing
		GameState.MusicMakerRandomizeFriendlyPlayingSongString = ""
	end

	base(args)
end)
