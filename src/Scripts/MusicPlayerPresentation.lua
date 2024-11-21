-- When hovering over a random song, if it is currently playing, update the description with the currently playing song's name
modutil.mod.Path.Wrap("MouseOverMusicPlayerItem", function(base, button)
	base(button)

	local components = button.Screen.Components
	local songName = game.GameState.MusicPlayerSongName
	local buttonName = button.Data.Name
	local textKey = nil

	-- Select the corresponding text key based on the song and button names
	if game.GameState.WorldUpgrades["Song_RandomSong"] and songName == "Song_RandomSong" and buttonName == "Song_RandomSong" then
		textKey = "Song_RandomSong_PlayingInfo"
	elseif game.GameState.WorldUpgrades["Song_RandomSongFavorites"] and songName == "Song_RandomSongFavorites" and buttonName == "Song_RandomSongFavorites" then
		textKey = "Song_RandomSongFavorites_PlayingInfo"
	else
		textKey = buttonName
	end

	local textBoxData = {
		Id = components.InfoBoxDescription.Id,
		Text = textKey,
		UseDescription = true,
		LuaKey = "TempTextData",
		LuaValue = { PlayingSongFriendlyName = game.GameState.MusicMakerRandomizerFriendlyPlayingSong }
	}

	game.ModifyTextBox(textBoxData)
end)

-- Makes sure the favorited button prompt text is shown for purchased songs, and the pin prompt for others
modutil.mod.Path.Wrap("UpdateMusicPlayerInteractionText", function(base, screen, button)
	base(screen, button)

	local components = screen.Components

	if button ~= nil and button.Data ~= nil then
		if button.Purchased and not (button.Data.Name == "Song_RandomSong" or button.Data.Name == "Song_RandomSongFavorites") then
			SetAlpha({ Id = components.PinButton.Id, Fraction = 1.0, Duration = 0.2 })
			if game.HasStoreItemPin(button.Data.Name) then
				ModifyTextBox({ Id = components.PinButton.Id, Text = "ModsNikkelMMusicMakerRandomizerRemoveFavoriteButton" })
			else
				ModifyTextBox({ Id = components.PinButton.Id, Text = "ModsNikkelMMusicMakerRandomizerFavoriteButton" })
			end
		else
			-- We need to reset the button's text to the default pin behaviour in case the player is hovering over an unpurchased song
			ModifyTextBox({ Id = components.PinButton.Id, Text = "Menu_Pin" })
		end
	end
end)
