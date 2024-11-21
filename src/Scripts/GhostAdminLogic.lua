-- When the player presses the pin button on an unlocked song, (un)favorite it instead of pinning
modutil.mod.Path.Wrap("GhostAdminPinItem", function(base, screen, button)
	if screen.SelectedItem == nil then
		return
	end

	local itemName = screen.SelectedItem.Data.Name
	if game.Contains(game.ScreenData.MusicPlayer.Songs, itemName) and game.GameState.WorldUpgradesAdded[itemName] then
		-- These two songs cannot be favorited
		if itemName == "Song_RandomSong" or itemName == "Song_RandomSongFavorites" then
			return
		end

		if not game.HasStoreItemPin(itemName) then
			-- Increase the favorite song resource count
			game.GameState.Resources["ModsNikkelMMusicMakerRandomizerMusicPlayerFavoritesCount"] = (game.GameState.Resources["ModsNikkelMMusicMakerRandomizerMusicPlayerFavoritesCount"] or 0) + 1
			-- Pin/Favorite the song
			game.AddStoreItemPin(itemName, "ModsNikkelMMusicMakerRandomizerMusicPlayerFavorites")
			-- The animation is the icon that shows, this is a modified heart icon
			game.AddStoreItemPinPresentation(screen.SelectedItem,
				{ AnimationName = "ModsNikkelMMusicMakerRandomizerFavorite", SkipVoice = true })

			-- Remove the tooltip
			DestroyTextBox({ Id = screen.SelectedItem.Id, AffectText = "StoreItemPinTooltip", RemoveTooltips = true })
			-- Update the pin button text to reflect the change
			ModifyTextBox({ Id = button.Id, Text = "ModsNikkelMMusicMakerRandomizerRemoveFavoriteButton" })
			-- Change the text color of the favorite song to be "affordable", if not yet purchased
			if not game.GameState.WorldUpgradesAdded["Song_RandomSongFavorites"] then
				for _, screenButton in pairs(screen.Components) do
					if screenButton.Data and screenButton.Data.Name == "Song_RandomSongFavorites" then
						ModifyTextBox({ Id = screenButton.Id, Color = { 85, 202, 152, 255 } })
						break
					end
				end
			end

		else
			game.GameState.Resources["ModsNikkelMMusicMakerRandomizerMusicPlayerFavoritesCount"] = (game.GameState.Resources["ModsNikkelMMusicMakerRandomizerMusicPlayerFavoritesCount"] or 1) - 1
			game.RemoveStoreItemPin(itemName)
			game.RemoveStoreItemPinPresentation(screen.SelectedItem)
			ModifyTextBox({ Id = button.Id, Text = "ModsNikkelMMusicMakerRandomizerFavoriteButton" })

			-- Change the text color of the favorite song to be "unaffordable", if not yet purchased and no favorites exist
			if not game.GameState.WorldUpgradesAdded["Song_RandomSongFavorites"] and game.GameState.Resources["ModsNikkelMMusicMakerRandomizerMusicPlayerFavoritesCount"] < 1 then
				for _, screenButton in pairs(screen.Components) do
					if screenButton.Data and screenButton.Data.Name == "Song_RandomSongFavorites" then
						ModifyTextBox({ Id = screenButton.Id, Color = game.Color.CostUnffordableShop })
						break
					end
				end
			end
		end
		return
	end

	base(screen, button)
end)
