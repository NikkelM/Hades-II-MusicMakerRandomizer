-- When the player presses the pin button on an unlocked song, (un)favorite it instead of pinning
modutil.mod.Path.Wrap("GhostAdminPinItem", function(base, screen, button)
	if screen.SelectedItem == nil or not game.GameState.WorldUpgradesAdded.WorldUpgradeMusicPlayerShuffle then
		base(screen, button)
		return
	end

	local itemName = screen.SelectedItem.Data.Name
	if game.Contains(game.ScreenData.MusicPlayer.Songs, itemName) and game.Contains(game.GameState.UnlockedMusicPlayerSongs, itemName) then
		-- The song is not yet favorited
		if not game.Contains(game.GameState.ModsNikkelMMusicMakerRandomizerFavoritedTracks, itemName) then
			table.insert(game.GameState.ModsNikkelMMusicMakerRandomizerFavoritedTracks, itemName)
			game.AddStoreItemPinPresentation(screen.SelectedItem,
				{ AnimationName = "ModsNikkelMMusicMakerRandomizerFavorite", SkipVoice = true, SkipToolTip = true })

			-- Remove the tooltip
			DestroyTextBox({ Id = screen.SelectedItem.Id, AffectText = "StoreItemPinTooltip", RemoveTooltips = true })
			-- Update the pin button text to reflect the change
			ModifyTextBox({ Id = button.Id, Text = "ModsNikkelMMusicMakerRandomizerRemoveFavoriteButton" })
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
		end
		return
	end

	base(screen, button)
end)
