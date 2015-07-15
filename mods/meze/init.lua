--[[
=====================================================================
** Meze **
By Calinou.

Copyright (c) 2015 Calinou and contributors.
Licensed under the zlib license. See LICENSE.md for more information.
=====================================================================
--]]

-- Map generation
-- ==============

MEZE_FREQUENCY = 32 * 32 * 32

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "meze:meze",
	wherein        = "default:desert_stone",
	clust_scarcity = MEZE_FREQUENCY,
	clust_num_ores = 3,
	clust_size     = 2,
	height_min     = 0,
	height_max     = 64,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "meze:meze",
	wherein        = "default:stone",
	clust_scarcity = MEZE_FREQUENCY,
	clust_num_ores = 3,
	clust_size     = 2,
	height_min     = 0,
	height_max     = 64,
})

local function die_later(digger)
	digger:set_hp(0)
end

minetest.register_node("meze:meze", {
	description = "Meze Block",
	tiles = {"meze_meze_block.png"},
	is_ground_content = true,
	drop = "",
	groups = {cracky = 1, level = 2},
	sounds = default.node_sound_stone_defaults(),
	
	on_dig = function(pos, node, digger)
		if digger and minetest.setting_getbool("enable_damage") and not minetest.setting_getbool("creative_mode") then
			minetest.after(3, die_later, digger)
			minetest.chat_send_player(digger:get_player_name(), "You feel like you did a mistake.")
			minetest.node_dig(pos, node, digger)
		elseif digger then
			minetest.node_dig(pos, node, digger)
		end
	end,
})

minetest.register_alias("default:meze_block", "meze:meze")
