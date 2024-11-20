modutil.mod.Path.Wrap("MouseOverMusicPlayerItem", function(base, button)
	base(button)

	local components = button.Screen.Components
	-- If the random song has been bought and is currently playing, update the description with the currently playing song
	if game.GameState.WorldUpgrades["Song_RandomSong"] and game.GameState.MusicPlayerSongName == "Song_RandomSong" and button.Data.Name == "Song_RandomSong" then
		game.ModifyTextBox(
			{
				Id = components.InfoBoxDescription.Id,
				Text = "Song_RandomSong_PlayingInfo",
				UseDescription = true,
				LuaKey = "TempTextData",
				LuaValue = { PlayingSongFriendlyName = game.GameState.MusicMakerRandomizerFriendlyPlayingSong }
			}
		)
	else
		game.ModifyTextBox(
			{
				Id = components.InfoBoxDescription.Id,
				Text = button.Data.Name,
				UseDescription = true,
			}
		)
	end
end)

modutil.mod.Path.Wrap("UpdateMusicPlayerInteractionText", function(base, screen, button)
	base(screen, button)

	local components = screen.Components

	if button ~= nil and button.Data ~= nil then
		if button.Purchased then
			SetAlpha({ Id = components.PinButton.Id, Fraction = 1.0, Duration = 0.2 })
			ModifyTextBox({ Id = components.PinButton.Id, Text = "ModsNikkelMMusicMakerRandomizerFavouriteButton"})
		else
			-- We need to reset the button's text in case the player is hovering over an unbought song
			ModifyTextBox({ Id = components.PinButton.Id, Text = "Menu_Pin"})
		end
	end
end)
