local etime = 0

minetest.register_globalstep(function(dtime)
	local player = minetest.localplayer
	if not player then return end
	local item = player:get_wielded_item()
	local itemname = item:get_name()
	local itemdef = minetest.get_item_def(itemname)
	local wieldindex = player:get_wield_index()
	etime = etime + dtime
	if minetest.settings:get_bool("autorefill") and itemname ~= "" and itemdef and etime > 0.1 then
		etime = 0
		local space = item:get_free_space()
		local i = minetest.find_item(item:get_name(), wieldindex + 1)
		if i and space > 0 then
			local invact = InventoryAction("move")
			invact:to("current_player", "main", wieldindex)
			invact:from("current_player", "main", i)
			invact:set_count(space)
			invact:apply()
		end
	end
	if minetest.settings:get_bool("autoeject") then
		local invact = InventoryAction("drop")
		local list = (minetest.settings:get("eject_items") or ""):split(",")
		local inventory = minetest.get_inventory("current_player")
		for index, stack in pairs(inventory.main) do
			if table.indexof(list, stack:get_name()) ~= -1 then
				invact:from("current_player", "main", index)
				invact:apply()
			end
		end
	end
end)

minetest.register_list_command("eject", "Configure AutoEject", "eject_items")

minetest.register_cheat("AutoRefill", "Inventory", "autorefill")
minetest.register_cheat("AutoEject", "Inventory", "autoeject")
