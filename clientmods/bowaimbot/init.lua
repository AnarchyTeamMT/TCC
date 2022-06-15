local atan, pi, pow, sqrt = math.atan, math.pi, math.pow, math.sqrt
local aim_name 

minetest.register_globalstep(function()
	if not minetest.settings:get_bool("bowaimbot") or not aim_name then return end
	local player = minetest.localplayer
	if not player then return end
	if player:get_wielded_item():get_name():sub(1, 12) ~= "mcl_bows:bow" then return end
	local ppos = player:get_pos()
	local objects = minetest.get_objects_inside_radius(ppos, 80)
	for _, obj in ipairs(objects) do
		if obj:get_name() == aim_name then
			local opos = obj:get_pos()
			local vec = vector.subtract(ppos, opos)
			
			local yaw = atan(vec.z / vec.x) - pi/2
			yaw = yaw + (opos.x >= ppos.x and pi or 0)
			player:set_yaw((yaw + pi) / pi * 180)
			
			local v = 40
			local g = -9.81
			local y = vec.y
			vec.y = 0
			local x = vector.length(vec)
			
			local pitch = atan(pow(v, 2) / (g * x) + sqrt(pow(v, 4)/(pow(g, 2) * pow(x, 2)) - 2 * pow(v, 2) * y/(g * pow(x, 2)) - 1))
			player:set_pitch(pitch / pi * 180)
			break
		end
	end
end)

minetest.register_chatcommand("aim", {
	func = function(param)
		aim_name = param
	end
})

minetest.register_cheat("BowAimbot", "Combat", "bowaimbot")
