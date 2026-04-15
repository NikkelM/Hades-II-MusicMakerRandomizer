-- Used as a replacement for the Forget-Me-Not pin button prompt
local order = {
  "Id",
  "DisplayName"
}

local newData = {
  {
    Id = "ModsNikkelMMusicMakerRandomizerFavoriteButton",
    DisplayName = "{IP} ALS FAVORIT HINZUFÜGEN"
  },
  {
    Id = "ModsNikkelMMusicMakerRandomizerRemoveFavoriteButton",
    DisplayName = "{IP} FAVORIT ENTFERNEN"
  },
  {
    Id = "ModsNikkelMMusicMakerRandomizerShuffleFavorites",
    DisplayName = "{V} ZUFÄLLIG AUS FAVORITEN"
  },
}
-- {V} Inventory
-- {CX} Codex (Issues for controller default mapping)

local screenTextFile = rom.path.combine(rom.paths.Content, 'Game/Text/de/ScreenText.de.sjson')

sjson.hook(screenTextFile, function(data)
  for _, newCommand in ipairs(newData) do
    table.insert(data.Texts, sjson.to_object(newCommand, order))
  end
end)
