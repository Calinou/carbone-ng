arrows = {
	{"throwing:arrow", "throwing:arrow_entity"},
	{"throwing:arrow_gold", "throwing:arrow_gold_entity"},
	{"throwing:arrow_gold", "throwing:arrow_steel_entity"},
	{"throwing:arrow_fire", "throwing:arrow_fire_entity"},
	{"throwing:arrow_teleport", "throwing:arrow_teleport_entity"},
	{"throwing:arrow_dig", "throwing:arrow_dig_entity"},
	{"throwing:arrow_dig_admin", "throwing:arrow_dig_admin_entity"},
	{"throwing:arrow_build", "throwing:arrow_build_entity"}
}

local throwing_shoot_arrow = function(itemstack, player)
	for _,arrow in ipairs(arrows) do
		if player:get_inventory():get_stack("main", player:get_wield_index()+1):get_name() == arrow[1] then
			if not minetest.setting_getbool("creative_mode") then
				player:get_inventory():remove_item("main", arrow[1])
			end
			local playerpos = player:getpos()
			local obj = minetest.add_entity({x=playerpos.x,y=playerpos.y+1.5,z=playerpos.z}, arrow[2])
			local dir = player:get_look_dir()
			obj:setvelocity({x=dir.x*19, y=dir.y*19, z=dir.z*19})
			obj:setacceleration({x=dir.x*-3, y=-10, z=dir.z*-3})
			obj:setyaw(player:get_look_yaw()+math.pi)
			minetest.sound_play("throwing_sound", {pos=playerpos, gain = 0.5})
			if obj:get_luaentity().player == "" then
				obj:get_luaentity().player = player
			end
			obj:get_luaentity().node = player:get_inventory():get_stack("main", 1):get_name()
			return true
		end
	end
	return false
end


minetest.register_tool("throwing:bow_wood", {
	description = "Wooden Bow",
	inventory_image = "throwing_bow_wood.png",
	on_use = function(itemstack, user, pointed_thing)
		if throwing_shoot_arrow(itemstack, user, pointed_thing) then
			if not minetest.setting_getbool("creative_mode") then
				itemstack:add_wear(65535/30)
			end
		end
		return itemstack
	end,
})

minetest.register_craft({
	output = "throwing:bow_wood",
	recipe = {
		{"farming:cotton", "default:wood", ""},
		{"farming:cotton", "", "default:wood"},
		{"farming:cotton", "default:wood", ""},
	}
})



minetest.register_tool("throwing:bow_stone", {
	description = "Stone Bow",
	inventory_image = "throwing_bow_stone.png",
	on_use = function(itemstack, user, pointed_thing)
		if throwing_shoot_arrow(item, user, pointed_thing) then
			if not minetest.setting_getbool("creative_mode") then
				itemstack:add_wear(65535/90)
			end
		end
		return itemstack
	end,
})

minetest.register_craft({
	output = "throwing:bow_stone",
	recipe = {
		{"farming:cotton", "default:cobble", ""},
		{"farming:cotton", "", "default:cobble"},
		{"farming:cotton", "default:cobble", ""},
	}
})



minetest.register_tool("throwing:bow_steel", {
	description = "Steel Bow",
	inventory_image = "throwing_bow_steel.png",
	on_use = function(itemstack, user, pointed_thing)
		if throwing_shoot_arrow(item, user, pointed_thing) then
			if not minetest.setting_getbool("creative_mode") then
				itemstack:add_wear(65535/200)
			end
		end
		return itemstack
	end,
})

minetest.register_craft({
	output = "throwing:bow_steel",
	recipe = {
		{"farming:cotton", "default:steel_ingot", ""},
		{"farming:cotton", "", "default:steel_ingot"},
		{"farming:cotton", "default:steel_ingot", ""},
	}
})



minetest.register_tool("throwing:bow_bronze", {
	description = "Bronze Bow",
	inventory_image = "throwing_bow_bronze.png",
    stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
		if throwing_shoot_arrow(item, user, pointed_thing) then
			if not minetest.setting_getbool("creative_mode") then
				itemstack:add_wear(65535/220)
			end
		end
		return itemstack
	end,
})

minetest.register_craft({
	output = "throwing:bow_bronze",
	recipe = {
		{"farming:cotton", "default:bronze_ingot", ""},
		{"farming:cotton", "", "default:bronze_ingot"},
		{"farming:cotton", "default:bronze_ingot", ""},
	}
})



minetest.register_tool("throwing:bow_mese", {
	description = "Mese Bow",
	inventory_image = "throwing_bow_mese.png",
	on_use = function(itemstack, user, pointed_thing)
		if throwing_shoot_arrow(item, user, pointed_thing) then
			if not minetest.setting_getbool("creative_mode") then
				itemstack:add_wear(65535/350)
			end
		end
		return itemstack
	end,
})

minetest.register_craft({
	output = "throwing:bow_mese",
	recipe = {
		{"farming:cotton", "default:mese_crystal", ""},
		{"farming:cotton", "", "default:mese_crystal"},
		{"farming:cotton", "default:mese_crystal", ""},
	}
})



minetest.register_tool("throwing:bow_diamond", {
	description = "Diamond Bow",
	inventory_image = "throwing_bow_diamond.png",
	on_use = function(itemstack, user, pointed_thing)
		if throwing_shoot_arrow(item, user, pointed_thing) then
			if not minetest.setting_getbool("creative_mode") then
				itemstack:add_wear(65535/500)
			end
		end
		return itemstack
	end,
})

minetest.register_craft({
	output = "throwing:bow_diamond",
	recipe = {
		{"farming:cotton", "default:diamond", ""},
		{"farming:cotton", "", "default:diamond"},
		{"farming:cotton", "default:diamond", ""},
	}
})

dofile(minetest.get_modpath("throwing") .. "/arrow.lua")
dofile(minetest.get_modpath("throwing") .. "/golden_arrow.lua")
dofile(minetest.get_modpath("throwing") .. "/steel_arrow.lua")
dofile(minetest.get_modpath("throwing") .. "/fire_arrow.lua")
dofile(minetest.get_modpath("throwing") .. "/teleport_arrow.lua")
dofile(minetest.get_modpath("throwing") .. "/dig_arrow.lua")
dofile(minetest.get_modpath("throwing") .. "/dig_arrow_admin.lua")
dofile(minetest.get_modpath("throwing") .. "/build_arrow.lua")

if minetest.setting_getbool("log_mods") then
	minetest.log("action", "Carbone: [throwing] loaded.")
end
