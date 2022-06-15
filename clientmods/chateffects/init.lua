chateffects = {}

function chateffects.send(message)
	local starts_with = message:sub(1, 1)
	
	if starts_with == "/" or starts_with == "." then return end

	local reverse = minetest.settings:get_bool("chat_reverse")
	
	if reverse then
		local msg = ""
		for i = 1, #message do
			msg = message:sub(i, i) .. msg
		end
		message = msg
	end
	
	local use_chat_color = minetest.settings:get_bool("use_chat_color")
	local color = minetest.settings:get("chat_color") or "rainbow"

	if use_chat_color then
		local msg
		if color == "rainbow" then
			msg = minetest.rainbow(message)
		else
			msg = minetest.colorize(color, message)
		end
		message = msg
	end
	
	minetest.send_chat_message(message)
	return true
end

minetest.register_on_sending_chat_message(chateffects.send)

minetest.register_cheat("Colored", "Chat", "use_chat_color")
minetest.register_cheat("Reversed", "Chat", "chat_reverse")
 
