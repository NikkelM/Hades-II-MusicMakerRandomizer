-- When the player presses the pin button on an unlocked song, (un)favorite it instead of pinning
modutil.mod.Path.Wrap("GhostAdminPinItem", function(base, screen, button)
	if screen.SelectedItem == nil then
		return
	end

	local itemName = screen.SelectedItem.Data.Name
	if game.Contains(game.ScreenData.MusicPlayer.Songs, itemName) and game.GameState.WorldUpgradesAdded[itemName] then
		if not game.HasStoreItemPin(itemName) then
			game.AddStoreItemPin(itemName, "ModsNikkelMMusicMakerRandomizerMusicPlayerFavorites")
			game.AddStoreItemPinPresentation(screen.SelectedItem,
				{ AnimationName = "ModsNikkelMMusicMakerRandomizerFavorite", SkipVoice = true })
			DestroyTextBox({ Id = screen.SelectedItem.Id, AffectText = "StoreItemPinTooltip", RemoveTooltips = true })
			-- Update the pin button text to reflect the change
			ModifyTextBox({ Id = button.Id, Text = "ModsNikkelMMusicMakerRandomizerRemoveFavoriteButton" })
		else
			game.RemoveStoreItemPin(itemName)
			game.RemoveStoreItemPinPresentation(screen.SelectedItem)
			ModifyTextBox({ Id = button.Id, Text = "ModsNikkelMMusicMakerRandomizerFavoriteButton" })
		end
		return
	end

	base(screen, button)
end)
