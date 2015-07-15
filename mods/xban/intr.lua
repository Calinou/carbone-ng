
-- Extended Ban Mod for Minetest
-- (C) 2013 Diego Martínez <kaeza>
-- See `LICENSE.txt' for details.

-- intr.lua: Internal functions.

-- NOTE: Do not use these from other mods; they may change without notice.

local function mklogger(type)
	return function(fmt, ...) minetest.log(type, fmt:format(...)) end
end

xban._.INFO = mklogger("info")
xban._.WARN = mklogger("warning")
xban._.ACTION = mklogger("action")

function xban._.send(name, fmt, ...)
	minetest.chat_send_player(name, (fmt:format(...)))
end
