-- Makes sure the favorited button prompt text is shown for purchased songs, and the pin prompt for others
modutil.mod.Path.Wrap("UpdateMusicPlayerInteractionText", function(base, screen, button)
	base(screen, button)

	if not game.GameState.WorldUpgradesAdded.WorldUpgradeMusicPlayerShuffle then
		return
	end

	local components = screen.Components

	if button ~= nil and button.Data ~= nil then
		local buttonName = button.Data.Name
		if button.Purchased and buttonName ~= "Song_RandomSongFavorites" then
			SetAlpha({ Id = components.PinButton.Id, Fraction = 1.0, Duration = 0.2 })
			if game.Contains(game.GameState.ModsNikkelMMusicMakerRandomizerFavoritedTracks, buttonName) then
				ModifyTextBox({ Id = components.PinButton.Id, Text = "ModsNikkelMMusicMakerRandomizerRemoveFavoriteButton" })
			else
				ModifyTextBox({ Id = components.PinButton.Id, Text = "ModsNikkelMMusicMakerRandomizerFavoriteButton" })
			end
		elseif not button.Purchased then
			-- We need to reset the button's text to the default pin behaviour in case the player is hovering over an unpurchased song
			ModifyTextBox({ Id = components.PinButton.Id, Text = "Menu_Pin" })
		end
	end
end)


modutil.mod.Path.Wrap("MusicPlayerShufflePresentation", function(base, source, button)
	base(source, button)
	SetAlpha({ Id = source.Components.ShuffleButtonFavorites.Id, Fraction = 0.0 })
	SetAlpha({ Id = source.Components.ShuffleButtonFavorites.Id, Fraction = 1.0, Duration = 1.5, EaseOut = 1.0 })
end)
