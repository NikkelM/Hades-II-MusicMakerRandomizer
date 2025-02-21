local randomizerButton = {
	Graphic = "ContextualActionButton",
	GroupName = "Combat_Menu_Overlay",
	Alpha = 0.0,
	Data = {
		OnMouseOverFunctionName = "MouseOverContextualAction",
		OnMouseOffFunctionName = "MouseOffContextualAction",
		OnPressedFunctionName = "ModsNikkelMMusicMakerRandomizerShuffleFavorites",
		ControlHotkeys = { "Codex", },
	},
	Text = "ModsNikkelMMusicMakerRandomizerShuffleFavorites",
	TextArgs = UIData.ContextualButtonFormatRight,
	IsFavoriteShuffleButton = true,
}

table.insert(game.ScreenData.MusicPlayer.ComponentData.ActionBar.ChildrenOrder, 3, "ShuffleButtonFavorites")
game.ScreenData.MusicPlayer.ComponentData.ActionBar.Children.ShuffleButtonFavorites = randomizerButton
