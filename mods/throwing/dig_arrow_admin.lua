minetest.register_craftitem("throwing:arrow_dig_admin", {
	description = "Admin Dig Arrow",
	inventory_image = "throwing_arrow_dig_admin.png",
	groups = {not_in_creative_inventory = 1},
})

minetest.register_node("throwing:arrow_dig_admin_box", {
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			-- Shaft
			{-6.5/17, -1.5/17, -1.5/17, 6.5/17, 1.5/17, 1.5/17},
			-- Spitze
			{-4.5/17, 2.5/17, 2.5/17, -3.5/17, -2.5/17, -2.5/17},
			{-8.5/17, 0.5/17, 0.5/17, -6.5/17, -0.5/17, -0.5/17},
			-- Federn
			{6.5/17, 1.5/17, 1.5/17, 7.5/17, 2.5/17, 2.5/17},
			{7.5/17, -2.5/17, 2.5/17, 6.5/17, -1.5/17, 1.5/17},
			{7.5/17, 2.5/17, -2.5/17, 6.5/17, 1.5/17, -1.5/17},
			{6.5/17, -1.5/17, -1.5/17, 7.5/17, -2.5/17, -2.5/17},

			{7.5/17, 2.5/17, 2.5/17, 8.5/17, 3.5/17, 3.5/17},
			{8.5/17, -3.5/17, 3.5/17, 7.5/17, -2.5/17, 2.5/17},
			{8.5/17, 3.5/17, -3.5/17, 7.5/17, 2.5/17, -2.5/17},
			{7.5/17, -2.5/17, -2.5/17, 8.5/17, -3.5/17, -3.5/17},
		}
	},
	tiles = {"throwing_arrow_dig_admin.png", "throwing_arrow_dig_admin.png", "throwing_arrow_dig_admin_back.png", "throwing_arrow_dig_admin_front.png", "throwing_arrow_dig_admin_2.png", "throwing_arrow_dig_admin.png"},
	groups = {not_in_creative_inventory = 1},
})

local THROWING_ARROW_ENTITY = {
	physical = false,
	timer = 0,
	visual = "wielditem",
	visual_size = {x = 0.125, y = 0.125},
	textures = {"throwing:arrow_dig_admin_box"},
	lastpos= {},
	collisionbox = {0, 0, 0, 0, 0, 0},
}

THROWING_ARROW_ENTITY.on_step = function(self, dtime)
	self.timer = self.timer + dtime
	local pos = self.object:getpos()
	local node = minetest.get_node(pos)

	if self.timer > 0.2 then
		local objs = minetest.get_objects_inside_radius({x = pos.x, y = pos.y, z = pos.z}, 1)
		for k, obj in pairs(objs) do
			if obj:get_luaentity() ~= nil then
				if obj:get_luaentity().name ~= "throwing:arrow_dig_admin_entity" and obj:get_luaentity().name ~= "__builtin:item" then
					local n = minetest.get_node(pos).name
					minetest.log("action", n .. " was removed using throwing:arrow_dig_admin at " .. pos_to_string(vector.round(pos)) .. ".")
					minetest.remove_node(pos)
					self.object:remove()
				end
			else
				local n = minetest.get_node(pos).name
				minetest.log("action", n .. " was removed using throwing:arrow_dig_admin at " .. pos_to_string(vector.round(pos)) .. ".")
				minetest.remove_node(pos)
				self.object:remove()
			end
		end
	end

	if self.lastpos.x ~= nil then
		if minetest.registered_nodes[node.name].walkable then
			local n = minetest.get_node(pos).name
			minetest.log("action", n .. " was removed using throwing:arrow_dig_admin at " .. pos_to_string(vector.round(pos)) .. ".")
			minetest.remove_node(pos)
			self.object:remove()
		end
	end
	self.lastpos= {x = pos.x, y = pos.y, z = pos.z}
end

minetest.register_entity("throwing:arrow_dig_admin_entity", THROWING_ARROW_ENTITY)
