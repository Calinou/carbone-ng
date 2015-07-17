-- crafting.lua: Crafting recipes
-- Copyright (c) 2015 Calinou
-- CC0 1.0 Universal

minetest.register_craft({
	output = "nyan_tools:pick_nyan",
	recipe = {
		{"default:nyancat", "default:nyancat", "default:nyancat"},
		{"", "group:stick", ""},
		{"", "group:stick", ""},
	}
})

minetest.register_craft({
	output = "nyan_tools:shovel_nyan",
	recipe = {
		{"default:nyancat"},
		{"group:stick"},
		{"group:stick"},
	}
})

minetest.register_craft({
	output = "nyan_tools:axe_nyan",
	recipe = {
		{"default:nyancat", "default:nyancat"},
		{"default:nyancat", "group:stick"},
		{"", "group:stick"},
	}
})

minetest.register_craft({
	output = "nyan_tools:sword_nyan",
	recipe = {
		{"default:nyancat"},
		{"default:nyancat"},
		{"group:stick"},
	}
})
