-- Adds a new "resource" that simply counts how many songs the player has favorited
-- This does not show up anywhere other than when buying the favorites song
table.insert(game.ResourceDisplayOrderData, "ModsNikkelMMusicMakerRandomizerMusicPlayerFavoritesCount")

local newResourceData =
{
	ModsNikkelMMusicMakerRandomizerMusicPlayerFavoritesCount =
	{
		InheritFrom = { "BaseResource" },

		IconPath = "GUI\\Screens\\Codex\\filled_heart_icon",
		TextIconPath = "GUI\\Screens\\Codex\\filled_heart_icon",
		TooltipId = "ModsNikkelMMusicMakerRandomizerMusicPlayerFavoritesCountIcon",
		CostTextId = "ModsNikkelMMusicMakerRandomizerMusicPlayerFavoritesCount_Short",
		IconScale = 0.45
	},
}

for resourceName, resourceData in pairs(newResourceData) do
	game.ProcessDataInheritance(resourceData, game.WorldUpgradeData)
	game.ResourceData[resourceName] = resourceData
end
