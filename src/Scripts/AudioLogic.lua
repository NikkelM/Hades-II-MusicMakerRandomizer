modutil.mod.Path.Wrap("MusicianMusic", function(base, args)
	-- If the chosen song is Song_RandomSong and the Music Maker not already playing something, choose a random track and save it in the currentRun to reset it only after a run ends
	-- Similarly, for the Song_RandomSongFavorites
	if args.TrackName == "Song_RandomSongTrack" or args.TrackName == "Song_RandomSongFavoritesTrack" then
		local availableTracks = {}

		if args.TrackName == "Song_RandomSongTrack" then
			-- Get all eligible tracks for the Song_RandomSong
			if game.GameState and game.GameState.WorldUpgrades then
				for _, songName in ipairs(game.ScreenData.MusicPlayer.Songs) do
					if (songName ~= "Song_RandomSong" and songName ~= "Song_RandomSongFavorites") and (game.GameState.WorldUpgrades[songName] or config.AllSongs) then
						table.insert(availableTracks, game.WorldUpgradeData[songName])
					end
				end
			end
		else
			-- Only choose from purchased, favorited (pinned) songs
			if game.GameState and game.GameState.WorldUpgrades then
				for _, songName in ipairs(game.ScreenData.MusicPlayer.Songs) do
					if (songName ~= "Song_RandomSong" and songName ~= "Song_RandomSongFavorites") and game.GameState.WorldUpgrades[songName] and game.HasStoreItemPin(songName) then
						table.insert(availableTracks, game.WorldUpgradeData[songName])
					end
				end
			end

			if #availableTracks == 0 then
				-- If no favorited songs exist, do not play anything
				args.TrackName = nil
				game.GameState.MusicMakerRandomizerFriendlyPlayingSong = "Nothing... (No Favorites!)"
				base(args)
				return
			end
		end

		-- Choose a random song from the available ones
		local chosenTrack = availableTracks[game.RandomInt(1, #availableTracks)]
		-- To update the description of the Song_RandomSong to include the friendly name of the chosen track
		game.GameState.MusicMakerRandomizerFriendlyPlayingSong = game.GetDisplayName({ Text = chosenTrack.Name })

		args.TrackName = chosenTrack.TrackName
	else
		game.GameState.MusicMakerRandomizerFriendlyPlayingSong = game.GetDisplayName({
			Text = game.GameState
			.MusicPlayerSongName
		})
	end

	base(args)
end)
