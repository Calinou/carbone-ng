-- tools.lua: Tool definitions
-- Copyright (c) 2015 Calinou
-- CC0 1.0 Universal

minetest.register_tool("nyan_tools:pick_nyan", {
	description = "Nyan Pickaxe",
	inventory_image = "nyan_tools_tool_nyanpick.png",
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level = 3,
		groupcaps = {
			cracky = {times = {[1] = 2.4, [2] = 1.0, [3] = 0.65}, uses = 75, maxlevel = 3},
		},
		damage_groups = {fleshy = 5},
	},
})

minetest.register_tool("nyan_tools:shovel_nyan", {
	description = "Nyan Shovel",
	inventory_image = "nyan_tools_tool_nyanshovel.png",
	wield_image = "nyan_tools_tool_nyanshovel.png^[transformR90",
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level = 1,
		groupcaps = {
			crumbly = {times = {[1] = 1.65, [2] = 0.6, [3] = 0.32}, uses = 75, maxlevel = 3},
		},
		damage_groups = {fleshy = 4},
	},
})

minetest.register_tool("nyan_tools:axe_nyan", {
	description = "Nyan Axe",
	inventory_image = "nyan_tools_tool_nyanaxe.png",
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level = 1,
		groupcaps = {
			choppy = {times = {[1] = 2.2, [2] = 1.0, [3] = 0.55}, uses = 75, maxlevel = 3},
		},
		damage_groups = {fleshy = 6},
	},
})

minetest.register_tool("nyan_tools:sword_nyan", {
	description = "Nyan Sword",
	inventory_image = "nyan_tools_tool_nyansword.png",
	tool_capabilities = {
		full_punch_interval = 0.9,
		max_drop_level = 1,
		groupcaps = {
			snappy = {times = {[1] = 1.9, [2] = 0.85, [3] = 0.125}, uses = 75, maxlevel = 3},
		},
		damage_groups = {fleshy = 6},
	}
})
