modutil.mod.Path.Wrap("MusicPlayerGetShuffledPlaylist", function(base, args)
	if game.GameState.ModsNikkelMMusicMakerRandomizerShufflingFromFavorites then
		local playlist = game.ShallowCopyTable(game.GameState.ModsNikkelMMusicMakerRandomizerFavoritedTracks)
		local shuffled = game.FYShuffle(playlist) or {}
		-- Prevent the same song from playing twice in a row
		if GameState.MusicPlayerSongName == shuffled[1] then
			local swapIndex = RandomInt(2, #shuffled) or 1
			shuffled[1] = shuffled[swapIndex]
			shuffled[swapIndex] = GameState.MusicPlayerSongName
		end
		return shuffled
	else
		return base(args)
	end
end)
