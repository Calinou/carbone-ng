-- Unified Inventory for Minetest 0.4.8+

local modpath = minetest.get_modpath(minetest.get_current_modname())
local worldpath = minetest.get_worldpath()

-- Data tables definitions
unified_inventory = {
	activefilter = {},
	active_search_direction = {},
	alternate = {},
	current_page = {},
	current_searchbox = {},
	current_index = {},
	current_item = {},
	current_craft_direction = {},
	registered_craft_types = {},
	crafts_for = {usage = {}, recipe = {} },
	players = {},
	items_list_size = 0,
	items_list = {},
	filtered_items_list_size = {},
	filtered_items_list = {},
	pages = {},
	buttons = {},

	-- Homepos stuff
	home_pos = {},
	home_filename =	worldpath.."/unified_inventory_home.home",

	-- Default inventory page
	default = "craft",

	-- intllib
	gettext = rawget(_G, "intllib") and intllib.Getter() or function(s) return s end,

	-- "Lite" mode
	lite_mode = minetest.setting_getbool("unified_inventory_lite"),

	pagecols = 8,
	pagerows = 10,
	page_y = 0,
	formspec_y = 1,
	main_button_x = 0,
	main_button_y = 9,
	craft_result_x = 0.3,
	craft_result_y = 0.5,
	form_header_y = 0
}

if unified_inventory.lite_mode then
	unified_inventory.pagecols = 4
	unified_inventory.pagerows = 6
	unified_inventory.page_y = 0.25
	unified_inventory.formspec_y = 0.47
	unified_inventory.main_button_x = 8.2
	unified_inventory.main_button_y = 6.5
	unified_inventory.craft_result_x = 2.8
	unified_inventory.craft_result_y = 3.4
	unified_inventory.form_header_y = -0.1
end

unified_inventory.items_per_page = unified_inventory.pagecols * unified_inventory.pagerows

-- Disable default creative inventory
if rawget(_G, "creative_inventory") then
	function creative_inventory.set_creative_formspec(player, start_i, pagenum)
		return
	end
end

dofile(modpath.."/group.lua")
dofile(modpath.."/api.lua")
dofile(modpath.."/internal.lua")
dofile(modpath.."/callbacks.lua")
dofile(modpath.."/register.lua")

if not unified_inventory.lite_mode then
	dofile(modpath.."/bags.lua")
end

dofile(modpath.."/item_names.lua")

if minetest.get_modpath("datastorage") and not unified_inventory.lite_mode then
	dofile(modpath.."/waypoints.lua")
end

