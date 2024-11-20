local order = {
  "Name",
  "InheritFrom",
	"Scale"
}

local newData = {
  {
    Name = "ModsNikkelMMusicMakerRandomizerFavourite",
    InheritFrom = "FilledHeartIcon",
    Scale = 0.35
  }
}

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

-- TODO: How to make sure it can be toggled multiple times in the same menu open event?
]]

local helpTextFile = rom.path.combine(rom.paths.Content, 'Game/Animations/GUI_Screens_VFX.sjson')

sjson.hook(helpTextFile, function(data)
  for _, newIcon in ipairs(newData) do
    table.insert(data.Animations, sjson.to_object(newIcon, order))
  end
end)
