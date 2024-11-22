-- Checks of any of the songs have been pinned/favorited
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
	-- This will be set to the new playing song if the selection plays a random song
	game.GameState.MusicMakerRandomizerFriendlyPlayingSong = "Nothing.."
	game.CurrentRun.MusicMakerRandomizerTrackName = nil
	game.CurrentRun.MusicMakerRandomizerTrackType = nil

	-- Do not allow playing the favorites song if there are no favorited songs (still allow pausing it)
	if game.GameState.MusicPlayerSongName ~= "Song_RandomSongFavorites" and button.Data.Name == "Song_RandomSongFavorites" and not IsAnySongFavorited() then
		-- Display the default description for the favorites song 
		game.ModifyTextBox(
			{
				Id = components.InfoBoxDescription.Id,
				Text = "Song_RandomSongFavorites",
				UseDescription = true
			}
		)

		-- Modify the voicelines that can play, excluding the ones that refer to not having enough resources
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
		-- Animate the button as if an item could not be afforded/bought
		game.ScreenCantAffordPresentation(screen, button)

		return
	end

	base(screen, button)

	-- If the selected song was a random song, update the description to display the currently playing song's name, or "Nothing..." if the player paused the random song
	if (game.GameState.MusicPlayerSongName == "Song_RandomSong" or game.GameState.MusicPlayerSongName == "Song_RandomSongFavorites" or game.GameState.MusicPlayerSongName == nil)
			and (button.Data.Name == "Song_RandomSong" or button.Data.Name == "Song_RandomSongFavorites") then

		local songItemIdentifier = "Song_RandomSong"
		if button.Data.Name == "Song_RandomSong" then
			songItemIdentifier = "Song_RandomSong_PlayingInfo"
		elseif game.GameState.MusicPlayerSongName == nil then
			songItemIdentifier = "Song_RandomSongFavorites"
		else
			songItemIdentifier = "Song_RandomSongFavorites_PlayingInfo"
		end

		game.ModifyTextBox(
			{
				Id = components.InfoBoxDescription.Id,
				Text = songItemIdentifier,
				UseDescription = true,
				LuaKey = "TempTextData",
				LuaValue = { PlayingSongFriendlyName = game.GameState.MusicMakerRandomizerFriendlyPlayingSong }
			}
		)

		-- There is a chance for Melinoe to comment on playing a random song
		if (game.GameState.MusicPlayerSongName == "Song_RandomSong" or game.GameState.MusicPlayerSongName == "Song_RandomSongFavorites") and game.RandomInt(1, 7) > 5 then
			game.PlaySpeechCue("/VO/Melinoe_2356", nil, nil, "Interrupt", false)
		end
	end
end)

-- Add the pin component to all buttons (except the random songs, they cannot be favorited), regardless of if purchased or not
-- This is for the icon that shows on the right, not the button prompt at the bottom of the screen
modutil.mod.Path.Wrap("MusicPlayerDisplayItems", function(base, screen)
	base(screen)

	-- Reset and repeat the loop from the base function. The order will be the same
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

			-- If the song has already been favorited, add the icon
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
