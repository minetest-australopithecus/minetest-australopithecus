--[[
Australopithecus, a game for Minetest.
Copyright (C) 2015, Robert 'Bobby' Zenz

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
--]]


minetest.register_chatcommand("delete-map", {
	description = "Deletes the current map chunk.",
	params = "<range>",
	prives = { ap_mapgen = true },
	func = function(name, range)
		range = tonumber(range) or 0
		range = range * 80
		
		local player = minetest.get_player_by_name(name)
		local position = player:getpos()
		
		local min = blockutil.get_begin_pos(position.x - range, position.y - range, position.z - range)
		local max = blockutil.get_end_pos(position.x + range, position.y + range, position.z + range)
		
		minetest.delete_area(min, max)
		
		return true, "Done "
			.. tableutil.to_string(min, true, false)
			.. " "
			.. tableutil.to_string(max, true, false)
	end
})

minetest.register_chatcommand("reload-mapgen", {
	description = "Reloads the world generator.",
	params = "",
	prives = { ap_mapgen = true },
	func = function(name, params)
		ap.mapgen.reload_worldgen()
		return true, "Done"
	end
})

minetest.register_chatcommand("update-map", {
	description = "Updates the current map chunk.",
	params = "",
	prives = { ap_mapgen = true },
	func = function(name, params)
		local player = minetest.get_player_by_name(name)
		local position = player:getpos()
		
		local min = blockutil.get_begin_pos(position.x, position.y, position.z)
		local max = blockutil.get_end_pos(position.x, position.y, position.z)
		
		local manipulator = MapManipulator:new(min, max)
		manipulator:get_data()
		manipulator:set_data()
		
		return true, "Done "
			.. tableutil.to_string(min, true, false)
			.. " "
			.. tableutil.to_string(max, true, false)
	end
})

