if not MusicMakerRandomize.Config.Enabled then return end

ModUtil.Path.Wrap("MouseOverMusicPlayerItem", function(base, button)
	base(button)

	-- Update the description with the currently playing song when the random song is first selected
	local components = button.Screen.Components
	ModifyTextBox(
		{
			Id = components.InfoBoxDescription.Id,
			Text = button.Data.Name,
			UseDescription = true,
			LuaKey = "TempTextData",
			LuaValue = { MusicMakerRandomizeFriendlyPlayingSong = GameState.MusicMakerRandomizeFriendlyPlayingSong }
		})
end)