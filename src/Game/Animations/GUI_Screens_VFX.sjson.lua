local order = {
  "Name",
  "InheritFrom",
	"Scale"
}

local newData = {
  {
    Name = "ModsNikkelMMusicMakerRandomizerFavourite",
    InheritFrom = "FilledHeartIcon",
    Scale = 0.8
  }
}

local GuiScreensVFXFile = rom.path.combine(rom.paths.Content, 'Game/Animations/GUI_Screens_VFX.sjson')

sjson.hook(GuiScreensVFXFile, function(data)
  for _, newIcon in ipairs(newData) do
    table.insert(data.Animations, sjson.to_object(newIcon, order))
  end
end)
