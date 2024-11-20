-- When the player presses the pin button on an unlocked song, (un)favourite it instead of pinning
modutil.mod.Path.Wrap("GhostAdminPinItem", function(base, screen, button)
	if screen.SelectedItem == nil then
		return
	end

	local itemName = screen.SelectedItem.Data.Name
	if game.Contains(game.ScreenData.MusicPlayer.Songs, itemName) and game.GameState.WorldUpgradesAdded[itemName] then
		if not game.HasStoreItemPin(itemName) then
			game.AddStoreItemPin(itemName, "ModsNikkelMMusicMakerRandomizerMusicPlayerFavourites")
			game.AddStoreItemPinPresentation(screen.SelectedItem,
				{ AnimationName = "ModsNikkelMMusicMakerRandomizerFavourite", SkipVoice = true })
			DestroyTextBox({ Id = screen.SelectedItem.Id, AffectText = "StoreItemPinTooltip", RemoveTooltips = true })
		else
			game.RemoveStoreItemPin(itemName)
			game.RemoveStoreItemPinPresentation(screen.SelectedItem)
		end
		return
	end

	base(screen, button)
end)
