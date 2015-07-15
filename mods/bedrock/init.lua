minetest.register_ore({
	ore_type       = "scatter",
	ore            = "bedrock:bedrock",
	wherein        = "default:stone",
	clust_scarcity = 1 * 1 * 1,
	clust_num_ores = 5,
	clust_size     = 2,
	height_min     = -30912, -- Engine changes can modify this value.
	height_max     = -30656, -- This ensures the bottom of the world is not even loaded.
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "bedrock:deepstone",
	wherein        = "default:stone",
	clust_scarcity = 1 * 1 * 1,
	clust_num_ores = 5,
	clust_size     = 2,
	height_min     = -30656,
	height_max     = -30000,
})

minetest.register_node("bedrock:bedrock", {
	description = "Bedrock",
	tile_images = {"bedrock_bedrock.png"},
	drop = "",
	groups = {unbreakable = 1, not_in_creative_inventory = 1}, -- For Map Tools' admin pickaxe.
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("bedrock:deepstone", {
	description = "Deepstone",
	tile_images = {"bedrock_deepstone.png"},
	drop = "default:stone", -- Intended.
	groups = {cracky = 1},
	sounds = default.node_sound_stone_defaults(),
})

if minetest.setting_getbool("log_mods") then
	minetest.log("action", "Carbone: [bedrock] loaded.")
end
