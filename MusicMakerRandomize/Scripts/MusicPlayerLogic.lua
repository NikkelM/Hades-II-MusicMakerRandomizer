if not MusicMakerRandomize.Config.Enabled then return end

ModUtil.Path.Wrap("SelectMusicPlayerItem", function(base, screen, button)
	-- When the player pauses the random song, reset the chosen track so a new one can be chosen
	CurrentRun.MusicMakerRandomizeTrackName = nil
	GameState.MusicMakerRandomizeFriendlyPlayingSongString = ""

	local components = button.Screen.Components
	ModifyTextBox(
		{
			Id = components.InfoBoxDescription.Id,
			Text = "Song_RandomSong_NothingPlaying",
			UseDescription = true
		})

	base(screen, button)
end)
