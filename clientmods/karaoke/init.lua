karaoke = {}

local storage = minetest.get_mod_storage("karaoke")
local etime, lines

function karaoke.remaining()
	return lines
end

function karaoke.sing(title)
	local text = storage:get_string(title)

	if text == "" then
		return false, "Song not found"
	end

	lines = text:split("\n")
	etime = 0
end

minetest.register_chatcommand("kedit", {
	func = function(param)
		minetest.show_formspec("karaoke", [[
			size[9,5;]
			field[0.5,0.3;8.5,1;title;Song Title;]] .. param .. [[]
			textarea[0.5,1.1;8.5,4;text;Song Text;]] .. storage:get_string(param) .. [[]
			button_exit[3.3,4.5;2,1;save;Save]
		]])
	end,
})

minetest.register_chatcommand("kdelete", {
	func = function(param)
		storage:set_string(param, "")
		return true, "Song deleted: " .. param
	end,
})

minetest.register_chatcommand("ksing", {
	func = karaoke.sing,
})

minetest.register_chatcommand("kcancel", {
	func = function()
		etime, lines = nil
	end,
})

minetest.register_chatcommand("klist", {
	func = function()
		local songs = {}

		for k in pairs(storage:to_table().fields) do
			table.insert(songs, k)
		end

		return true, table.concat(songs, ", ")
	end,
})

minetest.register_on_formspec_input(function(formname, fields)
	if formname == "karaoke" and fields.title and fields.text and fields.title ~= "" and fields.text ~= "" then
		storage:set_string(fields.title, fields.text)
		print("Song saved: " .. fields.title)
	end
end)

minetest.register_globalstep(function(dtime)
	if lines then
		etime = etime - dtime

		if etime < 0 then
			local line = table.remove(lines, 1)

			if line then
				minetest.send_chat_message("/me " .. minetest.colorize("#C609FF", line) .. "")
				etime = line:len() * 0.1
			else
				etime, lines = nil
			end
		end
	end
end)
