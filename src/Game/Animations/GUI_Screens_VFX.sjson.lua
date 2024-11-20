local order = {
  "Name",
  "InheritFrom",
  "Scale"
}

local newData = {
  {
    Name = "ModsNikkelMMusicMakerRandomizerFavorite",
    InheritFrom = "FilledHeartIcon",
    -- Scaling and offset is influenced by the default pin icon's values
    Scale = 0.7,
    OffsetX = -5,
    OffsetY = 15
  }
}

local GuiScreensVFXFile = rom.path.combine(rom.paths.Content, 'Game/Animations/GUI_Screens_VFX.sjson')

sjson.hook(GuiScreensVFXFile, function(data)
  for _, newIcon in ipairs(newData) do
    table.insert(data.Animations, sjson.to_object(newIcon, order))
  end
end)
