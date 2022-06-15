local etime = 0.0

minetest.register_globalstep(function(dtime)
	if not minetest.settings:get_bool("autosponge") then return end
	local player = minetest.localplayer
	if not player then return end
	if player:get_wielded_item():get_name() ~= "mcl_sponges:sponge" then return end
	etime = etime + dtime
	if etime >= 0.3 then
		etime = 0.0
	else
		return
	end
	local water = minetest.find_node_near(player:get_pos(), 4, "mcl_core:water_source")
	if water then
		minetest.place_node(water)
	end
end)

minetest.register_cheat("AutoSponge", "World", "autosponge")
