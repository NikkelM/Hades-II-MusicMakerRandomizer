modutil.mod.Path.Wrap("DoPatches", function(base)
	if game.GameState ~= nil then
		game.GameState.ModsNikkelMMusicMakerRandomizerFavoritedTracks = game.GameState
				.ModsNikkelMMusicMakerRandomizerFavoritedTracks or {}

		local modifiedStoreItemPins = false
		-- Move the pinned favorited songs into the playlist
		for index, pin in pairs(game.GameState.StoreItemPins) do
			if pin.StoreName == "ModsNikkelMMusicMakerRandomizerMusicPlayerFavorites" then
				if not game.Contains(game.GameState.ModsNikkelMMusicMakerRandomizerFavoritedTracks, pin.Name) then
					modifiedStoreItemPins = true
					table.insert(game.GameState.ModsNikkelMMusicMakerRandomizerFavoritedTracks, pin.Name)
					game.GameState.StoreItemPins[index] = nil
				end
			end
		end
		if modifiedStoreItemPins then
			game.GameState.StoreItemPins = game.CollapseTable(game.GameState.StoreItemPins)
		end

		-- Clean out any favorited songs whose data no longer exists (e.g. an uninstalled or updated mod)
		local favoritedTracks = game.GameState.ModsNikkelMMusicMakerRandomizerFavoritedTracks
		for index = #favoritedTracks, 1, -1 do
			if not game.WorldUpgradeData[favoritedTracks[index]] then
				table.remove(favoritedTracks, index)
			end
		end

		-- Keep at least one valid favorite so shuffling favorites always has something to play
		if #favoritedTracks == 0 then
			table.insert(favoritedTracks, "Song_MainTheme")
		end

		-- Also remove any outdated songs from the existing playlist if one exists
		if game.GameState.ModsNikkelMMusicMakerRandomizerShufflingFromFavorites and game.GameState.MusicPlayerPlaylist ~= nil then
			for index = #game.GameState.MusicPlayerPlaylist, 1, -1 do
				if not game.WorldUpgradeData[game.GameState.MusicPlayerPlaylist[index]] then
					table.remove(game.GameState.MusicPlayerPlaylist, index)
				end
			end

			if #game.GameState.MusicPlayerPlaylist == 0 then
				table.insert(game.GameState.MusicPlayerPlaylist, "Song_MainTheme")
			end
		end
	end

	return base()
end)
