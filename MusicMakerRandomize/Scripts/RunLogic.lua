if not MusicMakerRandomize.Config.Enabled then return end

ModUtil.Path.Wrap("MusicianMusic", function(base, args)
	base(args)

	UnlockWorldUpgrade("Song_RandomSong")
end)
