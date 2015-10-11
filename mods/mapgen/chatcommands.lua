--[[
Copyright (c) 2015, Robert 'Bobby' Zenz
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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

