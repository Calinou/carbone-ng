--
-- Mgv6
--

local function register_mgv6_flower(name)
	minetest.register_decoration({
		deco_type = "simple",
		place_on = {"default:dirt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = 0,
			scale = 0.006,
			spread = {x = 100, y = 100, z = 100},
			seed = 436,
			octaves = 3,
			persist = 0.6
		},
		y_min = 1,
		y_max = 30,
		decoration = "flowers:"..name,
	})
end

local function register_mgv6_mushroom(name)
	minetest.register_decoration({
		deco_type = "simple",
		place_on = {"default:dirt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = 0,
			scale = 0.04,
			spread = {x = 100, y = 100, z = 100},
			seed = 7133,
			octaves = 3,
			persist = 0.6
		},
		y_min = 1,
		y_max = 30,
		decoration = "flowers:"..name,
		spawn_by = "default:tree",
		num_spawn_by = 1,
	})
end

local function register_mgv6_waterlily()
	minetest.register_decoration({
		deco_type = "schematic",
		place_on = {"default:dirt"},
		sidelen = 16,
		noise_params = {
			offset = -0.12,
			scale = 0.3,
			spread = {x = 100, y = 100, z = 100},
			seed = 33,
			octaves = 3,
			persist = 0.7
		},
		y_min = 0,
		y_max = 0,
		schematic = minetest.get_modpath("flowers").."/schematics/waterlily.mts",
		rotation = "random",
	})
end

function flowers.register_mgv6_decorations()
	register_mgv6_flower("rose")
	register_mgv6_flower("tulip")
	register_mgv6_flower("dandelion_yellow")
	register_mgv6_flower("geranium")
	register_mgv6_flower("viola")
	register_mgv6_flower("dandelion_white")

	register_mgv6_mushroom("mushroom_fertile_brown")
	register_mgv6_mushroom("mushroom_fertile_red")

	register_mgv6_waterlily()
end


--
-- All other biome API mapgens
--

local function register_flower(seed, name)
	minetest.register_decoration({
		deco_type = "simple",
		place_on = {"default:dirt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = -0.02,
			scale = 0.03,
			spread = {x = 200, y = 200, z = 200},
			seed = seed,
			octaves = 3,
			persist = 0.6
		},
		biomes = {
			"stone_grassland",
			"sandstone_grassland",
			"deciduous_forest",
			"coniferous_forest",
		},
		y_min = 6,
		y_max = 31000,
		decoration = "flowers:"..name,
	})
end

local function register_mushroom(name)
	minetest.register_decoration({
		deco_type = "simple",
		place_on = {"default:dirt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = 0,
			scale = 0.006,
			spread = {x = 200, y = 200, z = 200},
			seed = 2,
			octaves = 3,
			persist = 0.66
		},
		biomes = {"deciduous_forest", "coniferous_forest"},
		y_min = 6,
		y_max = 31000,
		decoration = "flowers:"..name,
	})
end

local function register_waterlily()
	minetest.register_decoration({
		deco_type = "schematic",
		place_on = {"default:dirt", "default:sand"},
		sidelen = 16,
		noise_params = {
			offset = -0.12,
			scale = 0.3,
			spread = {x = 200, y = 200, z = 200},
			seed = 33,
			octaves = 3,
			persist = 0.7
		},
		biomes = {"deciduous_forest_ocean", "sandstone_grassland_ocean",
			"rainforest_swamp", "savanna_ocean", "desert_ocean"},
		y_min = 0,
		y_max = 0,
		schematic = minetest.get_modpath("flowers").."/schematics/waterlily.mts",
		rotation = "random",
	})
end

function flowers.register_decorations()
	register_flower(436,     "rose")
	register_flower(19822,   "tulip")
	register_flower(1220999, "dandelion_yellow")
	register_flower(36662,   "geranium")
	register_flower(1133,    "viola")
	register_flower(73133,   "dandelion_white")

	register_mushroom("mushroom_fertile_brown")
	register_mushroom("mushroom_fertile_red")

	register_waterlily()
end


--
-- Detect mapgen to select functions
--

-- Mods using singlenode mapgen can call these functions to enable
-- the use of minetest.generate_ores or minetest.generate_decorations

local mg_params = minetest.get_mapgen_params()
if mg_params.mgname == "v6" then
	flowers.register_mgv6_decorations()
elseif mg_params.mgname ~= "singlenode" then
	flowers.register_decorations()
end
