-- After making changes here, you need to re-run modimporter.exe (if not using Thunderstore)
local config = {
	-- Simply set this to false to disable the mod.
	Enabled = true,
	-- SPOILER WARNING: If this is set to true, random songs will be chosen from all available tracks.
	-- This includes those you may not even know exist (e.g. from future regions or bosses).
	AllSongs = false
}

MusicMakerRandomizer.Config = config
return config
