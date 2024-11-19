modutil.mod.Path.Wrap("MusicianMusic", function(base, args)
	-- If the chosen song is Song_RandomSong and the Music Maker not already playing something, choose a random track and save it in the currentRun to reset it only after a run ends
	if args.TrackName == "Song_RandomSongTrack" then
		local availableTracks = {}
		if game.GameState and game.GameState.WorldUpgrades then
			for _, songName in ipairs(game.ScreenData.MusicPlayer.Songs) do
				if songName ~= "Song_RandomSong" and (game.GameState.WorldUpgrades[songName] or config.AllSongs) then
					table.insert(availableTracks, game.WorldUpgradeData[songName])
				end
			end
		end

		-- Choose a random song from the available ones, if no other song was chosen yet in this "run"
		if game.CurrentRun.MusicMakerRandomizerTrackName == nil then
			local chosenTrack = availableTracks[game.RandomInt(1, #availableTracks)]
			game.CurrentRun.MusicMakerRandomizerTrackName = chosenTrack.TrackName
			-- To update the description of the Song_RandomSong to include the friendly name of the chosen track
			game.GameState.MusicMakerRandomizerFriendlyPlayingSong = game.GetDisplayName({ Text = chosenTrack.Name })
		end

		args.TrackName = game.CurrentRun.MusicMakerRandomizerTrackName
	else
		-- If we are playing a different song, do not display its name in the description, as it won't get updated when the player chooses the random song, which may be confusing
		GameState.MusicMakerRandomizerFriendlyPlayingSong = game.GetDisplayName({ Text = game.GameState.MusicPlayerSongName })
	end

	base(args)
end)
