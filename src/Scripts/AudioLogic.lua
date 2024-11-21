local function IsSongEligibleForRandomizer(songName, randomizerType)
	if songName == "Song_RandomSong" or songName == "Song_RandomSongFavorites" then
		return false
	end
	if randomizerType == "Song_RandomSong" then
		return game.GameState.WorldUpgrades[songName] or config.AllSongs
	elseif randomizerType == "Song_RandomSongFavorites" then
		return game.GameState.WorldUpgrades[songName] and game.HasStoreItemPin(songName)
	end
	return false
end

modutil.mod.Path.Wrap("MusicianMusic", function(base, args)
	-- If the chosen song is Song_RandomSong and the Music Maker not already playing something, choose a random track and save it in the currentRun to reset it only after a run ends
	-- Similarly, for the Song_RandomSongFavorites
	if args.TrackName == "Song_RandomSongTrack" or args.TrackName == "Song_RandomSongFavoritesTrack" then
		local availableTracks = {}

		if game.GameState and game.GameState.WorldUpgrades then
			-- Get all eligible tracks for the randomizer
			for _, songName in ipairs(game.ScreenData.MusicPlayer.Songs) do
				if IsSongEligibleForRandomizer(songName, args.TrackName) then
					table.insert(availableTracks, game.WorldUpgradeData[songName])
				end
			end

			-- If no favorited songs exist, do not play anything
			if args.TrackName == "Song_RandomSongFavorites" and #availableTracks == 0 then
				args.TrackName = nil
				game.GameState.MusicMakerRandomizerFriendlyPlayingSong = "Nothing... (No Favorites!)"
				base(args)
				return
			end
		else
			args.TrackName = nil
			game.GameState.MusicMakerRandomizerFriendlyPlayingSong = "Nothing.."
			base(args)
			return
		end

		-- Choose a random song from the available ones
		local chosenTrack = availableTracks[game.RandomInt(1, #availableTracks)]
		-- To update the description of the Song_RandomSong to include the friendly name of the chosen track
		game.GameState.MusicMakerRandomizerFriendlyPlayingSong = game.GetDisplayName({ Text = chosenTrack.Name })

		args.TrackName = chosenTrack.TrackName
	else
		game.GameState.MusicMakerRandomizerFriendlyPlayingSong = game.GetDisplayName({ Text = game.GameState.MusicPlayerSongName})
	end

	base(args)
end)
