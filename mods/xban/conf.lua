
-- Extended Ban Mod for Minetest
-- (C) 2013 Diego Martínez <kaeza>
-- See `LICENSE.txt' for details.

-- conf.lua: Config routines.

xban.conf = { }

local conf = Settings(minetest.get_worldpath().."/xban.conf")

function xban.conf.get(k)
	local v
	v = conf:get(k)
	if v and (v ~= "") then return v end
	v = minetest.setting_get("xban."..k)
	if v and (v ~= "") then return v end
end

function xban.conf.get_bool(k)
	local v
	v = conf:get(k)
	if v and (v ~= "") then return conf:get_bool(k) end
	v = minetest.setting_get("xban."..k)
	if v and (v ~= "") then return minetest.setting_getbool("xban."..k) end
end
