if not MusicMakerRandomize.Config.Enabled then return end

ModUtil.Path.Wrap("SelectMusicPlayerItem", function(base, screen, button)
	-- When the player pauses and plays the random song from the Music Maker's menu, choose a new track to play
	CurrentRun.MusicMakerRandomizeTrackName = nil
	base(screen, button)
end)
