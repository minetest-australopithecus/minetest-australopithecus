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
		else
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

