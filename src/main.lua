---@meta _
-- grabbing our dependencies,
-- these funky (---@) comments are just there
--	 to help VS Code find the definitions of things

---@diagnostic disable-next-line: undefined-global
local mods = rom.mods

---@module 'SGG_Modding-ENVY-auto'
mods['SGG_Modding-ENVY'].auto()
-- ^ this gives us `public` and `import`, among others
--	and makes all globals we define private to this plugin.
---@diagnostic disable: lowercase-global

---@diagnostic disable-next-line: undefined-global
rom = rom
---@diagnostic disable-next-line: undefined-global
_PLUGIN = _PLUGIN

-- get definitions for the game's globals
---@module 'game'
game = rom.game
---@module 'game-import'
import_as_fallback(game)

---@module 'SGG_Modding-SJSON'
sjson = mods['SGG_Modding-SJSON']
---@module 'SGG_Modding-ModUtil'
modutil = mods['SGG_Modding-ModUtil']

---@module 'SGG_Modding-Chalk'
chalk = mods["SGG_Modding-Chalk"]
---@module 'SGG_Modding-ReLoad'
reload = mods['SGG_Modding-ReLoad']

---@module 'config'
config = chalk.auto 'config.lua'
-- ^ this updates our `.cfg` file in the config folder!
public.config = config -- so other mods can access our config

-- For debugging
-- function printTable(t, maxDepth, indent)
-- 	if type(t) ~= "table" then
-- 		print(t)
-- 		return
-- 	end

-- 	indent = indent or 0
-- 	maxDepth = maxDepth or 20
-- 	if indent > maxDepth then
-- 		print(string.rep("  ", indent) .. "...")
-- 		return
-- 	end

-- 	local formatting = string.rep("  ", indent)
-- 	for k, v in pairs(t) do
-- 		if type(v) == "table" then
-- 			print(formatting .. k .. ":")
-- 			printTable(v, maxDepth, indent + 1)
-- 		else
-- 			print(formatting .. k .. ": " .. tostring(v))
-- 		end
-- 	end
-- end

-- function game.printTable(t, maxDepth, indent)
-- 	if type(t) ~= "table" then
-- 		print(t)
-- 		return
-- 	end

-- 	indent = indent or 0
-- 	maxDepth = maxDepth or 20
-- 	if indent > maxDepth then
-- 		print(string.rep("  ", indent) .. "...")
-- 		return
-- 	end

-- 	local formatting = string.rep("  ", indent)
-- 	for k, v in pairs(t) do
-- 		if type(v) == "table" then
-- 			print(formatting .. k .. ":")
-- 			game.printTable(v, maxDepth, indent + 1)
-- 		else
-- 			print(formatting .. k .. ": " .. tostring(v))
-- 		end
-- 	end
-- end

local function on_ready()
  -- what to do when we are ready, but not re-do on reload.
  if config.Enabled == false then return end

  import "Scripts/AudioLogic.lua"
  import "Scripts/GhostAdminLogic.lua"
  import "Scripts/MusicPlayerData.lua"
  import "Scripts/MusicPlayerLogic.lua"
  import "Scripts/MusicPlayerPresentation.lua"
	import "Scripts/PatchLogic.lua"

  import "Game/Text/ScreenText.en.sjson.lua"
  import "Game/Animations/GUI_Screens_VFX.sjson.lua"
end

local function on_reload()
  -- what to do when we are ready, but also again on every reload.
  -- only do things that are safe to run over and over.
  if config.Enabled == false then return end
end

-- this allows us to limit certain functions to not be reloaded.
local loader = reload.auto_single()

-- this runs only when modutil and the game's lua is ready
modutil.once_loaded.game(function()
  loader.load(on_ready, on_reload)
end)
