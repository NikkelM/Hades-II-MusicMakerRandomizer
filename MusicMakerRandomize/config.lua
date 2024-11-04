local mod = ModUtil.Mod.Register("MusicMakerRandomize")

-- After making changes here, you need to re-run modimporter.exe
mod.Config = {
	-- Simply set this to false to disable the mod.
  Enabled = true,
	-- SPOILER WARNING: If this is set to true, the random song will be chosen from all available songs.
	-- This includes tracks you may not even know exist (e.g. from future regions or bosses)
	AllSongs = false
}