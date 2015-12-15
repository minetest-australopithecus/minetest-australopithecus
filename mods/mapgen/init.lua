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


local base_path = minetest.get_modpath(minetest.get_current_modname())


ap.mapgen = {}
ap.mapgen.worldgen = nil


ap.mapgen.reload_worldgen = function()
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


dofile(base_path .. "/privileges.lua")
dofile(base_path .. "/chatcommands.lua")


ap.mapgen.reload_worldgen()


minetest.register_on_mapgen_init(function(mapgen_params)
	minetest.set_mapgen_params({
		flags = "nolight",
		mgname = "singlenode",
		water_level = -31000
	})
end)

minetest.register_on_generated(function(minp, maxp, block_seed)
	if settings.get_bool("ap_mapgen_activate", true) then
		local manipulator = MapManipulator:new()
		
		ap.mapgen.worldgen:run(manipulator, minp, maxp, block_seed)
		
		manipulator:set_data()
	end
end)

