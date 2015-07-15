local trampolinebox = {
	type = "fixed",
	fixed = {
		{-0.5, -0.2, -0.5,  0.5,    0,  0.5},

		{-0.5, -0.5, -0.5, -0.4, -0.2, -0.4},
		{ 0.4, -0.5, -0.5,  0.5, -0.2, -0.4},
		{ 0.4, -0.5,  0.4,  0.5, -0.2,  0.5},
		{-0.5, -0.5,  0.4, -0.4, -0.2,  0.5},
		}
}

local cushionbox = {
	type = "fixed",
	fixed = {
		{-0.5, -0.5, -0.5,  0.5, -0.3,  0.5},
		}
}

local trampoline_punch = function(pos, node)
	local id = string.sub(node.name, #node.name)
	id = id + 1
	if id == 7 then id = 1 end
	minetest.env:add_node(pos, {name = string.sub(node.name, 1, #node.name - 1)..id})
end

for i = 1, 6 do
	minetest.register_node("jumping:trampoline_" .. i, {
		description = "Trampoline",
		drawtype = "nodebox",
		node_box = trampolinebox,
		selection_box = trampolinebox,
		paramtype = "light",
		on_punch = trampoline_punch,
		tiles = {
			"jumping_trampoline_top.png",
			"jumping_trampoline_bottom.png",
			"jumping_trampoline_sides.png^jumping_trampoline_sides_overlay_" .. i .. ".png",
		},
		drop = "jumping:trampoline_1",
		groups = {dig_immediate = 2, bouncy = 16 + i * 16, fall_damage_add_percent = -65, disable_jump = 1},
	})
end

minetest.register_node("jumping:cushion", {
	description = "Cushion",
	drawtype = "nodebox",
	node_box = cushionbox,
	selection_box = cushionbox,
	paramtype = "light",
	tiles = {
		"jumping_cushion_tb.png",
		"jumping_cushion_tb.png",
		"jumping_cushion_sides.png",
	},
	groups = {dig_immediate = 2, disable_jump = 1, fall_damage_add_percent = -100},
})

minetest.register_craft({
	output = "jumping:trampoline_1",
	recipe = {
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
		{"default:leaves", "default:leaves", "default:leaves"},
		{"default:stick", "default:stick", "default:stick"},
	}
})

minetest.register_craft({
	output = "jumping:cushion",
	recipe = {
		{"default:junglegrass", "default:junglegrass", "default:junglegrass"},
		{"default:leaves", "default:leaves", "default:leaves"},
		{"default:stick", "default:stick", "default:stick"},
	}
})

if minetest.setting_getbool("log_mods") then
	minetest.log("action", "Carbone: [jumping] loaded.")
end
