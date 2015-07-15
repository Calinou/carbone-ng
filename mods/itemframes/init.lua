local tmp = {}

minetest.register_entity("itemframes:item",{
	hp_max = 1,
	visual="wielditem",
	visual_size = {x = 0.3333, y = 0.3333},
	collisionbox = {0,0,0,0,0,0},
	physical = false,
	textures = {"air"},
	on_activate = function(self, staticdata)
		if tmp.nodename ~= nil and tmp.texture ~= nil then
			self.nodename = tmp.nodename
			tmp.nodename = nil
			self.texture = tmp.texture
			tmp.texture = nil
		else
			if staticdata ~= nil and staticdata ~= "" then
				local data = staticdata:split(";")
				if data and data[1] and data[2] then
					self.nodename = data[1]
					self.texture = data[2]
				end
			end
		end
		if self.texture ~= nil then
			self.object:set_properties({textures = {self.texture}})
		end
		if self.nodename == "itemframes:pedestal" then
			self.object:set_properties({automatic_rotate = 0.5})
		end
	end,
	get_staticdata = function(self)
		if self.nodename ~= nil and self.texture ~= nil then
			return self.nodename .. ";" .. self.texture
		end
		return ""
	end,
})


local facedir = {}
facedir[0] = {x = 0,  y = 0, z = 1}
facedir[1] = {x = 1,  y = 0, z = 0}
facedir[2] = {x = 0,  y = 0, z = -1}
facedir[3] = {x = -1, y = 0, z = 0}

local remove_item = function(pos, node)
	local objs = nil
	if node.name == "itemframes:frame" then
		objs = minetest.env:get_objects_inside_radius(pos, 0.5)
	elseif node.name == "itemframes:pedestal" then
		objs = minetest.env:get_objects_inside_radius({x = pos.x, y = pos.y + 1, z = pos.z}, 0.5)
	end
	if objs then
		for _, obj in ipairs(objs) do
			if obj and obj:get_luaentity() and obj:get_luaentity().name == "itemframes:item" then
				obj:remove()
			end
		end
	end
end

local update_item = function(pos, node)
	remove_item(pos, node)
	local meta = minetest.env:get_meta(pos)
	if meta:get_string("item") ~= "" then
		if node.name == "itemframes:frame" then
			local posad = facedir[node.param2]
			pos.x = pos.x + posad.x * 6.5 / 16
			pos.y = pos.y + posad.y * 6.5 / 16
			pos.z = pos.z + posad.z * 6.5 / 16
		elseif node.name == "itemframes:pedestal" then
			pos.y = pos.y + 0.5 + 0.3333
		end
		tmp.nodename = node.name
		tmp.texture = ItemStack(meta:get_string("item")):get_name()
		local e = minetest.env:add_entity(pos,"itemframes:item")
		if node.name == "itemframes:frame" then
			local yaw = math.pi*2 - node.param2 * math.pi/2
			e:setyaw(yaw)
		end
	end
end

local drop_item = function(pos, node)
	local meta = minetest.env:get_meta(pos)
	if meta:get_string("item") ~= "" then
		if node.name == "itemframes:frame" then
			minetest.env:add_item(pos, meta:get_string("item"))
		elseif node.name == "itemframes:pedestal" then
			minetest.env:add_item({x=pos.x,y=pos.y+1,z=pos.z}, meta:get_string("item"))
		end
		meta:set_string("item","")
	end
	remove_item(pos, node)
end

minetest.register_node("itemframes:frame",{
	description = "Item frame",
	drawtype = "nodebox",
	node_box = { type = "fixed", fixed = {-0.5, -0.5, 7/16, 0.5, 0.5, 0.5} },
	tiles = {"itemframes_frame.png"},
	inventory_image = "itemframes_frame.png",
	wield_image = "itemframes_frame.png",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	groups = { choppy = 2, dig_immediate = 2},
	legacy_wallmounted = true,
	sounds = default.node_sound_defaults(),
	after_place_node = function(pos, placer, itemstack)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("owner",placer:get_player_name())
		meta:set_string("infotext","Item frame (owned by "..placer:get_player_name()..")")
	end,
	on_rightclick = function(pos, node, clicker, itemstack)
		if not itemstack then return end
		local meta = minetest.env:get_meta(pos)
		if clicker:get_player_name() == meta:get_string("owner") then
			drop_item(pos,node)
			local s = itemstack:take_item()
			meta:set_string("item",s:to_string())
			update_item(pos,node)
		end
		return itemstack
	end,
	on_punch = function(pos,node,puncher)
		local meta = minetest.env:get_meta(pos)
		if puncher:get_player_name() == meta:get_string("owner") then
			drop_item(pos, node)
		end
	end,
	can_dig = function(pos,player)
		
		local meta = minetest.env:get_meta(pos)
		return player:get_player_name() == meta:get_string("owner")
	end,
})


minetest.register_node("itemframes:pedestal",{
	description = "Pedestal",
	drawtype = "nodebox",
	node_box = { type = "fixed", fixed = {
		{-7/16, -8/16, -7/16, 7/16, -7/16, 7/16}, -- Bottom plate
		{-6/16, -7/16, -6/16, 6/16, -6/16, 6/16}, -- Bottom plate (upper)
		{-0.25, -6/16, -0.25, 0.25, 7/16, 0.25}, -- Pillar
		{-7/16, 7/16, -7/16, 7/16, 8/16, 7/16}, -- Top plate
	} },
	tiles = {"itemframes_pedestal.png"},
	paramtype = "light",
	groups = {cracky = 2},
	sounds = default.node_sound_defaults(),
	
	after_place_node = function(pos, placer, itemstack)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("owner",placer:get_player_name())
		meta:set_string("infotext","Pedestal (owned by "..placer:get_player_name()..")")
	end,
	
	on_rightclick = function(pos, node, clicker, itemstack)
		if not itemstack then return end
		local meta = minetest.env:get_meta(pos)
		if clicker:get_player_name() == meta:get_string("owner") then
			drop_item(pos,node)
			local s = itemstack:take_item()
			meta:set_string("item",s:to_string())
			update_item(pos,node)
		end
		return itemstack
	end,
	
	on_punch = function(pos,node,puncher)
		local meta = minetest.env:get_meta(pos)
		if puncher:get_player_name() == meta:get_string("owner") then
			drop_item(pos,node)
		end
	end,
	
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos)
		return player:get_player_name() == meta:get_string("owner")
	end,
})

minetest.register_craft({
	output = "itemframes:frame",
	recipe = {
		{"default:stick", "default:stick", "default:stick"},
		{"default:stick", "default:paper", "default:stick"},
		{"default:stick", "default:stick", "default:stick"},
	}
})

minetest.register_craft({
	output = "itemframes:pedestal",
	recipe = {
		{"default:stone", "default:stone", "default:stone"},
		{"             ", "default:stone", "             "},
		{"default:stone", "default:stone", "default:stone"},
	}
})

if minetest.setting_getbool("log_mods") then
	minetest.log("action", "Carbone: [itemframes] loaded.")
end
