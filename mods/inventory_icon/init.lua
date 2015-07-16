inventory_icon = {}
inventory_icon.hudids = {}

inventory_icon.COLORIZE_STRING = "[colorize:#A00000:192"

function inventory_icon.get_inventory_state(inv, listname)
	local size = inv:get_size(listname)
	local occupied = 0
	for i=1,size do
		local stack = inv:get_stack(listname, i)
		if not stack:is_empty() then
			occupied = occupied + 1
		end
	end
	return occupied, size
end

function inventory_icon.replace_icon(name)
	return "inventory_icon_"..name
end

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	inventory_icon.hudids[name] = {}
	local occupied, size = inventory_icon.get_inventory_state(player:get_inventory(), "main")
	local icon
	if occupied >= size then
		icon = "inventory_icon_backpack_full.png"
	else
		icon = "inventory_icon_backpack_free.png"
	end
	inventory_icon.hudids[name].main = {}
	inventory_icon.hudids[name].main.icon = player:hud_add({
		hud_elem_type = "image",
		position = {x=1,y=1},
		scale = {x=1,y=1},
		offset = {x=-32,y=-32},
		text = icon,
	})
	inventory_icon.hudids[name].main.text = player:hud_add({
		hud_elem_type = "text",
		position = {x=1,y=1},
		scale = {x=1,y=1},
		offset = {x=-36,y=-20},
		alignment = {x=0,y=0},
		number = 0xFFFFFF,
		text = string.format("%d/%d", occupied, size)
	})
	if minetest.get_modpath("unified_inventory") ~= nil then
		inventory_icon.hudids[name].bags = {}
		local bags_inv = minetest.get_inventory({type = "detached", name = name.."_bags"})
		for i=1,4 do
			local bag = bags_inv:get_stack("bag"..i, 1)
			local scale, text, icon
			if bag:is_empty() then
				scale = { x = 0, y = 0 }
				text = ""
				icon = "inventory_icon_bags_small.png"
			else
				scale = { x = 1, y = 1 }
				local occupied, size = inventory_icon.get_inventory_state(player:get_inventory(), "bag"..i.."contents")
				text = string.format("%d/%d", occupied, size)
				icon = inventory_icon.replace_icon(minetest.registered_items[bag:get_name()].inventory_image)
				if occupied >= size then
					icon = icon .. "^" .. inventory_icon.COLORIZE_STRING
				end
			end
			inventory_icon.hudids[name].bags[i] = {}
			inventory_icon.hudids[name].bags[i].icon = player:hud_add({
				hud_elem_type = "image",
				position = {x=1,y=1},
				scale = scale,
				size = { x=32, y=32 },
				offset = {x=-36,y=-32 -40*i},
				text = icon,
			})
			inventory_icon.hudids[name].bags[i].text = player:hud_add({
				hud_elem_type = "text",
				position = {x=1,y=1},
				scale = scale,
				offset = {x=-36,y=-20 -40*i},
				alignment = {x=0,y=0},
				number = 0xFFFFFF,
				text = text,
			})
		end
	end
end)

minetest.register_on_leaveplayer(function(player)
	inventory_icon.hudids[player:get_player_name()] = nil
end)

inventory_icon.timer = 0
minetest.register_globalstep(function(dtime)
	inventory_icon.timer = inventory_icon.timer + dtime
	if inventory_icon.timer > 1 then
		for playername,hudids in pairs(inventory_icon.hudids) do
			local player = minetest.get_player_by_name(playername)
			local occupied, size = inventory_icon.get_inventory_state(player:get_inventory(), "main")
			local icon, color
			if occupied >= size then
				icon = "inventory_icon_backpack_full.png"
			else
				icon = "inventory_icon_backpack_free.png"
			end
			player:hud_change(hudids.main.icon, "text", icon)
			player:hud_change(hudids.main.text, "text", string.format("%d/%d", occupied, size))

			if minetest.get_modpath("unified_inventory") ~= nil then
				local bags_inv = minetest.get_inventory({type = "detached", name = playername.."_bags"})
				for i=1,4 do
					local bag = bags_inv:get_stack("bag"..i, 1)
					local scale, text, icon
					if bag:is_empty() then
						scale = { x = 0, y = 0 }
						text = ""
						icon = "inventory_icon_bags_small.png"
					else
						scale = { x = 1, y = 1 }
						local occupied, size = inventory_icon.get_inventory_state(player:get_inventory(), "bag"..i.."contents")
						text = string.format("%d/%d", occupied, size)
						icon = inventory_icon.replace_icon(minetest.registered_items[bag:get_name()].inventory_image)
						if occupied >= size then
							icon = icon .. "^" .. inventory_icon.COLORIZE_STRING
						end
					end
					player:hud_change(inventory_icon.hudids[playername].bags[i].icon, "text", icon)
					player:hud_change(inventory_icon.hudids[playername].bags[i].icon, "scale", scale)

					player:hud_change(inventory_icon.hudids[playername].bags[i].text, "text", text)
					player:hud_change(inventory_icon.hudids[playername].bags[i].text, "scale", scale)
				end
			end
		end
		inventory_icon.timer = 0
	end
end)
