if not MusicMakerRandomize.Config.Enabled then return end

ModUtil.Path.Wrap("SelectMusicPlayerItem", function(base, screen, button)
	-- When the player pauses the random song, reset the chosen track so a new one can be chosen
	CurrentRun.MusicMakerRandomizeTrackName = nil
	GameState.MusicMakerRandomizeFriendlyPlayingSong = "Nothing..."

	base(screen, button)

	if (GameState.MusicPlayerSongName == "Song_RandomSong" or GameState.MusicPlayerSongName == nil) and button.Data.Name == "Song_RandomSong" then
		-- Update the description with the new currently playing song, or "Nothing..." if the player paused the random song
		local components = button.Screen.Components
		ModifyTextBox(
			{
				Id = components.InfoBoxDescription.Id,
				Text = "Song_RandomSong_PlayingInfo",
				UseDescription = true,
				LuaKey = "TempTextData",
				LuaValue = { MusicMakerRandomizeFriendlyPlayingSong = GameState.MusicMakerRandomizeFriendlyPlayingSong }
			}
		)
	end
end)
