minetest.register_on_dignode(function(pos)
	if minetest.settings:get_bool("replace") then
		minetest.after(0, minetest.place_node, pos)
	end
end)

local etime = 0

minetest.register_globalstep(function(dtime)
	etime = etime + dtime
	if etime < 1 then return end
	local player = minetest.localplayer
	if not player then return end
	local pos = player:get_pos()
	local item = player:get_wielded_item()
	local def = minetest.get_item_def(item:get_name())
	local nodes_per_tick = tonumber(minetest.settings:get("nodes_per_tick")) or 8
	if item and item:get_count() > 0 and def and def.node_placement_prediction ~= "" then
		if minetest.settings:get_bool("scaffold") then
			local p = vector.round(vector.add(pos, {x = 0, y = -0.6, z = 0}))
			local node = minetest.get_node_or_nil(p)
			if not node or minetest.get_node_def(node.name).buildable_to then
				minetest.place_node(p)
			end
		end
		if minetest.settings:get_bool("scaffold_plus") then
			local z = pos.z
			local positions = {
				{x = 0, y = -0.6, z = 0},
                {x = 1, y = -0.6, z = 0},
                {x = -1, y = -0.6, z = 0},
                {x = -1, y = -0.6, z = -1},
                {x = 0, y = -0.6, z = -1},
                {x = 1, y = -0.6, z = -1},
                {x = -1, y = -0.6, z = 1},
                {x = 0, y = -0.6, z = 1},
                {x = 1, y = -0.6, z = 1}
			}
			for i, p in pairs(positions) do
				minetest.place_node(vector.add(pos, p))
			end
		end
		if minetest.settings:get_bool("block_water") then
			local positions = minetest.find_nodes_near(pos, 5, {"mcl_core:water_source", "mcl_core:water_floating"}, true)
			for i, p in pairs(positions) do
				if i > nodes_per_tick then return end
				minetest.place_node(p)
			end
		end
		if minetest.settings:get_bool("block_lava") then
			local positions = minetest.find_nodes_near(pos, 5, {"mcl_core:lava_source", "mcl_core:lava_floating"}, true)
			for i, p in pairs(positions) do
				if i > nodes_per_tick then return end
				minetest.place_node(p)
			end
		end
		if minetest.settings:get_bool("autotnt") then
			local positions = minetest.find_nodes_near_under_air_except(pos, 5, item:get_name(), true)
			for i, p in pairs(positions) do
				if i > nodes_per_tick then return end
				minetest.place_node(vector.add(p, {x = 0, y = 1, z = 0}))
			end
		end
	end
	if minetest.settings:get_bool("nuke") then
		local i = 0
		for x = pos.x - 4, pos.x + 4 do
			for y = pos.y - 4, pos.y + 4 do
				for z = pos.z - 4, pos.z + 4 do
					local p = vector.new(x, y, z)
					local node = minetest.get_node_or_nil(p)
					local def = node and minetest.get_node_def(node.name)
					if def or def.diggable then
						if i > nodes_per_tick then return end
						minetest.dig_node(p)
						i = i + 1
					end
				end
			end
		end
	end
end)

minetest.register_cheat("Scaffold", "World", "scaffold")
minetest.register_cheat("ScaffoldPlus", "World", "scaffold_plus")
minetest.register_cheat("BlockWater", "World", "block_water")
minetest.register_cheat("BlockLava", "World", "block_lava")
minetest.register_cheat("AutoTNT", "World", "autotnt")
minetest.register_cheat("Nuke", "World", "nuke")
minetest.register_cheat("Replace", "World", "replace")
