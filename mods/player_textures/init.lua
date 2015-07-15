minetest.register_on_joinplayer(function(player)
	local filename = minetest.get_modpath("player_textures").."/textures/player_"..player:get_player_name()
	local f = io.open(filename..".png")
	if f then
		f:close()
		default.player_set_textures(player, {"player_"..player:get_player_name()..".png"})
	end
end)

if minetest.setting_getbool("log_mods") then
	minetest.log("action", "Carbone: [player_textures] loaded.")
end
