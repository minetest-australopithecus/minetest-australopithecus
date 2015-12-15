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


ap.mapgen.worldgen:register("crust.humiditymap.init", function(constructor)
	constructor:add_param("base_value", 0)
	
	constructor:set_run_before(function(module, metadata, manipulator, minp, maxp)
		if metadata.cache.humiditymap == nil then
			metadata.cache.humiditymap = arrayutil.create2d(minp.x, minp.z, maxp.x, maxp.z, module.params.base_value)
			
			metadata.generate_humiditymap = true
		end
		
		metadata.humiditymap = metadata.cache.humiditymap
	end)
end)

ap.mapgen.worldgen:register("crust.humiditymap.major", function(constructor)
	constructor:add_param("high", 100)
	constructor:add_param("low", 0)
	
	constructor:require_noise2d("main", 3, 0.4, 1.0, 3000)
	
	constructor:set_condition(worldgenfunctions.if_true("generate_humiditymap"))
	constructor:set_run_2d(worldgenfunctions.ranged_noise_2d("humiditymap"))
end)

ap.mapgen.worldgen:register("crust.humiditymap.details", function(constructor)
	constructor:add_param("variation_max", 1)
	constructor:add_param("variation_min", -1)
	
	constructor:require_noise2d("main", 5, 0.6, 1.0, 270)
	
	constructor:set_condition(worldgenfunctions.if_true("generate_humiditymap"))
	constructor:set_run_2d(function(module, metadata, manipulator, x, z)
		local value = module.noises.main[x][z]
		value = mathutil.clamp(value, -1, 1)
		value = transform.linear(
			value,
			-1,
			1,
			module.params.variation_min,
			module.params.variation_max)
		
		metadata.humiditymap[x][z] = metadata.humiditymap[x][z] + value
	end)
end)


