-- name_restrictions mod by ShadowNinja
-- License: WTFPL

----------------------------
-- Restriction exemptions --
----------------------------
-- For legitimate player names that are caught by the filters.

local exemptions = {}
local temp = minetest.setting_get("name_restrictions.exemptions")
temp = temp and temp:split() or {}
for _, allowed_name in pairs(temp) do
	exemptions[allowed_name] = true
end
temp = nil
-- Exempt server owner
exemptions[minetest.setting_get("name")] = true
exemptions["singleplayer"] = true

---------------------
-- Simple matching --
---------------------

local msg_guest = "Guest accounts are disallowed on this server.  "..
		"Please choose a proper name and try again."
local msg_misleading = "Your player name is misleading.  "..
		"Please choose a more appropriate name."
local disallowed = {
	["^guest[0-9]+"] = msg_guest,
	["^squeakecrafter[0-9]+"] = msg_guest,
	["adm[1il]n"] = msg_misleading,
	["[0o]wn[e3]r"]  = msg_misleading,
	["^[0-9]+$"] = "All-numeric usernames are disallowed on this server.",
}

minetest.register_on_prejoinplayer(function(name, ip)
	local lname = name:lower()
	for re, reason in pairs(disallowed) do
		if lname:find(re) then
			return reason
		end
	end
end)


------------------------
-- Case-insensitivity --
------------------------

minetest.register_on_prejoinplayer(function(name, ip)
	local lname = name:lower()
	for iname, data in pairs(minetest.auth_table) do
		if iname:lower() == lname and iname ~= name then
			return "Sorry, someone else is already using this"
				.." name.  Please pick another name."
				.."  Annother possibility is that you used the"
				.." wrong case for your name."
		end
	end
end)

-- Compatability, for old servers with conflicting players
minetest.register_chatcommand("choosecase", {
	description = "Choose the casing that a player name should have.",
	params = "<name>",
	privs = {server=true},
	func = function(name, params)
		local lname = params:lower()
		local worldpath = minetest.get_worldpath()
		for iname, data in pairs(minetest.auth_table) do
			if iname:lower() == lname and iname ~= params then
				minetest.auth_table[iname] = nil
				assert(not iname:find("[/\\]"))
				os.remove(worldpath.."/players/"..iname)
			end
		end
		return true, "Done."
	end,
})


------------------------
-- Anti-impersonation --
------------------------
-- Prevents names that are too similar to another player's name.

local similar_chars = {
	-- Only A-Z, a-z, 1-9, dash, and underscore are allowed in playernames
	"A4",
	"B8",
	"COco0",
	"Ee3",
	"Gg69",
	"ILil1",
	"S5",
	"Tt7",
	"Zz2",
}

-- Map of characters to a regex of similar characters
local char_map = {}
for _, str in pairs(similar_chars) do
	for c in str:gmatch(".") do
		if not char_map[c] then
			char_map[c] = str
		else
			char_map[c] = char_map[c] .. str
		end
	end
end

for c, str in pairs(char_map) do
	char_map[c] = "[" .. char_map[c] .."]"
end

-- Characters to match for, containing all characters
local all_chars = "["
for _, str in pairs(similar_chars) do
	all_chars = all_chars .. str
end
all_chars = all_chars .. "]"


minetest.register_on_prejoinplayer(function(name, ip)
	if exemptions[name] then return end

	-- Generate a regular expression to match all similar names
	local re = name:gsub(all_chars, char_map)
	re = "^[_-]*" .. re .. "[_-]*$"

	for authName, _ in pairs(minetest.auth_table) do
		if authName ~= name and authName:match(re) then
			return "Your name is too similar to another player's name."
		end
	end
end)



-----------------
-- Name length --
-----------------

local min_name_len = tonumber(minetest.setting_get("name_restrictions.minimum_name_length")) or 3

minetest.register_on_prejoinplayer(function(name, ip)
	if exemptions[name] then return end

	if #name < min_name_len then
		return "Your player name is too short, please try a longer name."
	end
end)


----------------------
-- Pronounceability --
----------------------

-- Original implementation (in Python) by sfan5
local function pronounceable(pronounceability, text)
	local pronounceable = 0
	local nonpronounceable = 0
	local cn = 0
	local lastc = ""
	for c in text:lower():gmatch(".") do
		if c:find("[aeiou0-9_-]") then
			if not c:find("[0-9]") then
				if cn > 2 then
					nonpronounceable = nonpronounceable + 1
				else
					pronounceable = pronounceable + 1
				end
			end
			cn = 0
		else
			if cn == 1 and lastc == c and lastc ~= 's' then
				nonpronounceable = nonpronounceable + 1
				cn = 0
			end
			if cn > 2 then
				nonpronounceable = nonpronounceable + 1
				cn = 0
			end
			if lastc:find("[aeiou]") then
				pronounceable = pronounceable + 1
				cn = 0
			end
			if not (c == "r" and lastc:find("[aipfom]")) and
					not (lastc == "c" and c == "h") then
				cn = cn + 1
			end
		end
		lastc = c
	end
	if cn > 0 then
		nonpronounceable = nonpronounceable + 1
	end
	return pronounceable * pronounceability >= nonpronounceable
end

-- Pronounceability factor:
--   nil = Checking disabled.
--   0   = Everything's unpronounceable.
--   0.5 = Strict checking.
--   1   = Normal checking.
--   2   = Relaxed checking.
local pronounceability = tonumber(minetest.setting_get("name_restrictions.pronounceability"))
if pronounceability then
	minetest.register_on_prejoinplayer(function(name, ip)
		if exemptions[name] then return end

		if not pronounceable(pronounceability, name) then
			return "Your player name does not seem to be pronounceable."
				.."  Please choose a more pronounceable name."
		end
	end)
end

