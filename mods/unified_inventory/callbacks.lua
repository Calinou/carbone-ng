local function default_refill(stack)
	stack:set_count(stack:get_stack_max())
	local itemdef = minetest.registered_items[stack:get_name()]
	if itemdef and (itemdef.wear_represents or "mechanical_wear") == "mechanical_wear" and stack:get_wear() ~= 0 then
		stack:set_wear(0)
	end
	return stack
end

minetest.register_on_joinplayer(function(player)
	local player_name = player:get_player_name()
	unified_inventory.players[player_name] = {}
	unified_inventory.current_index[player_name] = 1
	unified_inventory.filtered_items_list[player_name] =
			unified_inventory.items_list
	unified_inventory.activefilter[player_name] = ""
	unified_inventory.active_search_direction[player_name] = "nochange"
	unified_inventory.apply_filter(player, "", "nochange")
	unified_inventory.current_searchbox[player_name] = ""
	unified_inventory.alternate[player_name] = 1
	unified_inventory.current_item[player_name] = nil
	unified_inventory.current_craft_direction[player_name] = "recipe"
	unified_inventory.set_inventory_formspec(player,
			unified_inventory.default)

	-- Refill slot
	local refill = minetest.create_detached_inventory(player_name.."refill", {
		allow_put = function(inv, listname, index, stack, player)
			local player_name = player:get_player_name()
			if unified_inventory.is_creative(player_name) then
				return stack:get_count()
			else
				return 0
			end
		end,
		on_put = function(inv, listname, index, stack, player)
			local player_name = player:get_player_name()
			local handle_refill = (minetest.registered_items[stack:get_name()] or {}).on_refill or default_refill
			stack = handle_refill(stack)
			inv:set_stack(listname, index, stack)
			minetest.sound_play("electricity",
					{to_player=player_name, gain = 1.0})
		end,
	})
	refill:set_size("main", 1)
end)

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "" then
		return
	end
	local player_name = player:get_player_name()

	-- always take new search text, even if not searching on it yet
	if fields.searchbox ~= nil and fields.searchbox ~= unified_inventory.current_searchbox[player_name] then
		unified_inventory.current_searchbox[player_name] = fields.searchbox
		unified_inventory.set_inventory_formspec(player, unified_inventory.current_page[player_name])
	end

	for i, def in pairs(unified_inventory.buttons) do
		if fields[def.name] then
			def.action(player)
			minetest.sound_play("click",
					{to_player=player_name, gain = 0.1})
			return
		end
	end

	-- Inventory page controls
	local start = math.floor(
		unified_inventory.current_index[player_name] / unified_inventory.items_per_page + 1)
	local start_i = start
	local pagemax = math.floor(
		(#unified_inventory.filtered_items_list[player_name] - 1)
		/ (unified_inventory.items_per_page) + 1)

	if fields.start_list then
		start_i = 1
	end
	if fields.rewind1 then
		start_i = start_i - 1
	end
	if fields.forward1 then
		start_i = start_i + 1
	end
	if fields.rewind3 then
		start_i = start_i - 3
	end
	if fields.forward3 then
		start_i = start_i + 3
	end
	if fields.end_list then
		start_i = pagemax
	end
	if start_i < 1 then
		start_i = 1
	end
	if start_i > pagemax then
		start_i = pagemax
	end
	if not (start_i	== start) then
		minetest.sound_play("paperflip1",
				{to_player=player_name, gain = 1.0})
		unified_inventory.current_index[player_name] = (start_i - 1) * unified_inventory.items_per_page + 1
		unified_inventory.set_inventory_formspec(player,
				unified_inventory.current_page[player_name])
	end

	local clicked_item = nil
	for name, value in pairs(fields) do
		if string.sub(name, 1, 12) == "item_button_" then
			local new_dir, mangled_item = string.match(name, "^item_button_([a-z]+)_(.*)$")
			clicked_item = unified_inventory.demangle_for_formspec(mangled_item)
			if string.sub(clicked_item, 1, 6) == "group:" then
				minetest.sound_play("click", {to_player=player_name, gain = 0.1})
				unified_inventory.apply_filter(player, clicked_item, new_dir)
				return
			end
			if new_dir == "recipe" or new_dir == "usage" then
				unified_inventory.current_craft_direction[player_name] = new_dir
			end
			break
		end
	end
	if clicked_item then
		minetest.sound_play("click",
				{to_player=player_name, gain = 0.1})
		local page = unified_inventory.current_page[player_name]
		if not unified_inventory.is_creative(player_name) then
			page = "craftguide"
		end
		if page == "craftguide" then
			unified_inventory.current_item[player_name] = clicked_item
			unified_inventory.alternate[player_name] = 1
			unified_inventory.set_inventory_formspec(player,
					"craftguide")
		else
			if unified_inventory.is_creative(player_name) then
				local inv = player:get_inventory()
				local stack = ItemStack(clicked_item)
				stack:set_count(stack:get_stack_max())
				if inv:room_for_item("main", stack) then
					inv:add_item("main", stack)
				end
			end
		end
	end

	if fields.searchbutton then
		unified_inventory.apply_filter(player, unified_inventory.current_searchbox[player_name], "nochange")
		unified_inventory.current_searchbox[player_name] = ""
		unified_inventory.set_inventory_formspec(player,
				unified_inventory.current_page[player_name])
		minetest.sound_play("paperflip2",
				{to_player=player_name, gain = 1.0})
	end

	-- alternate button
	if fields.alternate then
		minetest.sound_play("click",
				{to_player=player_name, gain = 0.1})
		local item_name = unified_inventory.current_item[player_name]
		if item_name then
			local alternates = 0
			local alternate = unified_inventory.alternate[player_name]
			local crafts = unified_inventory.crafts_for[unified_inventory.current_craft_direction[player_name]][item_name]
			if crafts ~= nil then
				alternates = #crafts
			end
			if alternates > 1 then
				alternate = alternate + 1
				if alternate > alternates then
					alternate = 1
				end
				unified_inventory.alternate[player_name] = alternate
				unified_inventory.set_inventory_formspec(player,
						unified_inventory.current_page[player_name])
			end
		end
	end
end)

