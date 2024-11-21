local order = {
  "Id",
  "DisplayName",
  "Description"
}

local newData = {
  {
    Id = "Song_RandomSong_PlayingInfo",
    DisplayName = "Music Maker's Choice",
    Description =
    "Allow the Music Maker to choose a new song for you each time you return to the crossroads.\n Now playing {#ItalicFormat}{$TempTextData.PlayingSongFriendlyName}."
  },
  {
    Id = "Song_RandomSong",
    DisplayName = "Music Maker's Choice",
    Description = "Allow the Music Maker to choose a new song for you each time you return to the crossroads."
  },
  {
    Id = "Song_RandomSongFavorites_PlayingInfo",
    DisplayName = "Music Maker's Choice",
    Description =
    "Allow the Music Maker to choose a new, favorited song for you each time you return to the crossroads.\n Now playing {#ItalicFormat}{$TempTextData.PlayingSongFriendlyName}."
  },
  {
    Id = "Song_RandomSongFavorites",
    DisplayName = "Music Maker's Choice (Favorites)",
    Description =
    "Allow the Music Maker to choose a new, favorited song for you each time you return to the crossroads.\n {#ItalicFormat}Favorite songs using   {IP}."
  },
  -- Shows up as a resource cost when trying to buy the random favorite song
  {
    Id = "ModsNikkelMMusicMakerRandomizerMusicPlayerFavoritesCount_Short",
    DisplayName = "At least {#ItalicFormat}one{#prev}\nfavorited song"
  }
}

local helpTextFile = rom.path.combine(rom.paths.Content, 'Game/Text/en/HelpText.en.sjson')

sjson.hook(helpTextFile, function(data)
  for _, newSong in ipairs(newData) do
    table.insert(data.Texts, sjson.to_object(newSong, order))
  end
end)
