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


ap.mapgen = {}

local base_path = minetest.get_modpath(minetest.get_current_modname())

ap.mapgen.worldgen = nil


function reload_worldgen()
	ap.mapgen.worldgen = WorldGen:new()
	
	-- Order is important.
	
	dofile(base_path .. "/base.lua")
	
	-- Crust
	dofile(base_path .. "/crust/heightmap.lua")
	dofile(base_path .. "/crust/temperaturemap.lua")
	dofile(base_path .. "/crust/humiditymap.lua")
	dofile(base_path .. "/crust/biomes.lua")
	dofile(base_path .. "/crust/bake.lua")
	
	dofile(base_path .. "/finish.lua")
end


reload_worldgen()


minetest.register_chatcommand("delete-map", {
	description = "Deletes the current map chunk.",
	params = "<range>",
	func = function(name, range)
		if not minetest.check_player_privs(name, { ap_mapgen = true }) then
			return false, "No permission to execute this command."
		end
		
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
	func = function(name, params)
		if not minetest.check_player_privs(name, { ap_mapgen = true }) then
			return false, "No permission to execute this command."
		end
		
		reload_worldgen()
		return true, "Done"
	end
})

minetest.register_chatcommand("update-map", {
	description = "Updates the current map chunk.",
	params = "",
	func = function(name, params)
		if not minetest.check_player_privs(name, { ap_mapgen = true }) then
			return false, "No permission to execute this command."
		end
		
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


minetest.register_on_mapgen_init(function(mapgen_params)
	minetest.set_mapgen_params({
		flags = "nolight",
		mgname = "singlenode",
		water_level = -31000
	})
end)

minetest.register_on_generated(function(minp, maxp, block_seed)
	local manipulator = MapManipulator:new()
	
	ap.mapgen.worldgen:run(manipulator, minp, maxp)
	
	manipulator:set_data()
end)

