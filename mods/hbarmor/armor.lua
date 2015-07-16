minetest.after(0, function()
 if not armor.def then
	minetest.after(2,minetest.chat_send_all,"#Better HUD: Please update your version of 3darmor")
	HUD_SHOW_ARMOR = false
 end
end)

function hbarmor.get_armor(player)
	if not player or not armor.def then
		return false
	end
	local name = player:get_player_name()
	local def = armor.def[name] or nil
	if def and def.state and def.count then
		hbarmor.set_armor(name, def.state, def.count)
	else
		return false
	end
	return true
end

function hbarmor.set_armor(player_name, ges_state, items)
	local max_items = 4
	if items == 5 then 
		max_items = items
	end
	local max = max_items * 65535
	local lvl = max - ges_state
	lvl = lvl/max
	if ges_state == 0 and items == 0 then
		lvl = 0
	end

	hbarmor.armor[player_name] = lvl* (items * (100 / max_items))


end
