minetest.register_globalstep(function(dtime)
	if not minetest.settings:get_bool("autotntsponge") then return end
	local player = minetest.localplayer
	if not player then return end
	if player:get_wielded_item():get_name() ~= "mcl_tnt:tnt" then return end
	local sponges = minetest.find_nodes_near_under_air(player:get_pos(), 4, {"mcl_sponges:sponge", "mcl_sponges:sponge_wet"})
	for _, p in ipairs(sponges) do
		minetest.place_node(vector.add(p, vector.new(0, 1, 0)))
	end
end)

minetest.register_cheat("AutoTNTSponge", "World", "autotntsponge")
