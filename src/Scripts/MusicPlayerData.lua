table.insert(game.ScreenData.MusicPlayer.Songs, 1, "Song_RandomSong")

local randomizerSong =
{
	Song_RandomSong = {
		Name = "Song_RandomSong",
		InheritFrom = { "DefaultSongItem" },
		TrackName = "Song_RandomSongTrack",

		Cost =
		{
			CosmeticsPoints = 10,
		},

		PreRevealVoiceLines =
		{
			{
				PreLineWait = 0.35,
				UsePlayerSource = true,
				Cooldowns =
				{
					{ Name = "MelMusicPlayerRequestSpeech", Time = 2 },
				},
				{ Cue = "/VO/Melinoe_2356", Text = "Surprise!" },
			},
		},
	},
}

for songName, songData in pairs(randomizerSong) do
	game.ProcessDataInheritance(songData, game.WorldUpgradeData)
	game.WorldUpgradeData[songName] = songData
end