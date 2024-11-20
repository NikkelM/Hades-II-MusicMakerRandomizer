modutil.mod.Path.Wrap("SelectMusicPlayerItem", function(base, screen, button)
	-- When the player pauses the random song, reset the chosen track so a new one can be chosen
	game.CurrentRun.MusicMakerRandomizerTrackName = nil
	game.GameState.MusicMakerRandomizerFriendlyPlayingSong = "Nothing.."

	base(screen, button)

	if (game.GameState.MusicPlayerSongName == "Song_RandomSong" or game.GameState.MusicPlayerSongName == nil) and button.Data.Name == "Song_RandomSong" then
		-- Update the description with the new currently playing song, or "Nothing..." if the player paused the random song
		local components = button.Screen.Components
		game.ModifyTextBox(
			{
				Id = components.InfoBoxDescription.Id,
				Text = "Song_RandomSong_PlayingInfo",
				UseDescription = true,
				LuaKey = "TempTextData",
				LuaValue = { PlayingSongFriendlyName = game.GameState.MusicMakerRandomizerFriendlyPlayingSong }
			}
		)

		if game.GameState.MusicPlayerSongName == "Song_RandomSong" and game.RandomInt(1, 7) > 5 then
			game.PlaySpeechCue("/VO/Melinoe_2356", nil, nil, "Interrupt", false)
		end
	end
end)

-- Add the pin component to all buttons, regardless if purchased or not
modutil.mod.Path.Wrap("MusicPlayerDisplayItems", function(base, screen)
	base(screen)

	screen.NumItems = 0
	local components = screen.Components

	for i, songName in ipairs(screen.Songs) do
		local songData = game.WorldUpgradeData[songName]
		print(songName)
		if songData.GameStateRequirements == nil or game.IsGameStateEligible(songData, songData.GameStateRequirements) then
			screen.NumItems = screen.NumItems + 1
			local pinButtonKey = "PinIcon" .. screen.NumItems
			print(pinButtonKey)

			if components[pinButtonKey] ~= nil then
				print("Pin button already exists")
				print(pinButtonKey)
				goto continue
			end

			local purchaseButtonKey = "PurchaseButton" .. screen.NumItems
			local button = components[purchaseButtonKey]

			-- Pin icon
			components[pinButtonKey] = game.CreateScreenComponent({
				Name = "BlankObstacle",
				Group = screen.ComponentData
						.DefaultGroup,
				Alpha = 0.0,
				Scale = screen.PurchaseButtonScaleY
			})
			Attach({
				Id = components[pinButtonKey].Id,
				DestinationId = components[purchaseButtonKey].Id,
				OffsetX = screen
						.PinOffsetX,
				OffsetY = game.UIData.PinIconListOffsetY * screen.PurchaseButtonScaleY
			})
			components[purchaseButtonKey].PinButtonId = components[pinButtonKey].Id
			if game.HasStoreItemPin(button.Data.Name) then
				components[purchaseButtonKey].IsPinned = true
				SetAnimation({ Name = "StoreItemPin", DestinationId = components[purchaseButtonKey].PinButtonId })
				-- Silent toolip
				game.CreateTextBox({ Id = button.Id, TextSymbolScale = 0, Text = "StoreItemPinTooltip", Color = game.Color
				.Transparent, })
			end
		end
		::continue::
	end
end)
