-- When the player presses the pin button on an unlocked song, favourite it instead of pinning
modutil.mod.Path.Wrap("GhostAdminPinItem", function(base, screen, button)
	if screen.SelectedItem == nil then
		return
	end

	local itemName = screen.SelectedItem.Data.Name
	if game.Contains(game.ScreenData.MusicPlayer.Songs, itemName) and game.GameState.WorldUpgradesAdded[itemName] then
		print("Found song")
		SetAlpha({ Id = button.NewButtonId, Fraction = 1.0, Duration = 0.2 })
		game.AddStoreItemPinPresentation(screen.SelectedItem, { AnimationName = "ModsNikkelMMusicMakerRandomizerFavourite", SkipVoice = true })
		DestroyTextBox({ Id = screen.SelectedItem.Id, AffectText = "StoreItemPinTooltip", RemoveTooltips = true })
		-- RemoveStoreItemPinPresentation
		return
	end

	base(screen, button)
end)



-- To be added to a button like this: MusicPlayerLogic, line 165
--[[
if not GameState.WorldUpgradesViewed[songData.Name] then
	local newIconKey = "NewIcon"..screen.NumItems
	components[newIconKey] = CreateScreenComponent({ Name = "BlankObstacle", Group = screen.ComponentData.DefaultGroup, Alpha = 0.0, Animation = "ModsNikkelMMusicMakerRandomizerFavourite" })
	Attach({ Id = components[newIconKey].Id, DestinationId = components[purchaseButtonKey].Id, OffsetX = 300, OffsetY = 0 })
	components[purchaseButtonKey].NewButtonId = components[newIconKey].Id
end

-- To "remove" - set alpha to 0.0
SetAlpha({ Id = button.NewButtonId, Fraction = 0, Duration = 0.2 })


function AddStoreItemPinPresentation( selectedItem, args )
	args = args or {}
	selectedItem.IsPinned = true
	local animationName = args.AnimationName or "StoreItemPin"
	SetAnimation({ Name = animationName, DestinationId = selectedItem.PinButtonId })
	SetAlpha({ Id = selectedItem.PinButtonId, Fraction = 1.0, Duration = 0.2 })
	PlaySound({ Name = "/SFX/Menu Sounds/VictoryScreenBoonPin", Id = selectedItem.PinButtonId })

	if not args.SkipVoice then
		thread( PlayVoiceLines, GlobalVoiceLines.PinnedItemVoiceLines, true )
	end

	-- Silent toolip if it wasn't already added
	CreateTextBox({ Id = selectedItem.Id, TextSymbolScale = 0, Text = "StoreItemPinTooltip", Color = Color.Transparent, })
end

-- TODO: How to make sure it can be toggled multiple times in the same menu open event?
]]
