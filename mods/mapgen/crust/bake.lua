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


ap.mapgen.worldgen:register("crust.baking.init", function(constructor)
	constructor:set_run_before(function(module, metadata, manipulator, minp, maxp)
		metadata.crust = {}
	end)
end)

ap.mapgen.worldgen:register("crust.baking.shore", function(constructor)
	constructor:add_param("ocean_level", -58)
	constructor:add_param("shore_max", 6)
	constructor:add_param("shore_min", 2)
	
	constructor:require_noise2d("shore", 4, 0.5, 1, 840)
	
	constructor:set_condition(function(module, metadata, minp, maxp)
		return metadata.heightmap_range.max >= minp.y
	end)
	constructor:set_run_before(function(module, metadata, manipulator, minp, maxp)
		metadata.crust.shore = arrayutil.create2d(minp.x, minp.z, maxp.x, maxp.z, nil)
	end)
	constructor:set_run_2d(function(module, metadata, manipulator, x, z, y)
		local shore_height = module.noises.shore[x][z]
		shore_height = transform.linear(
			shore_height,
			-1,
			1,
			module.params.shore_min,
			module.params.shore_max)
		
		metadata.crust.shore[x][z] = (metadata.heightmap[x][z] <= (module.params.ocean_level + shore_height))
	end)
end)

ap.mapgen.worldgen:register("crust.baking.heightmap", function(constructor)
	constructor:add_param("bedrock_max", 84)
	constructor:add_param("bedrock_min", 24)
	constructor:add_param("subsurface_max", 29)
	constructor:add_param("subsurface_min", 1)
	
	constructor:require_node("air", "air")
	constructor:require_node("rock", "core:rock")
	
	constructor:require_noise2d("bedrock", 4, 0.3, 1, 680)
	constructor:require_noise2d("subsurface", 4, 0.3, 1, 680)
	
	constructor:set_condition(function(module, metadata, minp, maxp)
		return metadata.heightmap_range.max >= minp.y
	end)
	constructor:set_run_2d(function(module, metadata, manipulator, x, z, y)
		metadata.crust.biome = metadata.biomes[x][z]
		metadata.crust.height = metadata.heightmap[x][z]
		metadata.crust.is_shore = metadata.crust.shore[x][z]
		metadata.crust.bedrock_depth = transform.linear(
			module.noises.bedrock[x][z],
			-1,
			1,
			module.params.bedrock_min,
			module.params.bedrock_max)
		metadata.crust.subsurface_depth = transform.linear(
			module.noises.subsurface[x][z],
			-1,
			1,
			module.params.subsurface_min,
			module.params.subsurface_max)
	end)
	constructor:set_run_3d(function(module, metadata, manipulator, x, z, y)
		if y > metadata.crust.height then
			manipulator:set_node(x, z, y, module.nodes.air)
		elseif y == metadata.crust.height then
			if metadata.crust.is_shore then
				manipulator:set_node(x, z, y, metadata.crust.biome.nodes.shore_surface)
			else
				manipulator:set_node(x, z, y, metadata.crust.biome.nodes.surface)
			end
		elseif y < metadata.crust.height
			and y >= (metadata.crust.height - metadata.crust.subsurface_depth) then
			if metadata.crust.is_shore then
				manipulator:set_node(x, z, y, metadata.crust.biome.nodes.shore_subsurface)
			else
				manipulator:set_node(x, z, y, metadata.crust.biome.nodes.subsurface)
			end
		elseif y < (metadata.crust.height - metadata.crust.subsurface_depth)
			and y >= (metadata.crust.height - metadata.crust.subsurface_depth - metadata.crust.bedrock_depth)then
			manipulator:set_node(x, z, y, metadata.crust.biome.nodes.bedrock)
		else
			manipulator:set_node(x, z, y, module.nodes.rock)
		end
	end)
end)

ap.mapgen.worldgen:register("crust.baking.transform", function(constructor)
	constructor:add_param("mask_threshold_max", 1.0)
	constructor:add_param("mask_threshold_min", 0.65)
	constructor:add_param("max_depth", 47)
	constructor:add_param("threshold_max", 0.75)
	constructor:add_param("threshold_min", 0.25)
	
	constructor:require_node("air", "air")
	
	constructor:require_noise3d("fade", 6, 0.8, 0.8, 1500)
	constructor:require_noise3d("main", 4, 0.6, 1, 150, 200, 150)
	constructor:require_noise3d("mask", 5, 0.7, 0.9, 2400)
	
	constructor:set_condition(function(module, metadata, minp, maxp)
		return maxp.y >= (metadata.heightmap_range.min - module.params.max_depth)
			and minp.y <= metadata.heightmap_range.max
	end)
	constructor:set_run_3d(function(module, metadata, manipulator, x, z, y)
		if y >= (metadata.heightmap[x][z] - module.params.max_depth) then
			local value = module.noises.main[x][z][y]
			local mask_value = module.noises.mask[x][z][y]
			mask_value = mathutil.clamp(mask_value, -1, 1)
			
			if mathutil.in_range(value, module.params.threshold_min, module.params.threshold_max)
				and mathutil.in_range(mask_value, module.params.mask_threshold_min, module.params.mask_threshold_max) then
				
				local fade_value = module.noises.fade[x][z][y]
				local fade_threshold = transform.cosine(
					metadata.heightmap[x][z] - y,
					0,
					module.params.max_depth,
					-1,
					1)
				
				if fade_value >= fade_threshold then
					manipulator:set_node(x, z, y, module.nodes.air)
				end
			end
		end
	end)
end)

ap.mapgen.worldgen:register("crust.baking.upper-caves)", function(constructor)
	constructor:add_param("depth_limit", -1600)
	constructor:add_param("fade_limit", 33)
	constructor:add_param("threshold_mask_max", 0.9)
	constructor:add_param("threshold_mask_min", 0.2)
	constructor:add_param("threshold_max", 0.1)
	constructor:add_param("threshold_min", -0.1)
	
	constructor:require_node("air", "air")
	
	constructor:require_noise3d("a", 2, 0.6, 1, 50, 25, 50)
	constructor:require_noise3d("b", 2, 0.6, 1, 50, 25, 50)
	constructor:require_noise3d("fade", 4, 0.6, 1, 300, 600, 300)
	
	constructor:set_condition(function(module, metadata, minp, maxp)
		return (metadata.heightmap_range.max >= minp.y)
			and maxp.y >= module.params.depth_limit
	end)
	constructor:set_run_3d(function(module, metadata, manipulator, x, z, y)
		if y >= module.params.depth_limit then
			local value_a = module.noises.a[x][z][y]
			local value_b = module.noises.b[x][z][y]
			
			if mathutil.in_range(value_a, module.params.threshold_min, module.params.threshold_max)
				and mathutil.in_range(value_b, module.params.threshold_min, module.params.threshold_max) then
				
				local below_elevation = metadata.heightmap[x][z] - y
				
				if below_elevation > module.params.fade_limit then
					if y >= module.params.depth_limit then
						manipulator:set_node(x, z, y, module.nodes.air)
					end
				else
					local fade_value = module.noises.fade[x][z][y]
					local fade_threshold = transform.linear(
						below_elevation,
						0,
						module.params.fade_limit,
						0.8,
						-1)
						
					if fade_value >= fade_threshold then
						manipulator:set_node(x, z, y, module.nodes.air)
					end
				end
			end
		end
	end)
end)

ap.mapgen.worldgen:register("crust.baking.lower-caves)", function(constructor)
	constructor:add_param("depth_end", -2800)
	constructor:add_param("depth_flooded", -2600)
	constructor:add_param("depth_start", -1400)
	constructor:add_param("threshold_max", 1.0)
	constructor:add_param("threshold_min", 0.7)
	
	constructor:require_node("air", "air")
	constructor:require_node("water", "core:water_source")
	
	constructor:require_noise3d("main", 7, 0.9, 0.5, 462, 460, 462)
	
	constructor:set_condition(function(module, metadata, minp, maxp)
		return (metadata.heightmap_range.max >= minp.y)
			and maxp.y <= module.params.depth_start
			and minp.y >= module.params.depth_end
	end)
	constructor:set_run_3d(function(module, metadata, manipulator, x, z, y)
		if y <= module.params.depth_start
			and y >= module.params.depth_end then
			
			local value = module.noises.main[x][z][y]
			value = mathutil.clamp(value, -1, 1)
			
			if mathutil.in_range(value, module.params.threshold_min, module.params.threshold_max) then
				if y >= module.params.depth_flooded then
					manipulator:set_node(x, z, y, module.nodes.air)
				else
					manipulator:set_node(x, z, y, module.nodes.water)
				end
			end
		end
	end)
end)

ap.mapgen.worldgen:register("crust.baking.surface-detection", function(constructor)
	constructor:add_param("max_depth", 47 + 10)
	constructor:add_param("ocean_level", -58)
	constructor:add_param("overlap", 3)
	
	constructor:require_node("air", "air")
	constructor:require_node("ignore", "ignore")
	
	constructor:set_condition(function(module, metadata, minp, maxp)
		return metadata.heightmap_range.max >= minp.y
			and maxp.y >= module.params.ocean_level
	end)
	constructor:set_run_2d(function(module, metadata, manipulator, x, z)
		-- The +1 -1 is for overshooting our range, this fixes that the surface
		-- is not correctly detected on block borders.
		for y = metadata.maxp.y + 1, math.max(metadata.minp.y - 1, module.params.ocean_level), -1 do
			local current_node = manipulator:get_node(x, z, y)
			
			if current_node == module.nodes.ignore then
				-- Do nothing, continue on.
			elseif current_node ~= module.nodes.air then
				local overlap = module.params.overlap
				
				for x2 = x - overlap, x + overlap, 1 do
					for z2 = z - overlap, z + overlap, 1 do
						if manipulator:get_node(x2, z2, y + 1) == module.nodes.air
							and manipulator:get_node(x2, z2, y) ~= module.nodes.air then
							
							local biome = metadata.biomes[x2]
							if biome ~= nil then
								biome = biome[z2]
								
								if biome ~= nil then
									if metadata.crust.shore[x2][z2] then
										manipulator:set_node(x2, z2, y, biome.nodes.shore_surface)
									else
										manipulator:set_node(x2, z2, y, biome.nodes.surface)
									end
								end
							end
						end
					end
				end
				
				return
			end
		end
	end)
end)

ap.mapgen.worldgen:register("crust.baking.ocean", function(constructor)
	constructor:add_param("max_depth", 47 + 3)
	constructor:add_param("ocean_level", -58)
	
	constructor:require_node("air", "air")
	
	constructor:set_condition(function(module, metadata, minp, maxp)
		return minp.y <= module.params.ocean_level
			and maxp.y >= (metadata.heightmap_range.min - module.params.max_depth)
	end)
	constructor:set_run_2d(function(module, metadata, manipulator, x, z)
		local biome = metadata.biomes[x][z]
		
		for y = metadata.maxp.y, metadata.minp.y, -1 do
			if manipulator:get_node(x, z, y) == module.nodes.air then
				if y == module.params.ocean_level then
					manipulator:set_node(x, z, y, biome.nodes.water_surface)
				elseif y <= module.params.ocean_level then
					manipulator:set_node(x, z, y, biome.nodes.water_subsurface)
				end
			end
		end
	end)
end)

ap.mapgen.worldgen:register("crust.baking.ramps", function(constructor)
	local rampplacer = RampPlacer:new()
	
	rampplacer:register_air_like("core:water_source")
	rampplacer:register_air_like("core:water_flowing")
	
	local register_ramp = function(name, ceiling, floor)
		rampplacer:register_ramp(
			"core:" .. name,
			"core:" .. name .. "_ramp",
			"core:" .. name .. "_ramp_inner_corner",
			"core:" .. name .. "_ramp_outer_corner",
			ceiling,
			floor
		)
	end
	
	register_ramp("dirt", true, true)
	register_ramp("glacial_ice", true, true)
	register_ramp("gravel", true, false)
	register_ramp("red_rock", true, true)
	register_ramp("rock", true, true)
	register_ramp("sand", true, false)
	register_ramp("sand_stone", true, true)
	register_ramp("snow", true, false)
	register_ramp("wasteland_dirt", true, true)
	
	constructor:add_object("rampplacer", rampplacer)
	
	constructor:set_condition(function(module, metadata, minp, maxp)
		return metadata.heightmap_range.max >= minp.y
	end)
	constructor:set_run_before(function(module, metadata, manipulator, minp, maxp)
		module.objects.rampplacer:run(manipulator, minp, maxp)
	end)
end)

