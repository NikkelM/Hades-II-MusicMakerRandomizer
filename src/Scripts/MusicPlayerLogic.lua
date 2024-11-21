local function IsAnySongFavorited()
	local favoritedTracks = {}
	for _, songName in ipairs(game.ScreenData.MusicPlayer.Songs) do
		if (songName ~= "Song_RandomSong" and songName ~= "Song_RandomSongFavorites") and game.GameState.WorldUpgrades[songName] and game.HasStoreItemPin(songName) then
			table.insert(favoritedTracks, game.WorldUpgradeData[songName])
		end
	end
	return #favoritedTracks > 0
end

modutil.mod.Path.Wrap("SelectMusicPlayerItem", function(base, screen, button)
	local components = button.Screen.Components
	-- When the player pauses the random song, reset the chosen track so a new one can be chosen
	game.GameState.MusicMakerRandomizerFriendlyPlayingSong = "Nothing.."

	-- Do not allow playing the favorites song if there are no favorited songs (still allow pausing it)
	if game.GameState.MusicPlayerSongName ~= "Song_RandomSongFavorites" and button.Data.Name == "Song_RandomSongFavorites" and not IsAnySongFavorited() then
		game.ModifyTextBox(
			{
				Id = components.InfoBoxDescription.Id,
				Text = "Song_RandomSongFavorites",
				UseDescription = true,
				LuaKey = "TempTextData",
				LuaValue = { PlayingSongFriendlyName = game.GameState.MusicMakerRandomizerFriendlyPlayingSong }
			}
		)

		button.Data.CannotAffordVoiceLines =
		{
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
		game.ScreenCantAffordPresentation(screen, button)

		return
	end

	base(screen, button)

	if (game.GameState.MusicPlayerSongName == "Song_RandomSong" or game.GameState.MusicPlayerSongName == "Song_RandomSongFavorites" or game.GameState.MusicPlayerSongName == nil)
			and (button.Data.Name == "Song_RandomSong" or button.Data.Name == "Song_RandomSongFavorites") then
		-- Update the description with the new currently playing song, or "Nothing..." if the player paused the random song
		-- Use the base text for the favorites song if there are no favorites

		local text = ""
		if button.Data.Name == "Song_RandomSong" then
			text = "Song_RandomSong_PlayingInfo"
		elseif game.GameState.MusicPlayerSongName == nil then
			text = "Song_RandomSongFavorites"
		else
			text = "Song_RandomSongFavorites_PlayingInfo"
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

		if (game.GameState.MusicPlayerSongName == "Song_RandomSong" or game.GameState.MusicPlayerSongName == "Song_RandomSongFavorites") and game.RandomInt(1, 7) > 5 then
			game.PlaySpeechCue("/VO/Melinoe_2356", nil, nil, "Interrupt", false)
		end
	end
end)

-- Do not play the song if the player buys the favorites song and there are no favorited songs
modutil.mod.Path.Wrap("DoMusicPlayerPurchase", function(base, screen, button)
	if button.Data.Name == "Song_RandomSongFavorites" then
		-- Always favorite the song itself
		game.AddStoreItemPin("Song_RandomSongFavorites", "ModsNikkelMMusicMakerRandomizerMusicPlayerFavorites")
		game.AddStoreItemPinPresentation(screen.SelectedItem,
			{ AnimationName = "ModsNikkelMMusicMakerRandomizerFavorite", SkipVoice = true })
		-- Remove the tooltip
		DestroyTextBox({ Id = screen.SelectedItem.Id, AffectText = "StoreItemPinTooltip", RemoveTooltips = true })

		-- If no other songs are favorited, don't play anything
		if not IsAnySongFavorited() then
			local itemData = button.Data
			game.SpendResources(itemData.Cost, itemData.Name, { Silent = true })
			game.MusicPlayerPurchasePreActivatePresentation(screen, button, itemData)
			game.MusicPlayerPurchasePostActivatePresentation(screen, button, itemData)
			game.OpenMusicPlayerScreen(screen.OpenedFrom,
				{ InitialScrollOffset = screen.ScrollOffset, SkipInitialDelay = true })
		end
		return
	end

	base(screen, button)
end)

-- Add the pin component to all buttons (except the random songs, they cannot be favorited), regardless if purchased or not
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
			if components[pinButtonKey] ~= nil or songName == "Song_RandomSong" then
				goto continue
			end

			local purchaseButtonKey = "PurchaseButton" .. screen.NumItems
			local button = components[purchaseButtonKey]

			-- Create a "Pin" component for the button, which will be used for the favorite icon
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

			-- The song has already been favorited, add the icon
			if game.HasStoreItemPin(button.Data.Name) then
				components[purchaseButtonKey].IsPinned = true
				SetAnimation({
					Name = "ModsNikkelMMusicMakerRandomizerFavorite",
					DestinationId = components[purchaseButtonKey].PinButtonId
				})
			end
		end

		::continue::
	end
end)
