if not MusicMakerRandomize.Config.Enabled then return end

table.insert(ScreenData.MusicPlayer.Songs, 1, "Song_RandomSong")

OverwriteTableKeys(WorldUpgradeData,
	{
		Song_RandomSong = {
			InheritFrom = { "DefaultSongItem" },
			TrackName = "Song_RandomSongTrack",

			-- Make it free, but use 0-cost to still play the unlock voiceline and mark it as new
			Cost =
			{
				CosmeticsPoints = 0,
			},

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
