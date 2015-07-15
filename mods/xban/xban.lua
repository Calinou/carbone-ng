
-- Extended Ban Mod for Minetest
-- (C) 2013 Diego Martínez <kaeza>
-- See `LICENSE.txt' for details.

-- xban.lua: Core functions.

local DEF_BAN_MESSAGE = (xban.conf.get("ban_message")
	or "(no reason given)")

local DB_FILE = minetest.get_worldpath().."/players.iplist"

local unpack = unpack or table.unpack

local iplist = { }

local function get_ip(name)
	if minetest.get_player_by_name(name) then
		return minetest.get_player_ip(name)
	end
end

function xban.find_entry(name_or_ip, create)

	for index, data in ipairs(iplist) do
		for k, v in pairs(data.names) do
			if v and (k == name_or_ip) then
				return data, index
			end
		end
	end

	if create then
		local data = { names={} }
		table.insert(iplist, data)
		return data
	end

end

local function load_db()
	local f = io.open(DB_FILE, "r")
	if not f then return end
	xban._.INFO("Loading IP database...")
	local db = minetest.deserialize(f:read("*a"))
	f:close()
	iplist = db
	xban._.INFO("IP database loaded.")
end

function xban.save_db()
	local f, e = io.open(DB_FILE, "w")
	if not f then
		xban._.WARN("Error saving IP database: %s.", (e or ""))
		return
	end
	xban._.INFO("Saving IP database...")
	f:write(minetest.serialize(iplist))
	f:close()
	xban._.INFO("IP database saved.")
end

function xban.ban_player(name, time, reason)
	local data = xban.find_entry(name, true)
	local ip = get_ip(name)
	data.names[name] = true
	if ip then data.names[ip] = true end
	reason = reason or DEF_BAN_REASON
	data.banned = reason
	if not data.record then data.record = { } end
	table.insert(data.record, { date=os.time(), time=time, reason=reason })
	data.privs = data.privs or minetest.get_player_privs(name)
	minetest.after(1, function()
		xban._.send(name,
			"-x- You have been banned from this server: %s.",
			(reason or DEF_BAN_MESSAGE)
		)
		if time then
			data.expires = os.time() + time
			xban._.send(name, "-x- Your ban will expire on %s.", os.date("%c", data.expires))
		end
		xban._.send(name, "-x- Disconnection will follow shortly...")
	end)
	if minetest.auth_table[name] then
		minetest.set_player_privs(name, { })
	end
	minetest.after(5, minetest.ban_player, name)
	xban._.ACTION("Banned names/IPs: %s", table.concat(data.names, ", "))
	xban._.INFO("Revoked all privileges.")
	xban.save_db()
	return true
end

function xban.unban_player(name)
	local data = xban.find_entry(name)
	if not data then return nil, "No such player." end
	if data.privs and next(data.privs) then
		minetest.set_player_privs(name, data.privs)
	end
	for _, nm in ipairs(data.names) do
		minetest.unban_player_or_ip(nm)
	end
	data.banned = nil
	xban.save_db()
	return true
end

load_db()

xban.db = iplist
