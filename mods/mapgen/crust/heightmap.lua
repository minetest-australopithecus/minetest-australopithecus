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


ap.mapgen.worldgen:register("crust.heightmap.init", function(constructor)
	constructor:add_param("base_value", 0)
	
	constructor:set_run_before(function(module, metadata, manipulator, minp, maxp)
		if metadata.cache.heightmap == nil then
			metadata.cache.heightmap = arrayutil.create2d(minp.x, minp.z, maxp.x, maxp.z, module.params.base_value)
			metadata.cache.heightmap_info = arrayutil.create2d(minp.x, minp.z, maxp.x, maxp.z, {})
			metadata.cache.heightmap_range = {
				max = -31000,
				min = 31000
			}
			
			metadata.generate_heightmap = true
		end
		
		metadata.heightmap = metadata.cache.heightmap
		metadata.heightmap_info = metadata.cache.heightmap_info
		metadata.heightmap_range = metadata.cache.heightmap_range
	end)
end)

ap.mapgen.worldgen:register("crust.heightmap.major", function(constructor)
	constructor:add_param("lower_bound", -125)
	constructor:add_param("upper_bound", 125)
	
	constructor:require_noise2d("flat", 2, 0.7, 0.3, 3700)
	constructor:require_noise2d("mask", 4, 0.5, 1.0, 4300)
	constructor:require_noise2d("normal", 5, 0.6, 1.0, 2200)
	constructor:require_noise2d("ridged", 4, 0.4, 1.0, 2500)
	
	constructor:set_condition(worldgenfunctions.if_true("generate_heightmap"))
	constructor:set_run_2d(function(module, metadata, manipulator, x, z)
		local value_normal = module.noises.normal[x][z]
		
		local value_ridged = module.noises.ridged[x][z]
		value_ridged = transform.centered_cosine(value_ridged, -1, 1, -1, 1)
		
		local value_flat = module.noises.flat[x][z]
		
		local value_mask = module.noises.mask[x][z]
		local value = nil
		
		if value_mask <= -0.3 then
			value = value_normal
		elseif value_mask <= 0.3 then
			value_mask = transform.linear(value_mask, -0.3, 0.3, 0, 1)
			value_mask = mathutil.clamp(value_mask, 0, 1)
			value = interpolate.linear(value_mask, value_normal, value_ridged)
		elseif value_mask <= 0.6 then
			value = value_ridged
		elseif value_mask <= 0.80 then
			value_mask = transform.linear(value_mask, 0.6, 0.8, 0, 1)
			value_mask = mathutil.clamp(value_mask, 0, 1)
			value = interpolate.linear(value_mask, value_ridged, value_normal)
		elseif value_mask <= 0.98 then
			value_mask = transform.linear(value_mask, 0.80, 0.98, 0, 1)
			value_mask = mathutil.clamp(value_mask, 0, 1)
			value = interpolate.linear(value_mask, value_normal, value_flat)
		else
			value = value_flat
		end
		
		value = transform.linear(
			value,
			-1,
			1,
			module.params.lower_bound,
			module.params.upper_bound)
		
		metadata.heightmap[x][z] = value
	end)
end)

ap.mapgen.worldgen:register("crust.heightmap.minor", function(constructor)
	constructor:add_param("multiplier", 20)
	
	constructor:require_noise2d("main", 4, 0.5, 1.0, 240)
	
	constructor:set_condition(worldgenfunctions.if_true("generate_heightmap"))
	constructor:set_run_2d(worldgenfunctions.multiplied_noise_2d("heightmap"))
end)

ap.mapgen.worldgen:register("crust.heightmap.canyon", function(constructor)
	constructor:add_param("fade", 0.1)
	constructor:add_param("multiplier", -42)
	constructor:add_param("threshold_mask_max", 0.8)
	constructor:add_param("threshold_mask_min", 0.3)
	constructor:add_param("threshold_max", 0.3)
	constructor:add_param("threshold_min", -0.3)
	
	constructor:require_noise2d("mask", 2, 0.3, 0.9, 7800)
	constructor:require_noise2d("ridged", 5, 0.7, 0.9, 3780)
	
	constructor:set_condition(worldgenfunctions.if_true("generate_heightmap"))
	constructor:set_run_2d(worldgenfunctions.masked_ridged_noise_2d("heightmap", "heightmap_info", "canyon"))
end)

ap.mapgen.worldgen:register("crust.heightmap.ravine", function(constructor)
	constructor:add_param("fade", 0.1)
	constructor:add_param("multiplier", -37)
	constructor:add_param("threshold_mask_max", 0.9)
	constructor:add_param("threshold_mask_min", 0.2)
	constructor:add_param("threshold_max", 0.3)
	constructor:add_param("threshold_min", -0.3)
	
	constructor:require_noise2d("mask", 2, 0.3, 0.9, 970)
	constructor:require_noise2d("ridged", 5, 0.6, 0.9, 500)
	
	constructor:set_condition(worldgenfunctions.if_true("generate_heightmap"))
	constructor:set_run_2d(worldgenfunctions.masked_ridged_noise_2d("heightmap", "heightmap_info", "ravine"))
end)

ap.mapgen.worldgen:register("crust.heightmap.channels", function(constructor)
	constructor:add_param("fade", 0.1)
	constructor:add_param("multiplier", -3)
	constructor:add_param("threshold_mask_max", 0.9)
	constructor:add_param("threshold_mask_min", 0.2)
	constructor:add_param("threshold_max", 0.3)
	constructor:add_param("threshold_min", -0.3)
	
	constructor:require_noise2d("mask", 2, 0.3, 0.9, 1050)
	constructor:require_noise2d("ridged", 4, 0.6, 0.9, 250)
	
	constructor:set_condition(worldgenfunctions.if_true("generate_heightmap"))
	constructor:set_run_2d(worldgenfunctions.masked_ridged_noise_2d("heightmap", "heightmap_info", "channels"))
end)

ap.mapgen.worldgen:register("crust.heightmap.cliffs", function(constructor)
	constructor:add_param("fade", 0.2)
	constructor:add_param("multiplier", 17)
	constructor:add_param("smoothed", true)
	constructor:add_param("threshold_mask_max", 1.0)
	constructor:add_param("threshold_mask_min", 0.4)
	constructor:add_param("threshold_max", 0.7)
	constructor:add_param("threshold_min", 0.1)
	constructor:add_param("summit", 0.1)
	
	constructor:require_noise2d("main", 4, 0.6, 0.9, 320)
	constructor:require_noise2d("mask", 3, 0.3, 0.9, 240)
	
	constructor:set_condition(worldgenfunctions.if_true("generate_heightmap"))
	constructor:set_run_2d(function(module, metadata, manipulator, x, z)
		local mask_value = module.noises.mask[x][z]
		
		if mask_value >= module.params.threshold_mask_min and mask_value <= module.params.threshold_mask_max then
			local value = module.noises.main[x][z]
			
			if value >= module.params.threshold_min and value <= module.params.threshold_max then
				value = transform.linear(
					value,
					module.params.threshold_min,
					module.params.threshold_max - module.params.summit)
				value = mathutil.clamp(value, 0, 1)
				value = interpolate.cosine(value)
				value = worldgenfunctions.fade(value, mask_value, module)
				value = value * module.params.multiplier
				
				metadata.heightmap[x][z] = metadata.heightmap[x][z] + value
				metadata.heightmap_info[x][z].cliffs = true
			end
		end
	end)
end)

ap.mapgen.worldgen:register("crust.heightmap.extrusions", function(constructor)
	constructor:add_param("threshold_mask_max", 0.99)
	constructor:add_param("threshold_mask_min", 0.86)
	constructor:add_param("value_min", 0)
	constructor:add_param("value_max", 23)
	
	constructor:require_noise2d("main", 4, 0.8, 0.9, 245)
	constructor:require_noise2d("mask", 5, 0.5, 0.9, 1080)
	
	constructor:set_condition(worldgenfunctions.if_true("generate_heightmap"))
	constructor:set_run_2d(worldgenfunctions.masked_noise_2d("heightmap"))
end)

ap.mapgen.worldgen:register("crust.heightmap.positive-highlights", function(constructor)
	constructor:add_param("smoothed", true)
	constructor:add_param("threshold_mask_max", 1.0)
	constructor:add_param("threshold_mask_min", 0.5)
	constructor:add_param("value_min", 0)
	constructor:add_param("value_max", 3)
	
	constructor:require_noise2d("main", 2, 0.6, 0.9, 15)
	constructor:require_noise2d("mask", 6, 0.5, 0.9, 550)
	
	constructor:set_condition(worldgenfunctions.if_true("generate_heightmap"))
	constructor:set_run_2d(worldgenfunctions.masked_noise_2d("heightmap", "heightmap_info", "positive_highlights"))
end)

ap.mapgen.worldgen:register("crust.heightmap.negative-highlights", function(constructor)
	constructor:add_param("smoothed", true)
	constructor:add_param("threshold_mask_max", -0.6)
	constructor:add_param("threshold_mask_min", -1.0)
	constructor:add_param("value_min", 0)
	constructor:add_param("value_max", -4)
	
	constructor:require_noise2d("main", 3, 0.4, 0.9, 15)
	constructor:require_noise2d("mask", 6, 0.4, 0.9, 500)
	
	constructor:set_condition(worldgenfunctions.if_true("generate_heightmap"))
	constructor:set_run_2d(worldgenfunctions.masked_noise_2d("heightmap", "heightmap_info", "negative_highlights"))
end)

ap.mapgen.worldgen:register("crust.heightmap.peaks", function(constructor)
	constructor:add_param("multiplier", 6)
	constructor:add_param("threshold_above", 85)
	constructor:add_param("threshold_mask_max", 0.25)
	constructor:add_param("threshold_mask_min", -0.25)
	
	constructor:require_noise2d("mask", 8, 0.6, 0.9, 1200)
	
	constructor:set_condition(worldgenfunctions.if_true("generate_heightmap"))
	constructor:set_run_2d(worldgenfunctions.masked_boost("heightmap", "heightmap_info", "peaks"))
end)

ap.mapgen.worldgen:register("crust.heightmap.trenches", function(constructor)
	constructor:add_param("multiplier", -6)
	constructor:add_param("threshold_below", -76)
	constructor:add_param("threshold_mask_max", 0.5)
	constructor:add_param("threshold_mask_min", -0.75)
	
	constructor:require_noise2d("mask", 6, 0.5, 0.9, 1200)
	
	constructor:set_condition(worldgenfunctions.if_true("generate_heightmap"))
	constructor:set_run_2d(worldgenfunctions.masked_boost("heightmap", "heightmap_info", "trenches"))
end)

ap.mapgen.worldgen:register("crust.heightmap.flatlands", function(constructor)
	constructor:add_param("fade", 0.3)
	constructor:add_param("multiplier", 120)
	constructor:add_param("threshold_mask_max", 1.0)
	constructor:add_param("threshold_mask_min", 0.6)
	
	constructor:require_noise2d("main", 2, 0.4, 0.9, 5300)
	constructor:require_noise2d("mask", 4, 0.7, 0.9, 1600)
	
	constructor:set_condition(worldgenfunctions.if_true("generate_heightmap"))
	constructor:set_run_2d(function(module, metadata, manipulator, x, z)
		local mask_value = module.noises.mask[x][z]
		mask_value = mathutil.clamp(mask_value, -1, 1)
		
		if mask_value >= module.params.threshold_mask_min and mask_value <= module.params.threshold_mask_max then
			local value = module.noises.main[x][z]
			value = mathutil.clamp(value, -1, 1)
			value = value * module.params.multiplier
			
			local faded_mask_value = 1
			if mask_value <= module.params.threshold_mask_min + module.params.fade then
				faded_mask_value = transform.cosine(
					mask_value,
					module.params.threshold_mask_min,
					module.params.threshold_mask_min + module.params.fade)
			end
			
			metadata.heightmap[x][z] = interpolate.cosine(
				faded_mask_value,
				metadata.heightmap[x][z],
				value)
			metadata.heightmap_info[x][z].flatlands = true
		end
	end)
end)

ap.mapgen.worldgen:register("crust.heightmap.terraces", function(constructor)
	constructor:add_param("fade", 0.1)
	constructor:add_param("terrace_height", 5)
	constructor:add_param("threshold_mask_max", 1.0)
	constructor:add_param("threshold_mask_min", 0.8)
	
	constructor:require_noise2d("mask", 4, 0.7, 0.9, 1900)
	
	constructor:set_condition(worldgenfunctions.if_true("generate_heightmap"))
	constructor:set_run_2d(function(module, metadata, manipulator, x, z)
		local mask_value = module.noises.mask[x][z]
		mask_value = mathutil.clamp(mask_value, -1, 1)
		
		if mathutil.in_range(mask_value, module.params.threshold_mask_min, module.params.threshold_mask_max) then
			local height = metadata.heightmap[x][z]
			local terrace_height = module.params.terrace_height
			
			if mathutil.in_range(mask_value, module.params.threshold_mask_min, module.params.threshold_mask_min + module.params.fade) then
				terrace_height = transform.cosine(
					mask_value,
					module.params.threshold_mask_min,
					module.params.threshold_mask_min + module.params.fade,
					1,
					terrace_height)
				terrace_height = math.ceil(terrace_height)
			end
			
			height = height / terrace_height
			height = math.ceil(height)
			height = height * terrace_height
			
			metadata.heightmap[x][z] = height
		end
	end)
end)

ap.mapgen.worldgen:register("crust.heightmap.round", function(constructor)
	constructor:set_condition(worldgenfunctions.if_true("generate_heightmap"))
	constructor:set_run_2d(function(module, metadata, manipulator, x, z)
		metadata.heightmap[x][z] = mathutil.round(metadata.heightmap[x][z])
	end)
end)

ap.mapgen.worldgen:register("crust.heightmap.finalization", function(constructor)
	constructor:set_condition(worldgenfunctions.if_true("generate_heightmap"))
	constructor:set_run_2d(function(module, metadata, manipulator, x, z)
		local value = metadata.heightmap[x][z]
		
		metadata.heightmap_range.max = math.max(metadata.heightmap_range.max, value)
		metadata.heightmap_range.min = math.min(metadata.heightmap_range.min, value)
	end)
end)

