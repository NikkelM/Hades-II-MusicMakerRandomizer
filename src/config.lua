local config = {
  version = 0;
  enabled = true;
  allSongs = false;
}

local configDesc = {
  enabled = "Whether the mod is enabled or not.";
  allSongs = "Whether the Music Maker should be able to shuffle from all songs in the game, even those not yet discovered or unlocked yet (SPOILER WARNING)."
}

return config, configDesc