minetest.register_on_newplayer(function(player)
	if minetest.setting_getbool("give_initial_stuff") then
		minetest.log("action", player:get_player_name() .. " joined for the first time, giving them initial stuff.")
		player:get_inventory():add_item("main", "default:pick_wood")
		player:get_inventory():add_item("main", "default:sapling 10")
		player:get_inventory():add_item("main", "default:torch 10")
	else
		minetest.log("action", player:get_player_name() .. " joined for the first time.")
	end
end)

if minetest.setting_getbool("log_mods") then
	minetest.log("action", "Carbone: [give_initial_stuff] loaded.")
end
