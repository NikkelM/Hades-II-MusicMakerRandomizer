modutil.mod.Path.Wrap("MusicianMusic", function(base, args)
	-- If the chosen song is Song_RandomSong and the Music Maker not already playing something, choose a random track and save it in the currentRun to reset it only after a run ends
	-- Similarly, for the Song_RandomSongFavourites
	if args.TrackName == "Song_RandomSongTrack" or args.TrackName == "Song_RandomSongFavouritesTrack" then
		local availableTracks = {}

		if args.TrackName == "Song_RandomSongTrack" then
			-- Get all eligible tracks for the Song_RandomSong
			if game.GameState and game.GameState.WorldUpgrades then
				for _, songName in ipairs(game.ScreenData.MusicPlayer.Songs) do
					if (songName ~= "Song_RandomSong" and songName ~= "Song_RandomSongFavourites") and (game.GameState.WorldUpgrades[songName] or config.AllSongs) then
						table.insert(availableTracks, game.WorldUpgradeData[songName])
					end
				end
			end
		else
			-- Only choose from purchased, favourited (pinned) songs
			if game.GameState and game.GameState.WorldUpgrades then
				for _, songName in ipairs(game.ScreenData.MusicPlayer.Songs) do
					if (songName ~= "Song_RandomSong" and songName ~= "Song_RandomSongFavourites") and game.GameState.WorldUpgrades[songName] and game.HasStoreItemPin(songName) then
						table.insert(availableTracks, game.WorldUpgradeData[songName])
					end
				end
			end
		end

		-- Choose a random song from the available ones
		local chosenTrack = availableTracks[game.RandomInt(1, #availableTracks)]
		-- To update the description of the Song_RandomSong to include the friendly name of the chosen track
		game.GameState.MusicMakerRandomizerFriendlyPlayingSong = game.GetDisplayName({ Text = chosenTrack.Name })

		args.TrackName = chosenTrack.TrackName
	else
		game.GameState.MusicMakerRandomizerFriendlyPlayingSong = game.GetDisplayName({ Text = game.GameState.MusicPlayerSongName })
	end

	base(args)
end)
