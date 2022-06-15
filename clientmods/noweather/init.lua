minetest.register_on_spawn_particle(function(particle)
	if minetest.settings:get_bool("noweather") and particle.texture:sub(1, 12) == "weather_pack" then
		return true
	end
end)

minetest.register_on_play_sound(function(sound)
	if minetest.settings:get_bool("noweather") and sound.name == "weather_rain" then
		return true
	end
end)
 
minetest.register_cheat("NoWeather", "Render", "noweather")
