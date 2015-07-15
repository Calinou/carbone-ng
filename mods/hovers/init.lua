local function is_water(pos)
	local nn = minetest.get_node(pos).name
	return minetest.get_item_group(nn, "water") ~= 0
end

local function get_sign(i)
	if i == 0 then return 0 else return i / math.abs(i) end
end

local function get_velocity(v, yaw, y)
	local x = -math.sin(yaw) * v
	local z = math.cos(yaw) * v
	return {x = x, y = y, z = z}
end

local function get_v(v)
	return math.sqrt(v.x ^ 2 + v.z ^ 2)
end

local hover = { -- Hover entity:
	physical = true,
	collisionbox = {-0.8125, -0.3125, -0.8125, 0.8125, 0, 0.8125},
	visual = "mesh",
	mesh = "boat.x",
	textures = {"hovers_hover.png^[transformR90"},
	driver = nil,
	v = 0,
}

function hover:on_rightclick(clicker)
	if not clicker or not clicker:is_player() then return end
	local name = clicker:get_player_name()
	if self.driver and clicker == self.driver then
		self.driver = nil
		clicker:set_detach()
		default.player_attached[name] = false
		default.player_set_animation(clicker, "stand" , 10)
	elseif not self.driver then
		self.driver = clicker
		clicker:set_attach(self.object, "", {x = 0, y = 11, z = -3}, {x = 0, y = 0, z = 0})
		default.player_attached[name] = true
		minetest.after(0.2, function()
			default.player_set_animation(clicker, "sit" , 10)
		end)
		self.object:setyaw(clicker:get_look_yaw()-math.pi/2)
	end
end

function hover:on_activate(staticdata, dtime_s)
	self.object:set_armor_groups({immortal = 1})
	if staticdata then
		self.v = tonumber(staticdata)
	end
end

function hover:get_staticdata()
	return tostring(v)
end

function hover:on_punch(puncher, time_from_last_punch, tool_capabilities, direction)
	if not self.driver then self.object:remove() end
	if puncher and puncher:is_player() and not self.driver then
		puncher:get_inventory():add_item("main", "hovers:hover")
	end
end

function hover:on_step(dtime)
	self.v = get_v(self.object:getvelocity())*get_sign(self.v)
	if self.driver then
		local ctrl = self.driver:get_player_control()
		local yaw = self.object:getyaw()
		if ctrl.up then
			self.v = self.v + dtime * 5
		end
		if ctrl.down then
			self.v = self.v - dtime * 1
		end
		if ctrl.left then
			self.object:setyaw(yaw + dtime)
		end
		if ctrl.right then
			self.object:setyaw(yaw - dtime)
		end
	end
	local s = get_sign(self.v)
	self.v = self.v - dtime * 0.5 * s
	if s ~= get_sign(self.v) then
		self.object:setvelocity({x = 0, y = 0, z = 0})
		self.v = 0
		return
	end
	if math.abs(self.v) > 7.5 then
		self.v = 7.5 * get_sign(self.v)
	end
	
	local p = self.object:getpos()
	p.y = p.y - 0.5
	if is_water(p) then
		-- self.object:setacceleration({x = 0, y = -14, z = 0})
		self.object:setvelocity(get_velocity(self.v, self.object:getyaw(), self.object:getvelocity().y))
	else
		p.y = p.y + 1
			-- self.object:setacceleration({x = 0, y = 4, z = 0})
			local y = self.object:getvelocity().y
			if y > 2 then
				y = 2
			end
			if y < 0 then
			--	self.object:setacceleration({x = 0, y = 8, z = 0})
			end
			self.object:setvelocity(get_velocity(self.v, self.object:getyaw(), y))
			self.object:setacceleration({x = 0, y = 0, z = 0})
			if math.abs(self.object:getvelocity().y) < 1 then
				local pos = self.object:getpos()
				pos.y = math.floor(pos.y) + 0.5
				self.object:setpos(pos)
				self.object:setvelocity(get_velocity(self.v, self.object:getyaw(), 0))
			else
				self.object:setvelocity(get_velocity(self.v, self.object:getyaw(), self.object:getvelocity().y))
			end
	end
end

minetest.register_entity("hovers:hover", hover)

minetest.register_craftitem("hovers:hover", {
	description = "Hover",
	inventory_image = "hovers_inventory.png",
	wield_image = "hovers_wield.png",
	wield_scale = {x = 2, y = 2, z = 1},
	
	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.type ~= "node" then return end
		pointed_thing.under.y = pointed_thing.under.y + 1.5
		minetest.add_entity(pointed_thing.under, "hovers:hover")
		if not minetest.setting_getbool("creative_mode") then
			itemstack:take_item()
		end
		return itemstack
	end,
})

minetest.register_craft({
	output = "hovers:hover",
	recipe = {
		{"default:mese_crystal",                     "", "default:mese_crystal"},
		{"default:mese_crystal", "default:mese_crystal", "default:mese_crystal"},
	},
})

if minetest.setting_getbool("log_mods") then
	minetest.log("action", "Carbone: [hovers] loaded.")
end
