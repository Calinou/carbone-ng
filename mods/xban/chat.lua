
-- Extended Ban Mod for Minetest
-- (C) 2013 Diego Martínez <kaeza>
-- See `LICENSE.txt' for details.

-- chat.lua: Chat commands.

minetest.register_chatcommand("ban", {
	params = "<player> [reason]",
	description = "Ban all IPs for a given player",
	privs = { ban=true, },
	func = function(name, param)
		param = param:trim()
		local player_name, reason = param:match("([^ ]+)( *.*)")
		if not player_name then
			xban._.send(name, "Usage: /ban <player> [reason]")
			return
		end
		reason = reason:trim()
		xban._.ACTION("%s bans %s. Reason: %s", name, player_name, reason)
		if reason == "" then reason = nil end
		local r, e = xban.ban_player(player_name, nil, reason)
		if r then
			xban._.send(name, "Banning %s.", player_name)
		else
			xban._.send(name, "ERROR: %s.", e)
		end
	end,
})

local mul = { [""]=1, s=1, m=60, h=3600, H=3600, d=3600*24, D=86400, w=86400*7, W=86400*7, M=86400*30 }

local function parse_time(t)
	local total = 0
	for count, suffix in t:gmatch("(%d+)([mhHdDwWM]?)") do
		count = count and tonumber(count)
		if count and suffix then
			total = (total or 0) + (count * mul[suffix])
		end
	end
	if total then return total end
end

minetest.register_chatcommand("tempban", {
	params = "<player> <time> [<reason>]",
	description = "Future ban all IPs for a given player, temporarily",
	privs = { ban=true, },
	func = function(name, param)
		param = param:trim()
		local player_name, time, reason = param:match("([^ ]+) *([^ ]+)( *.*)")
		if not (player_name and time) then
			xban._.send(name, "Usage: /tempban <player> <time> [<reason>]")
			return
		end
		time = parse_time(time)
		if not time then
			xban._.send(name, "Invalid time format. Syntax is: [0-9]+[mhdWM] with no space between the number and the time unit. A month is 30 days.")
			return
		elseif time < 60 then
			xban._.send(name, "Ban time must be at least 60 seconds.")
			return
		end
		reason = reason:trim()
		xban._.ACTION("%s bans %s for %d seconds. Reason: %s.",
			name, player_name, time, reason
		)
		if reason == "" then reason = nil end
		local r, e = xban.ban_player(player_name, time, reason)
		if r then
			xban._.send(name, "Banning %s for %d seconds.", player_name, time)
		else
			xban._.send(name, "ERROR: %s", e)
		end
	end,
})

minetest.register_chatcommand("unban", {
	params = "<player>",
	description = "Unban all IPs for a given player",
	privs = { ban=true, },
	func = function(name, param)
		param = param:trim()
		if param == "" then
			xban._.send(name, "Usage: /unban <player>")
			return
		end
		local r, e = xban.unban_player(param)
		if r then
			xban._.send(name, "Unbanning %s.", param)
		else
			xban._.send(name, "ERROR: %s.", e)
		end
	end,
})
