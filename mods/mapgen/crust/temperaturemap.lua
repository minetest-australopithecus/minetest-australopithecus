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


ap.mapgen.worldgen:register("crust.temperaturemap.init", function(constructor)
	constructor:add_param("base_value", 0)
	
	constructor:set_run_before(function(module, metadata, manipulator, minp, maxp)
		if metadata.cache.temperaturemap == nil then
			metadata.cache.temperaturemap = arrayutil.create2d(minp.x, minp.z, maxp.x, maxp.z, module.params.base_value)
			
			metadata.generate_temperaturemap = true
		end
		
		metadata.temperaturemap = metadata.cache.temperaturemap
	end)
end)

ap.mapgen.worldgen:register("crust.temperaturemap.major", function(constructor)
	constructor:add_param("high", 75)
	constructor:add_param("low", -25)
	
	constructor:require_noise2d("main", 4, 0.4, 1.0, 2700)
	
	constructor:set_condition(worldgenfunctions.if_true("generate_temperaturemap"))
	constructor:set_run_2d(worldgenfunctions.ranged_noise_2d("temperaturemap"))
end)

ap.mapgen.worldgen:register("crust.temperaturemap.elevation", function(constructor)
	constructor:add_param("ocean_level", -58)
	
	constructor:set_condition(worldgenfunctions.if_true("generate_temperaturemap"))
	constructor:set_run_2d(function(module, metadata, manipulator, x, z)
		local elevation = metadata.heightmap[x][z]
		
		local value = 0
		
		if elevation >= 131 then
			value = math.abs(math.floor(elevation / 8))
			value = value * 6
		elseif elevation >= 102 then
			value = math.abs(math.floor(elevation / 13))
			value = value * 6
		elseif elevation >= 0 then
			value = math.abs(math.floor(elevation / 27))
			value = value * 3
		elseif elevation >= module.params.ocean_level then
			value = math.abs(math.floor(elevation / 27))
			value = value * 3
			value = -value
		end
		
		metadata.temperaturemap[x][z] = metadata.temperaturemap[x][z] - value
	end)
end)

ap.mapgen.worldgen:register("crust.temperaturemap.details", function(constructor)
	constructor:add_param("variation_max", 0.5)
	constructor:add_param("variation_min", -0.5)
	
	constructor:require_noise2d("main", 5, 0.6, 1.0, 170)
	
	constructor:set_condition(worldgenfunctions.if_true("generate_temperaturemap"))
	constructor:set_run_2d(function(module, metadata, manipulator, x, z)
		local value = module.noises.main[x][z]
		value = mathutil.clamp(value, -1, 1)
		value = transform.linear(
			value,
			-1,
			1,
			module.params.variation_min,
			module.params.variation_max)
		
		metadata.temperaturemap[x][z] = metadata.temperaturemap[x][z] + value
	end)
end)

