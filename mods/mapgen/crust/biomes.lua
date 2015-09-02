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


biomes:register("Chaparral", function(constructor)
	constructor:add_param("humidity", { min = 50, max = 75 })
	constructor:add_param("temperature", { min = 30, max = 50 })
	
	constructor:require_node("bedrock", "core:rock")
	constructor:require_node("shore_subsurface", "core:sand")
	constructor:require_node("shore_surface", "core:sand")
	constructor:require_node("subsurface", "core:dirt")
	constructor:require_node("surface", "core:chaparral_grass")
	constructor:require_node("water_surface", "core:water_source")
	constructor:require_node("water_subsurface", "core:water_source")
	
	constructor:set_fits(biomesfunctions.default())
end)

biomes:register("Deciduous Forest", function(constructor)
	constructor:add_param("humidity", { min = 75, max = 999999 })
	constructor:add_param("temperature", { min = 30, max = 50 })
	
	constructor:require_node("bedrock", "core:rock")
	constructor:require_node("shore_subsurface", "core:sand")
	constructor:require_node("shore_surface", "core:sand")
	constructor:require_node("subsurface", "core:dirt")
	constructor:require_node("surface", "core:deciduous_forest_grass")
	constructor:require_node("water_surface", "core:water_source")
	constructor:require_node("water_subsurface", "core:water_source")
	
	constructor:set_fits(biomesfunctions.default())
end)

biomes:register("Desert", function(constructor)
	constructor:add_param("humidity", { min = -999999, max = 16 })
	constructor:add_param("temperature", { min = 45, max = 999999 })
	
	constructor:require_node("bedrock", "core:sand_stone")
	constructor:require_node("shore_subsurface", "core:sand")
	constructor:require_node("shore_surface", "core:sand")
	constructor:require_node("subsurface", "core:sand")
	constructor:require_node("surface", "core:sand")
	constructor:require_node("water_surface", "core:water_source")
	constructor:require_node("water_subsurface", "core:water_source")
	
	constructor:set_fits(biomesfunctions.default())
end)

biomes:register("Glacier", function(constructor)
	constructor:add_param("humidity", { min = -999999, max = 999999 })
	constructor:add_param("temperature", { min = -999999, max = -12 })
	
	constructor:require_node("bedrock", "core:glacial_ice")
	constructor:require_node("shore_subsurface", "core:snow")
	constructor:require_node("shore_surface", "core:snow")
	constructor:require_node("subsurface", "core:snow")
	constructor:require_node("surface", "core:snow")
	constructor:require_node("water_surface", "core:ice")
	constructor:require_node("water_subsurface", "core:ice")
	
	constructor:set_fits(biomesfunctions.default())
end)

biomes:register("Grassland", function(constructor)
	constructor:add_param("humidity", { min = 23, max = 50 })
	constructor:add_param("temperature", { min = 30, max = 45 })
	
	constructor:require_node("bedrock", "core:rock")
	constructor:require_node("shore_subsurface", "core:sand")
	constructor:require_node("shore_surface", "core:sand")
	constructor:require_node("subsurface", "core:dirt")
	constructor:require_node("surface", "core:grassland_grass")
	constructor:require_node("water_surface", "core:water_source")
	constructor:require_node("water_subsurface", "core:water_source")
	
	constructor:set_fits(biomesfunctions.default())
end)

biomes:register("Rainforest", function(constructor)
	constructor:add_param("humidity", { min = 80, max = 999999 })
	constructor:add_param("temperature", { min = 45, max = 999999 })
	
	constructor:require_node("bedrock", "core:rock")
	constructor:require_node("shore_subsurface", "core:sand")
	constructor:require_node("shore_surface", "core:sand")
	constructor:require_node("subsurface", "core:dirt")
	constructor:require_node("surface", "core:rainforest_grass")
	constructor:require_node("water_surface", "core:water_source")
	constructor:require_node("water_subsurface", "core:water_source")
	constructor:set_fits(biomesfunctions.default())
end)

biomes:register("Savannah", function(constructor)
	constructor:add_param("humidity", { min = 16, max = 32 })
	constructor:add_param("temperature", { min = 45, max = 999999 })
	
	constructor:require_node("bedrock", "core:rock")
	constructor:require_node("shore_subsurface", "core:sand")
	constructor:require_node("shore_surface", "core:sand")
	constructor:require_node("subsurface", "core:dirt")
	constructor:require_node("surface", "core:savannah_grass")
	constructor:require_node("water_surface", "core:water_source")
	constructor:require_node("water_subsurface", "core:water_source")
	
	constructor:set_fits(biomesfunctions.default())
end)

biomes:register("Seasonal Rainforest", function(constructor)
	constructor:add_param("humidity", { min = 64, max = 80 })
	constructor:add_param("temperature", { min = 45, max = 999999 })
	
	constructor:require_node("bedrock", "core:rock")
	constructor:require_node("shore_subsurface", "core:sand")
	constructor:require_node("shore_surface", "core:sand")
	constructor:require_node("subsurface", "core:dirt")
	constructor:require_node("surface", "core:seasonal_rainforest_grass")
	constructor:require_node("water_surface", "core:water_source")
	constructor:require_node("water_subsurface", "core:water_source")
	
	constructor:set_fits(biomesfunctions.default())
end)

biomes:register("Seasonal Shrubland", function(constructor)
	constructor:add_param("humidity", { min = 32, max = 48 })
	constructor:add_param("temperature", { min = 45, max = 999999 })
	
	constructor:require_node("bedrock", "core:rock")
	constructor:require_node("shore_subsurface", "core:sand")
	constructor:require_node("shore_surface", "core:sand")
	constructor:require_node("subsurface", "core:dirt")
	constructor:require_node("surface", "core:seasonal_shrubland_grass")
	constructor:require_node("water_surface", "core:water_source")
	constructor:require_node("water_subsurface", "core:water_source")
	
	constructor:set_fits(biomesfunctions.default())
end)

biomes:register("Snowy Tundra", function(constructor)
	constructor:add_param("humidity", { min = -999999, max = 999999 })
	constructor:add_param("temperature", { min = -12, max = -6 })
	
	constructor:require_node("bedrock", "core:rock")
	constructor:require_node("shore_subsurface", "core:gravel")
	constructor:require_node("shore_surface", "core:gravel")
	constructor:require_node("subsurface", "core:dirt")
	constructor:require_node("surface", "core:snowy_tundra_dirt")
	constructor:require_node("water_surface", "core:ice")
	constructor:require_node("water_subsurface", "core:water_source")
	
	constructor:set_fits(biomesfunctions.default())
end)

biomes:register("Swamp", function(constructor)
	constructor:add_param("humidity", { min = 85, max = 999999 })
	constructor:add_param("temperature", { min = 5, max = 30 })
	
	constructor:require_node("bedrock", "core:rock")
	constructor:require_node("shore_subsurface", "core:sand")
	constructor:require_node("shore_surface", "core:sand")
	constructor:require_node("subsurface", "core:dirt")
	constructor:require_node("surface", "core:swamp_grass")
	constructor:require_node("water_surface", "core:water_source")
	constructor:require_node("water_subsurface", "core:water_source")
	
	constructor:set_fits(biomesfunctions.default())
end)

biomes:register("Taiga", function(constructor)
	constructor:add_param("humidity", { min = -999999, max = 85 })
	constructor:add_param("temperature", { min = 5, max = 30 })
	
	constructor:require_node("bedrock", "core:rock")
	constructor:require_node("shore_subsurface", "core:sand")
	constructor:require_node("shore_surface", "core:sand")
	constructor:require_node("subsurface", "core:dirt")
	constructor:require_node("surface", "core:taiga_grass")
	constructor:require_node("water_surface", "core:water_source")
	constructor:require_node("water_subsurface", "core:water_source")
	
	constructor:set_fits(biomesfunctions.default())
end)

biomes:register("Tropical Seasonal Rainforest", function(constructor)
	constructor:add_param("humidity", { min = 48, max = 64 })
	constructor:add_param("temperature", { min = 45, max = 999999 })
	
	constructor:require_node("bedrock", "core:rock")
	constructor:require_node("shore_subsurface", "core:sand")
	constructor:require_node("shore_surface", "core:sand")
	constructor:require_node("subsurface", "core:dirt")
	constructor:require_node("surface", "core:tropical_seasonal_rainforest_grass")
	constructor:require_node("water_surface", "core:water_source")
	constructor:require_node("water_subsurface", "core:water_source")
	
	constructor:set_fits(biomesfunctions.default())
end)

biomes:register("Tundra", function(constructor)
	constructor:add_param("humidity", { min = -999999, max = 999999 })
	constructor:add_param("temperature", { min = -6, max = 5 })
	
	constructor:require_node("bedrock", "core:rock")
	constructor:require_node("shore_subsurface", "core:dirt")
	constructor:require_node("shore_surface", "core:gravel")
	constructor:require_node("subsurface", "core:dirt")
	constructor:require_node("surface", "core:tundra_grass")
	constructor:require_node("water_surface", "core:water_source")
	constructor:require_node("water_subsurface", "core:water_source")
	
	constructor:set_fits(biomesfunctions.default())
end)

biomes:register("Wasteland", function(constructor)
	constructor:add_param("humidity", { min = -999999, max = 23 })
	constructor:add_param("temperature", { min = 30, max = 50 })
	
	constructor:require_node("bedrock", "core:red_rock")
	constructor:require_node("shore_subsurface", "core:wasteland_dirt")
	constructor:require_node("shore_surface", "core:wasteland_dirt")
	constructor:require_node("subsurface", "core:wasteland_dirt")
	constructor:require_node("surface", "core:wasteland_dirt")
	constructor:require_node("water_surface", "core:water_source")
	constructor:require_node("water_subsurface", "core:water_source")
	
	constructor:set_fits(biomesfunctions.default())
end)


worldgen:register("crust.biomes", function(constructor)
	constructor:set_condition(function(module, metadata, minp, maxp)
		if metadata.cache.biomes == nil then
			metadata.cache.biomes = arrayutil.create2d(minp.x, minp.z, maxp.x, maxp.z, nil)
			metadata.biomes = metadata.cache.biomes
			return true
		end
		
		metadata.biomes = metadata.cache.biomes
		return false
	end)
	
	constructor:set_run_2d(function(module, metadata, manipulator, x, z)
		local elevation = metadata.heightmap[x][z]
		local temperature = metadata.temperaturemap[x][z]
		local humidity = metadata.humiditymap[x][z]
		
		metadata.biomes[x][z] = biomes:get_biome(x, elevation, z, temperature, humidity, metadata)
	end)
end)

