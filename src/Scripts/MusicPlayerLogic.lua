function game.ModsNikkelMMusicMakerRandomizerShuffleFavorites(screen, button)
	if not game.GameState.ModsNikkelMMusicMakerRandomizerShufflingFromFavorites then
		game.GameState.MusicPlayerPlaylist = nil
		game.GameState.ModsNikkelMMusicMakerRandomizerShufflingFromFavorites = true
	end
	game.MusicPlayerShuffle(screen, button)
end

modutil.mod.Path.Wrap("MusicPlayerShuffle", function(base, screen, button)
	-- Reset the flag if the function was not called through the favorite randomizer button
	if not button.IsFavoriteShuffleButton then
		game.GameState.MusicPlayerPlaylist = nil
		game.GameState.ModsNikkelMMusicMakerRandomizerShufflingFromFavorites = false
	end
	base(screen, button)
end)

-- Make the randomize button visible if applicable, and hide it otherwise
modutil.mod.Path.Wrap("MusicPlayerDisplayItems", function(base, screen)
	if game.GameState.WorldUpgrades.WorldUpgradeMusicPlayerShuffle then
		SetAlpha({ Id = screen.Components.ShuffleButtonFavorites.Id, Fraction = 1.0, Duration = 0.2 })
		screen.Components.ShuffleButtonFavorites.Visible = true
	else
		SetAlpha({ Id = screen.Components.ShuffleButtonFavorites.Id, Fraction = 0.0 })
	end
	base(screen)
end)

-- Add the pin component to all buttons (except the random song, which cannot be favorited), regardless of if purchased or not
-- This is for the icon that shows on the right, not the button prompt at the bottom of the screen
modutil.mod.Path.Wrap("MusicPlayerUpdateVisibility", function(base, screen, args)
	base(screen, args)

	if not game.GameState.WorldUpgradesAdded.WorldUpgradeMusicPlayerShuffle then
		return
	end

	local components = screen.Components
	local firstIndex = screen.ScrollOffset + 1
	local lastIndex = math.min(screen.NumItems, screen.ScrollOffset + screen.ItemsPerPage)

	for itemIndex = firstIndex, lastIndex, 1 do
		local itemData = screen.AvailableItems[itemIndex]
		local displayName = itemData.Name
		local purchased = GameState.WorldUpgrades[displayName]
		if not purchased then
			goto continue
		end

		local pinButtonKey = displayName .. "PinIcon"
		-- If the song already has a pin icon, destroy and rebuild it
		if components[pinButtonKey] ~= nil then
			Destroy({ Id = components[pinButtonKey].Id })
		end

		local buttonKey = displayName .. "Button"
		local button = components[buttonKey]

		-- Create a "Pin" component for the button, which will be used for the favorite icon
		local pinIcon = game.CreateScreenComponent({
			Name = "BlankObstacle",
			Group = screen.ComponentData.DefaultGroup,
			Alpha = 0.0,
			Scale = screen.PinScale,
		}) or {}
		components[pinButtonKey] = pinIcon
		table.insert(button.AssociatedIds, pinIcon.Id)

		Attach({
			Id = pinIcon.Id,
			DestinationId = button.Id,
			OffsetX = screen.PinOffsetX,
			OffsetY = game.UIData.PinIconListOffsetY + screen.PinOffsetY
		})

		button.PinButtonId = pinIcon.Id

		-- If the song has already been favorited, add the icon
		if game.Contains(game.GameState.ModsNikkelMMusicMakerRandomizerFavoritedTracks, displayName) then
			button.IsPinned = true
			SetAnimation({
				Name = "ModsNikkelMMusicMakerRandomizerFavorite",
				DestinationId = button.PinButtonId
			})
		end
		SetAlpha({ Id = button.Id, Fraction = 1.0, Duration = 0.1 })
		SetAlpha({ Ids = button.AssociatedIds, Fraction = 1.0, Duration = 0.1 })
		table.insert(screen.ButtonIds, button.Id)
		screen.ButtonIds = game.CombineTables(screen.ButtonIds, button.AssociatedIds)

		::continue::
	end
end)
