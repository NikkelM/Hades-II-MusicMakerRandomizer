if not MusicMakerRandomize.Config.Enabled then return end

ModUtil.Path.Wrap("MouseOverMusicPlayerItem", function(base, button)
	base(button)

	local components = button.Screen.Components
	-- If the random song has been bought and is currently playing, update the description with the currently playing song
	if GameState.WorldUpgrades["Song_RandomSong"] and GameState.MusicPlayerSongName == "Song_RandomSong" and button.Data.Name == "Song_RandomSong" then
		ModifyTextBox(
			{
				Id = components.InfoBoxDescription.Id,
				Text = "Song_RandomSong_PlayingInfo",
				UseDescription = true,
				LuaKey = "TempTextData",
				LuaValue = { MusicMakerRandomizeFriendlyPlayingSong = GameState.MusicMakerRandomizeFriendlyPlayingSong }
			}
		)
	else
		ModifyTextBox(
			{
				Id = components.InfoBoxDescription.Id,
				Text = button.Data.Name,
				UseDescription = true,
			}
		)
	end
end)