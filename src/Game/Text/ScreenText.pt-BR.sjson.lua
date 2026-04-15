-- Used as a replacement for the Forget-Me-Not pin button prompt
local order = {
  "Id",
  "DisplayName"
}

local newData = {
  -- The character limit for DisplayNames is 20 after the {XX}
  -- {
  --   Id = "ModsNikkelMMusicMakerRandomizerFavoriteButton",
  --   DisplayName = "{IP} ADD TO FAVORITES"
  -- },
  -- {
  --   Id = "ModsNikkelMMusicMakerRandomizerRemoveFavoriteButton",
  --   DisplayName = "{IP} REMOVE FAVORITE"
  -- },
  -- {
  --   Id = "ModsNikkelMMusicMakerRandomizerShuffleFavorites",
  --   DisplayName = "{V} RANDOMIZE FAVORITES"
  -- },
}
-- {V} Inventory
-- {CX} Codex (Issues for controller default mapping)

local screenTextFile = rom.path.combine(rom.paths.Content, 'Game/Text/pt-BR/ScreenText.pt-BR.sjson')

sjson.hook(screenTextFile, function(data)
  for _, newCommand in ipairs(newData) do
    table.insert(data.Texts, sjson.to_object(newCommand, order))
  end
end)
