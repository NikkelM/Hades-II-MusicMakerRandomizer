-- When the player presses the pin button on an unlocked song, (un)favorite it instead of pinning
modutil.mod.Path.Wrap("GhostAdminPinItem", function(base, screen, button)
	if screen.SelectedItem == nil or not game.GameState.WorldUpgradesAdded.WorldUpgradeMusicPlayerShuffle then
		base(screen, button)
		return
	end

	local itemName = screen.SelectedItem.Data.Name
	if game.Contains(game.ScreenData.MusicPlayer.Songs, itemName) and game.Contains(game.GameState.UnlockedMusicPlayerSongs, itemName) and itemName ~= "Song_RandomSongFavorites" then
		-- The song is not yet favorited
		if not game.Contains(game.GameState.ModsNikkelMMusicMakerRandomizerFavoritedTracks, itemName) then
			table.insert(game.GameState.ModsNikkelMMusicMakerRandomizerFavoritedTracks, itemName)
			game.AddStoreItemPinPresentation(screen.SelectedItem,
				{ AnimationName = "ModsNikkelMMusicMakerRandomizerFavorite", SkipVoice = true, SkipToolTip = true })

			-- Remove the tooltip
			DestroyTextBox({ Id = screen.SelectedItem.Id, AffectText = "StoreItemPinTooltip", RemoveTooltips = true })
			-- Update the pin button text to reflect the change
			ModifyTextBox({ Id = button.Id, Text = "ModsNikkelMMusicMakerRandomizerRemoveFavoriteButton" })

			-- Change the text color of the favorite song to be "affordable", if not yet purchased and all requirements are met
			if not game.Contains(game.GameState.UnlockedMusicPlayerSongs, "Song_RandomSongFavorites") then
				for _, screenButton in pairs(screen.Components) do
					if screenButton.Data and screenButton.Data.Name == "Song_RandomSongFavorites" then
						-- Check that all required resources are available, and if one isn't, skip the color change
						local canAfford = true
						for resourceName, resourceCost in pairs(screenButton.Data.Cost) do
							if (game.GameState.Resources[resourceName] or 0) < resourceCost then
								canAfford = false
								break
							end
						end
						-- Change the text color to mark the song as "affordable"
						if canAfford then
							ModifyTextBox({ Id = screenButton.Id, Color = { 85, 202, 152, 255 } })
						end
						break
					end
				end
			end
		else
			-- Only allow unfavoriting if at least one remaining favorite will be left
			if #game.GameState.ModsNikkelMMusicMakerRandomizerFavoritedTracks <= 1 then
				-- Flash both the "Remove Favorite" and song button red
				button.Data.CannotAffordVoiceLines = {
					BreakIfPlayed = true,
					RandomRemaining = true,
					PreLineWait = 0.15,
					Cooldowns =
					{
						{ Name = "MelinoeAnyQuipSpeech" },
						{ Name = "MelinoeResourceInteractionSpeech", Time = 6 },
					},
					{ Cue = "/VO/Melinoe_0386", Text = "I can't." },
					{ Cue = "/VO/Melinoe_0390", Text = "No use." },
					{ Cue = "/VO/Melinoe_0222", Text = "Can't." },
					{ Cue = "/VO/Melinoe_1854", Text = "Afraid not..." },
					{ Cue = "/VO/Melinoe_1855", Text = "Denied." },
					{ Cue = "/VO/Melinoe_1856", Text = "Denied..." },
				}
				game.thread(game.ScreenCantAffordPresentation, screen, button, {})
				button = screen.Components[itemName .. "Button"]
				game.ScreenCantAffordPresentation(screen, button, {})
				return
			end

			game.RemoveValueAndCollapse(game.GameState.ModsNikkelMMusicMakerRandomizerFavoritedTracks, itemName)
			game.RemoveStoreItemPinPresentation(screen.SelectedItem)
			ModifyTextBox({ Id = button.Id, Text = "ModsNikkelMMusicMakerRandomizerFavoriteButton" })

			-- Change the text color of the favorite song to be "unaffordable", if not yet purchased and no favorites exist
			-- Other resource costs can be disregarded here, as just this check is enough
			if not game.GameState.UnlockedMusicPlayerSongs.Song_RandomSongFavorites and #game.GameState.ModsNikkelMMusicMakerRandomizerFavoritedTracks == 0 then
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
