--[[
=====================================================================
** Map Tools **
By Calinou.

Copyright (c) 2012-2015 Calinou and contributors.
Licensed under the zlib license. See LICENSE.md for more information.
=====================================================================
--]]

maptools = {}

local S
if minetest.get_modpath("intllib") then
	S = intllib.Getter()
else
	S = function(s) return s end
end
maptools.intllib = S

local modpath = minetest.get_modpath("maptools")

dofile(modpath .. "/config.lua")
dofile(modpath .. "/aliases.lua")
dofile(modpath .. "/craftitems.lua")
dofile(modpath .. "/default_nodes.lua")
dofile(modpath .. "/nodes.lua")
dofile(modpath .. "/tools.lua")

if minetest.setting_getbool("log_mods") then
	minetest.log("action", S("[maptools] loaded."))
end
