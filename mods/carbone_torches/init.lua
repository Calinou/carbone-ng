-- 3D torches using wallmounted nodeboxes (from Carbone, by Calinou).
-- Fully client-side, only one node, no lag.

-- License for code and textures: CC0 1.0 <https://creativecommons.org/publicdomain/zero/1.0/>

minetest.register_node(":default:torch", {
	description = "Torch",
	drawtype = "nodebox",
	tiles = {
		{name = "default_torch_new_top.png",    animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 3.0}},
		{name = "default_torch_new_bottom.png", animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 3.0}},
		{name = "default_torch_new_side.png",   animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 3.0}},
	},
	inventory_image = "default_torch_new_inv.png",
	wield_image = "default_torch_new_inv.png",
	wield_scale = {x = 1, y = 1, z = 1.25},
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	is_ground_content = false,
	walkable = false,
	light_source = LIGHT_MAX - 1,
	node_box = {
		type = "wallmounted",
		wall_top    = {-0.0625, -0.0625, -0.0625, 0.0625, 0.5   , 0.0625},
		wall_bottom = {-0.0625, -0.5   , -0.0625, 0.0625, 0.0625, 0.0625},
		wall_side   = {-0.5   , -0.5   , -0.0625, -0.375, 0.0625, 0.0625},
	},
	selection_box = {
		type = "wallmounted",
		wall_top    = {-0.25, -0.0625, -0.25, 0.25, 0.5   , 0.25},
		wall_bottom = {-0.25, -0.5   , -0.25, 0.25, 0.0625, 0.25},
		wall_side   = {-0.25, -0.5  , -0.25, -0.5, 0.0625, 0.25},
	},
	groups = {choppy = 2, dig_immediate = 3, flammable = 1, attached_node = 1, hot = 2},
	sounds = default.node_sound_wood_defaults(),
})
