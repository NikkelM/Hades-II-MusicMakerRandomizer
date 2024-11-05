if not MusicMakerRandomize.Config.Enabled then return end

ModUtil.Path.Wrap("SelectMusicPlayerItem", function(base, screen, button)
	-- When the player pauses the random song, reset the chosen track so a new one can be chosen
	CurrentRun.MusicMakerRandomizeTrackName = nil
	GameState.MusicMakerRandomizeFriendlyPlayingSongString = ""

	base(screen, button)
end)
