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

