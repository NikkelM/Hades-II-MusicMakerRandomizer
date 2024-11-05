if not MusicMakerRandomize.Config.Enabled then return end

ModUtil.Path.Wrap("SelectMusicPlayerItem", function(base, screen, button)
	-- When the player pauses the random song, reset the chosen track so a new one can be chosen
	CurrentRun.MusicMakerRandomizeTrackName = nil
	GameState.MusicMakerRandomizeFriendlyPlayingSongString = ""

	local components = button.Screen.Components
	ModifyTextBox(
		{
			Id = components.InfoBoxDescription.Id,
			Text = button.Data.Name, -- "Song_RandomSong_NothingPlaying",
			UseDescription = true,
			LuaKey = "TempTextData",
			LuaValue = { MusicMakerRandomizeFriendlyPlayingSongString = GameState.MusicMakerRandomizeFriendlyPlayingSongString }
		})

	base(screen, button)

	ModifyTextBox(
		{
			Id = components.InfoBoxDescription.Id,
			Text = button.Data.Name,
			UseDescription = true,
			LuaKey = "TempTextData",
			LuaValue = { MusicMakerRandomizeFriendlyPlayingSongString = GameState.MusicMakerRandomizeFriendlyPlayingSongString }
		})
end)
