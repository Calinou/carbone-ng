
-- Extended Ban Mod for Minetest
-- (C) 2013 Diego Martínez <kaeza>
-- See `LICENSE.txt' for details.

-- init.lua: Initialization script.

xban = { }
xban._ = { } -- Internal functions.

local MP = minetest.get_modpath("xban")

dofile(MP.."/conf.lua")
dofile(MP.."/intr.lua")
dofile(MP.."/xban.lua")
dofile(MP.."/chat.lua")

if minetest.setting_getbool("log_mods") then
	minetest.log("action", "Carbone: [xban] loaded.")
end
