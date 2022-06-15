minetest.register_on_receiving_chat_message(function(message)
	if message:find('\1b@mcl_death_messages\1b') and minetest.settings:get_bool("mark_deathmessages") ~= false then
		minetest.display_chat_message(minetest.colorize("#F25819", "[Deathmessage] ") .. message)
		return true
	end
end) 

minetest.register_cheat("Deathmessages", "Chat", "mark_deathmessages")
