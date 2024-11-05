# Randomize Music Maker Song Choice

This Hades II mod adds a new song to the Music Maker, which will play a random available song each time you return to the crossroads.
Can be configured to choose from all songs in the game, even those not yet unlocked/bought or discovered.

Will work with any songs added in the future.

## Installation

The recommended way of modding Hades II is using Thunderstore.
You can find this mod [here on Thunderstore](https://thunderstore.io/c/hades-ii/p/NikkelM/Randomize_Music_Maker_Song_Choice/).

### Using Mod Importer

- Download and extract the [Hades II Mod Importer](https://github.com/SGG-Modding/ModImporter/releases/latest) ([Nexus](https://www.nexusmods.com/hades2/mods/1)) into `Hades II\Content`
- Download and extract the [Mod Util](https://github.com/SGG-Modding/ModUtil/releases/latest) into `Hades II\Content\Mods` (create the `Mods` folder if it doesn't exist)
- Extract `MusicMakerRandomizer.zip` into `Hades II\Content\Mods`
- Run `modimporter.exe`

To uninstall:

- Either remove `Mods\MusicMakerRandomizer` or set the `Enabled` option in `MusicMakerRandomizer\config.lua` to `false`
- Run `modimporter.exe`

## Configuration

By default, the mod will only randomize from unlocked songs. You can change this behaviour by setting the `AllSongs` option to `true` in `config.lua`.
**Spoiler Warning**: Note that this will include songs that are not yet unlocked in the game, e.g. from future regions or bosses.

## Compatibility

This mod should be compatible with all other mods, including those adding songs to the Music Maker or modifying it in other ways.
If this is not the case for a mod, please let me know by opening an issue.
