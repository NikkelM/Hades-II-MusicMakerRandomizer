local order = {
  "Id",
  "DisplayName",
  "Description"
}

local newData = {
  {
    Id = "Song_RandomSong_PlayingInfo",
    DisplayName = "Music Maker's choice",
    Description =
    "Allow the Music Maker to choose a new song for you each time you return to the crossroads.\n Now playing {#ItalicFormat}{$TempTextData.PlayingSongFriendlyName}{#prev}."
  },
  {
    Id = "Song_RandomSong",
    DisplayName = "Music Maker's choice",
    Description = "Allow the Music Maker to choose a new song for you each time you return to the crossroads."
  }
}

local helpTextFile = rom.path.combine(rom.paths.Content, 'Game/Text/en/HelpText.en.sjson')

sjson.hook(helpTextFile, function(data)
  for _, newSong in ipairs(newData) do
    table.insert(data.Texts, sjson.to_object(newSong, order))
  end
end)
