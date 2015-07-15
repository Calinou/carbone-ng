--[[
Map Tools: unbreakable default nodes

Copyright (c) 2012-2015 Calinou and contributors.
Licensed under the zlib license. See LICENSE.md for more information.
--]]

local S = maptools.intllib

maptools.creative = maptools.config["hide_from_creative_inventory"]

minetest.register_node("maptools:stone", {
	description = S("Unbreakable Stone"),
	range = 12,
	stack_max = 10000,
	tiles = {"default_stone.png"},
	drop = "",
	groups = {unbreakable = 1, not_in_creative_inventory = maptools.creative},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("maptools:stonebrick", {
	description = S("Unbreakable Stone Brick"),
	range = 12,
	stack_max = 10000,
	tiles = {"default_stone_brick.png"},
	drop = "",
	groups = {unbreakable = 1, not_in_creative_inventory = maptools.creative},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("maptools:tree", {
	description = S("Unbreakable Tree"),
	range = 12,
	stack_max = 10000,
	tiles = {"default_tree_top.png", "default_tree_top.png", "default_tree.png"},
	drop = "",
	groups = {unbreakable = 1, not_in_creative_inventory = maptools.creative},
	sounds = default.node_sound_wood_defaults(),
	on_place = minetest.rotate_node
})

minetest.register_node("maptools:jungletree", {
	description = S("Unbreakable Jungle Tree"),
	range = 12,
	stack_max = 10000,
	tiles = {"default_jungletree_top.png", "default_jungletree_top.png", "default_jungletree.png"},
	drop = "",
	groups = {unbreakable = 1, not_in_creative_inventory = maptools.creative},
	sounds = default.node_sound_wood_defaults(),
	on_place = minetest.rotate_node
})

minetest.register_node("maptools:cactus", {
	description = S("Unbreakable Cactus"),
	range = 12,
	stack_max = 10000,
	tiles = {"default_cactus_top.png", "default_cactus_top.png", "default_cactus_side.png"},
	drop = "",
	groups = {unbreakable = 1, not_in_creative_inventory = maptools.creative},
	sounds = default.node_sound_wood_defaults(),
	on_place = minetest.rotate_node
})

minetest.register_node("maptools:papyrus", {
	description = S("Unbreakable Papyrus"),
	drawtype = "plantlike",
	range = 12,
	stack_max = 10000,
	tiles = {"default_papyrus.png"},
	inventory_image = "default_papyrus.png",
	wield_image = "default_papyrus.png",
	walkable = false,
	paramtype = "light",
	sunlight_propagates = true,
	drop = "",
	selection_box = {
		type = "fixed",
		fixed = {-0.375, -0.5, -0.375, 0.375, 0.5, 0.375}
	},
	groups = {unbreakable = 1, not_in_creative_inventory = maptools.creative},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("maptools:dirt", {
	description = S("Unbreakable Dirt"),
	range = 12,
	stack_max = 10000,
	tiles = {"default_dirt.png"},
	drop = "",
	groups = {unbreakable = 1, not_in_creative_inventory = maptools.creative},
	sounds = default.node_sound_dirt_defaults(),
})

minetest.register_node("maptools:wood", {
	description = S("Unbreakable Wooden Planks"),
	range = 12,
	stack_max = 10000,
	tiles = {"default_wood.png"},
	drop = "",
	groups = {unbreakable = 1, not_in_creative_inventory = maptools.creative},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("maptools:junglewood", {
	description = S("Unbreakable Junglewood Planks"),
	range = 12,
	stack_max = 10000,
	tiles = {"default_junglewood.png"},
	drop = "",
	groups = {unbreakable = 1, not_in_creative_inventory = maptools.creative},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("maptools:glass", {
	description = S("Unbreakable Glass"),
	range = 12,
	stack_max = 10000,
	drawtype = "glasslike",
	tiles = {"default_glass.png"},
	paramtype = "light",
	sunlight_propagates = true,
	drop = "",
	groups = {unbreakable = 1, not_in_creative_inventory = maptools.creative},
	sounds = default.node_sound_glass_defaults(),
})

minetest.register_node("maptools:leaves", {
	description = S("Unbreakable Leaves"),
	range = 12,
	stack_max = 10000,
	drawtype = "allfaces_optional",
	tiles = {"default_leaves.png"},
	paramtype = "light",
	drop = "",
	groups = {unbreakable = 1, not_in_creative_inventory = maptools.creative},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("maptools:sand", {
	description = S("Unbreakable Sand"),
	range = 12,
	stack_max = 10000,
	tiles = {"default_sand.png"},
	drop = "",
	groups = {unbreakable = 1, not_in_creative_inventory = maptools.creative},
	sounds = default.node_sound_sand_defaults(),
})

minetest.register_node("maptools:gravel", {
	description = S("Unbreakable Gravel"),
	range = 12,
	stack_max = 10000,
	tiles = {"default_gravel.png"},
	drop = "",
	groups = {unbreakable = 1, not_in_creative_inventory = maptools.creative},
	sounds = default.node_sound_dirt_defaults({
		footstep = {name="default_gravel_footstep", gain=0.35},
		dug = {name="default_gravel_footstep", gain=0.6},
	}),
})

minetest.register_node("maptools:clay", {
	description = S("Unbreakable Clay"),
	range = 12,
	stack_max = 10000,
	tiles = {"default_clay.png"},
	drop = "",
	groups = {unbreakable = 1, not_in_creative_inventory = maptools.creative},
	sounds = default.node_sound_dirt_defaults(),
})

minetest.register_node("maptools:desert_sand", {
	description = S("Unbreakable Desert Sand"),
	range = 12,
	stack_max = 10000,
	tiles = {"default_desert_sand.png"},
	drop = "",
	groups = {unbreakable = 1, not_in_creative_inventory = maptools.creative},
	sounds = default.node_sound_sand_defaults(),
})

minetest.register_node("maptools:sandstone", {
	description = S("Unbreakable Sandstone"),
	range = 12,
	stack_max = 10000,
	tiles = {"default_sandstone.png"},
	drop = "",
	groups = {unbreakable = 1, not_in_creative_inventory = maptools.creative},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("maptools:sandstone_brick", {
	description = S("Unbreakable Sandstone Brick"),
	range = 12,
	stack_max = 10000,
	tiles = {"default_sandstone_brick.png"},
	drop = "",
	groups = {unbreakable = 1, not_in_creative_inventory = maptools.creative},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("maptools:desert_stone", {
	description = S("Unbreakable Desert Stone"),
	range = 12,
	stack_max = 10000,
	tiles = {"default_desert_stone.png"},
	drop = "",
	groups = {unbreakable = 1, not_in_creative_inventory = maptools.creative},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("maptools:desert_cobble", {
	description = S("Unbreakable Desert Cobble"),
	range = 12,
	stack_max = 10000,
	tiles = {"default_desert_cobble.png"},
	drop = "",
	groups = {unbreakable = 1, not_in_creative_inventory = maptools.creative},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("maptools:desert_stonebrick", {
	description = S("Unbreakable Desert Stone Brick"),
	range = 12,
	stack_max = 10000,
	tiles = {"default_desert_stone_brick.png"},
	drop = "",
	groups = {unbreakable = 1, not_in_creative_inventory = maptools.creative},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("maptools:grass", {
	description = S("Unbreakable Dirt with Grass"),
	range = 12,
	stack_max = 10000,
	tiles = {"default_grass.png", "default_dirt.png", "default_dirt.png^default_grass_side.png"},
	paramtype2 = "facedir",
	drop = "",
	groups = {unbreakable = 1, not_in_creative_inventory = maptools.creative},
	sounds = default.node_sound_dirt_defaults({
		footstep = {name="default_grass_footstep", gain = 0.4},
	}),
})

minetest.register_node("maptools:fullgrass", {
	description = S("Unbreakable Full Grass"),
	range = 12,
	stack_max = 10000,
	tiles = {"default_grass.png"},
	drop = "",
	groups = {unbreakable = 1, not_in_creative_inventory = maptools.creative},
	sounds = default.node_sound_dirt_defaults({
		footstep = {name="default_grass_footstep", gain=0.4},
	}),
})

for slab_num = 1,3,1 do
	minetest.register_node("maptools:slab_grass_" .. slab_num * 4, {
		description = S("Grass Slab"),
		range = 12,
		stack_max = 10000,
		tiles = {"default_grass.png", "default_dirt.png", "default_dirt.png^maptools_grass_side_" .. slab_num * 4 .. ".png"},
		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, -0.5 + slab_num * 0.25, 0.5},
		},
		sunlight_propagates = true,
		paramtype = "light",
		paramtype2 = "facedir",
		drop = "",
		groups = {unbreakable = 1, not_in_creative_inventory = maptools.creative},
		sounds = default.node_sound_dirt_defaults({footstep = {name="default_grass_footstep", gain = 0.4}}),
	})
end

minetest.register_node("maptools:cobble", {
	description = S("Unbreakable Cobblestone"),
	range = 12,
	stack_max = 10000,
	tiles = {"default_cobble.png"},
	drop = "",
	groups = {unbreakable = 1, not_in_creative_inventory = maptools.creative},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("maptools:mossycobble", {
	description = S("Unbreakable Mossy Cobblestone"),
	range = 12,
	stack_max = 10000,
	tiles = {"default_mossycobble.png"},
	drop = "",
	groups = {unbreakable = 1, not_in_creative_inventory = maptools.creative},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("maptools:brick", {
	description = S("Unbreakable Brick"),
	range = 12,
	stack_max = 10000,
	tiles = {"default_brick.png"},
	drop = "",
	groups = {unbreakable = 1, not_in_creative_inventory = maptools.creative},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("maptools:coalblock", {
	description = S("Unbreakable Coal Block"),
	range = 12,
	stack_max = 10000,
	tiles = {"default_coal_block.png"},
	drop = "",
	groups = {unbreakable = 1, not_in_creative_inventory = maptools.creative},
	sounds = default.node_sound_stone_defaults(),
})


minetest.register_node("maptools:steelblock", {
	description = S("Unbreakable Steel Block"),
	range = 12,
	stack_max = 10000,
	tiles = {"default_steel_block.png"},
	drop = "",
	groups = {unbreakable = 1, not_in_creative_inventory = maptools.creative},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("maptools:goldblock", {
	description = S("Unbreakable Gold Block"),
	range = 12,
	stack_max = 10000,
	tiles = {"default_gold_block.png"},
	drop = "",
	groups = {unbreakable = 1, not_in_creative_inventory = maptools.creative},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("maptools:copperblock", {
	description = S("Unbreakable Copper Block"),
	range = 12,
	stack_max = 10000,
	tiles = {"default_copper_block.png"},
	drop = "",
	groups = {unbreakable = 1, not_in_creative_inventory = maptools.creative},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("maptools:bronzeblock", {
	description = S("Unbreakable Bronze Block"),
	range = 12,
	stack_max = 10000,
	tiles = {"default_bronze_block.png"},
	drop = "",
	groups = {unbreakable = 1, not_in_creative_inventory = maptools.creative},
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("maptools:diamondblock", {
	description = S("Unbreakable Diamond Block"),
	range = 12,
	stack_max = 10000,
	tiles = {"default_diamond_block.png"},
	drop = "",
	groups = {unbreakable = 1, not_in_creative_inventory = maptools.creative},
	sounds = default.node_sound_stone_defaults(),
})

-- Farming:

minetest.register_node("maptools:soil_wet", {
	description = "Wet Soil",
	range = 12,
	stack_max = 10000,
	tiles = {"farming_soil_wet.png", "farming_soil_wet_side.png"},
	drop = "",
	groups = {unbreakable = 1, not_in_creative_inventory = maptools.creative, soil = 3, wet = 1, grassland = 1},
	sounds = default.node_sound_dirt_defaults(),
})

minetest.register_node("maptools:desert_sand_soil_wet", {
	description = "Wet Desert Sand Soil",
	range = 12,
	stack_max = 10000,
	drop = "",
	tiles = {"farming_desert_sand_soil_wet.png", "farming_desert_sand_soil_wet_side.png"},
	groups = {unbreakable = 1, not_in_creative_inventory = maptools.creative, soil = 3, wet = 1, desert = 1},
	sounds = default.node_sound_sand_defaults(),
})
