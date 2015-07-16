-- large_hotbar: Makes the hotbar larger
-- Copyright (c) 2015 Calinou
-- CC0 1.0 Universal

custom_hotbar_size = tonumber(minetest.setting_get("large_hotbar.size"))

minetest.register_on_joinplayer(function(player)
  player:hud_set_hotbar_itemcount(custom_hotbar_size or 16)
end)
