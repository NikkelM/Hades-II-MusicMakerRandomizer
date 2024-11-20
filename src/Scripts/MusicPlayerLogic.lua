modutil.mod.Path.Wrap("SelectMusicPlayerItem", function(base, screen, button)
	-- When the player pauses the random song, reset the chosen track so a new one can be chosen
	game.GameState.MusicMakerRandomizerFriendlyPlayingSong = "Nothing.."

	base(screen, button)

	if (game.GameState.MusicPlayerSongName == "Song_RandomSong" or game.GameState.MusicPlayerSongName == "Song_RandomSongFavourites" or game.GameState.MusicPlayerSongName == nil)
			and (button.Data.Name == "Song_RandomSong" or button.Data.Name == "Song_RandomSongFavourites") then
		-- Update the description with the new currently playing song, or "Nothing..." if the player paused the random song
		local components = button.Screen.Components

		local text = ""
		if button.Data.Name == "Song_RandomSong" then
			text = "Song_RandomSong_PlayingInfo"
		else
			text = "Song_RandomSongFavourites_PlayingInfo"
		end

		game.ModifyTextBox(
			{
				Id = components.InfoBoxDescription.Id,
				Text = text,
				UseDescription = true,
				LuaKey = "TempTextData",
				LuaValue = { PlayingSongFriendlyName = game.GameState.MusicMakerRandomizerFriendlyPlayingSong }
			}
		)

		if (game.GameState.MusicPlayerSongName == "Song_RandomSong" or game.GameState.MusicPlayerSongName == "Song_RandomSongFavourites") and game.RandomInt(1, 7) > 5 then
			game.PlaySpeechCue("/VO/Melinoe_2356", nil, nil, "Interrupt", false)
		end
	end
end)

-- Add the pin component to all buttons (except the random songs, they cannot be favourited), regardless if purchased or not
-- This if for the icon that shows on the right, not the button prompt
modutil.mod.Path.Wrap("MusicPlayerDisplayItems", function(base, screen)
	base(screen)

	-- Repeat the loop from the base function. The order will be the same
	screen.NumItems = 0
	local components = screen.Components

	for i, songName in ipairs(screen.Songs) do
		local songData = game.WorldUpgradeData[songName]

		-- If the song has not been discovered yet, skip it
		if songData.GameStateRequirements == nil or game.IsGameStateEligible(songData, songData.GameStateRequirements) then
			screen.NumItems = screen.NumItems + 1
			local pinButtonKey = "PinIcon" .. screen.NumItems

			-- If the song already has a pin icon, skip it
			if components[pinButtonKey] ~= nil or songName == "Song_RandomSong" or songName == "Song_RandomSongFavourites" then
				goto continue
			end

			local purchaseButtonKey = "PurchaseButton" .. screen.NumItems
			local button = components[purchaseButtonKey]

			-- Create a "Pin" component for the button, which will be used for the favourite icon
			components[pinButtonKey] = game.CreateScreenComponent({
				Name = "BlankObstacle",
				Group = screen.ComponentData.DefaultGroup,
				Alpha = 0.0,
				Scale = screen.PurchaseButtonScaleY
			})

			Attach({
				Id = components[pinButtonKey].Id,
				DestinationId = components[purchaseButtonKey].Id,
				OffsetX = screen.PinOffsetX,
				OffsetY = game.UIData.PinIconListOffsetY * screen.PurchaseButtonScaleY
			})

			components[purchaseButtonKey].PinButtonId = components[pinButtonKey].Id

			-- The song has already been favourited, add the icon
			if game.HasStoreItemPin(button.Data.Name) then
				components[purchaseButtonKey].IsPinned = true
				SetAnimation({
					Name = "ModsNikkelMMusicMakerRandomizerFavourite",
					DestinationId = components[purchaseButtonKey].PinButtonId
				})
			end
		end

		::continue::
	end
end)
