table.insert(game.ScreenData.MusicPlayer.Songs, 1, "Song_RandomSong")
table.insert(game.ScreenData.MusicPlayer.Songs, 2, "Song_RandomSongFavorites")

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
	Song_RandomSongFavorites = {
		Name = "Song_RandomSongFavorites",
		InheritFrom = { "DefaultSongItem" },
		TrackName = "Song_RandomSongFavoritesTrack",

		Cost =
		{
			CosmeticsPoints = 10,
		},
	},
}

for songName, songData in pairs(randomizerSong) do
	game.ProcessDataInheritance(songData, game.WorldUpgradeData)
	game.WorldUpgradeData[songName] = songData
end
