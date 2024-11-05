if not MusicMakerRandomize.Config.Enabled then return end

table.insert(ScreenData.MusicPlayer.Songs, 1, "Song_RandomSong")

OverwriteTableKeys(WorldUpgradeData,
	{
		Song_RandomSong = {
			InheritFrom = { "DefaultSongItem" },
			TrackName = "Song_RandomSongTrack",

			-- Cost is free (unlocked by default)

			PreRevealVoiceLines =
			{
				{
					PreLineWait = 0.35,
					UsePlayerSource = true,
					Cooldowns =
					{
						{ Name = "MelMusicPlayerRequestSpeech", Time = 10 },
					},
					{ Cue = "/VO/Melinoe_2356", Text = "Surprise!" },
				},
			},
		},
	})
