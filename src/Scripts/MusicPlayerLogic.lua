modutil.mod.Path.Wrap("SelectMusicPlayerItem", function(base, screen, button)
	-- When the player pauses the random song, reset the chosen track so a new one can be chosen
	game.CurrentRun.MusicMakerRandomizerTrackName = nil
	game.GameState.MusicMakerRandomizerFriendlyPlayingSong = "Nothing.."

	base(screen, button)

	if (game.GameState.MusicPlayerSongName == "Song_RandomSong" or game.GameState.MusicPlayerSongName == nil) and button.Data.Name == "Song_RandomSong" then
		-- Update the description with the new currently playing song, or "Nothing..." if the player paused the random song
		local components = button.Screen.Components
		game.ModifyTextBox(
			{
				Id = components.InfoBoxDescription.Id,
				Text = "Song_RandomSong_PlayingInfo",
				UseDescription = true,
				LuaKey = "TempTextData",
				LuaValue = { PlayingSongFriendlyName = game.GameState.MusicMakerRandomizerFriendlyPlayingSong }
			}
		)
	end
end)
