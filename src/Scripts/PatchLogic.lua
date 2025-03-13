modutil.mod.Path.Wrap("DoPatches", function(base)
	game.GameState.ModsNikkelMMusicMakerRandomizerFavoritedTracks = game.GameState.ModsNikkelMMusicMakerRandomizerFavoritedTracks or {}

	local modifiedStoreItemPins = false
	-- Move the pinned favorited songs into the playlist
	for index, pin in pairs(GameState.StoreItemPins) do
		if pin.StoreName == "ModsNikkelMMusicMakerRandomizerMusicPlayerFavorites" then
			if not game.Contains(game.GameState.ModsNikkelMMusicMakerRandomizerFavoritedTracks, pin.Name) then
				modifiedStoreItemPins = true
				table.insert(game.GameState.ModsNikkelMMusicMakerRandomizerFavoritedTracks, pin.Name)
				game.GameState.StoreItemPins[index] = nil
			end
		end
	end
	if modifiedStoreItemPins then
		GameState.StoreItemPins = CollapseTable(GameState.StoreItemPins)
	end

	-- If no songs are favorited, favorite the default song to have at least one
	if #game.GameState.ModsNikkelMMusicMakerRandomizerFavoritedTracks == 0 then
		table.insert(game.GameState.ModsNikkelMMusicMakerRandomizerFavoritedTracks, "Song_MainTheme")
	end

	base()
end)
