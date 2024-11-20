local order = {
  "Id",
  "DisplayName"
}

local newData = {
  {
    Id = "ModsNikkelMMusicMakerRandomizerFavoriteButton",
    DisplayName = "{IP} SET AS FAVOURITE"
  },
  {
    Id = "ModsNikkelMMusicMakerRandomizerRemoveFavoriteButton",
    DisplayName = "{IP} REMOVE FAVOURITE"
  }
}

local screenTextFile = rom.path.combine(rom.paths.Content, 'Game/Text/en/ScreenText.en.sjson')

sjson.hook(screenTextFile, function(data)
  for _, newCommand in ipairs(newData) do
    table.insert(data.Texts, sjson.to_object(newCommand, order))
  end
end)
