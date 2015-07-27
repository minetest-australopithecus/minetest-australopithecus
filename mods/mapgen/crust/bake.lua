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


local PrototypeNode = {
	AIR = 0,
	TRANSFORM = 1,
	CAVE = 2,
	ROCK = 3,
	WATER = 4,
	SURFACE = 5
}

local function is_air(prototypeNode)
	return prototypeNode == PrototypeNode.AIR
		or prototypeNode == PrototypeNode.TRANSFORM
		or prototypeNode == PrototypeNode.CAVE
end


worldgen:register("Crust - Baking (Init)", function(constructor)
	constructor:set_run_before(function(module, metadata, manipulator, minp, maxp)
		metadata.crust_prototype = arrayutil.create3d(
			minp.x, minp.z, minp.y,
			maxp.x, maxp.z, maxp.y,
			PrototypeNode.AIR)
	end)
end)

worldgen:register("Crust - Baking (Heightmap)", function(constructor)
	constructor:set_run_3d(function(module, metadata, manipulator, x, z, y)
		if y <= metadata.heightmap[x][z] then
			metadata.crust_prototype[x][z][y] = PrototypeNode.ROCK
		end
	end)
end)

worldgen:register("Crust - Baking (3D Transform)", function(constructor)
	constructor:add_param("fade", 0.2)
	constructor:add_param("mask_threshold_max", 1.0)
	constructor:add_param("mask_threshold_min", 0.15)
	constructor:add_param("max_depth", 47)
	constructor:add_param("threshold_max", 0.75)
	constructor:add_param("threshold_min", 0.25)
	
	constructor:require_noise3d("fade", 4, 0.8, 1, 1500)
	constructor:require_noise3d("main", 4, 0.6, 1, 150, 200, 150)
	constructor:require_noise3d("mask", 5, 0.7, 1, 2200)
	
	constructor:set_condition(function(module, metadata, minp, maxp)
		for x = minp.x, maxp.x, 1 do
			for z = minp.z, maxp.z, 1 do
				if (metadata.heightmap[x][z] - module.params.max_depth) <= maxp.y then
					return true
				end
			end
		end
		
		return false
	end)
	constructor:set_run_3d(function(module, metadata, manipulator, x, z, y)
		if y >= (metadata.heightmap[x][z] - module.params.max_depth) then
			local value = module.noises.main[x][z][y]
			local mask_value = module.noises.mask[x][z][y]
			
			if mathutil.in_range(value, module.params.threshold_min, module.params.threshold_max)
				and mathutil.in_range(mask_value, module.params.mask_threshold_min, module.params.mask_threshold_max) then
				
				local fade_value = module.noises.main[x][z][y]
				local fade_threshold = transform.cosine(
					metadata.heightmap[x][z] - y,
					0,
					module.params.max_depth,
					-1,
					1)
				
				if fade_value >= fade_threshold then
					metadata.crust_prototype[x][z][y] = PrototypeNode.TRANSFORM
				end
			end
		end
	end)
end)

worldgen:register("Crust - Baking (Caves)", function(constructor)
	constructor:add_param("fade_limit", 33)
	constructor:add_param("threshold_mask_max", 0.9)
	constructor:add_param("threshold_mask_min", 0.2)
	constructor:add_param("threshold_max", 0.1)
	constructor:add_param("threshold_min", -0.1)
	
	constructor:require_noise3d("a", 2, 0.6, 1, 50, 25, 50)
	constructor:require_noise3d("b", 2, 0.6, 1, 50, 25, 50)
	constructor:require_noise3d("fade", 4, 0.6, 1, 300, 600, 300)
	
	constructor:set_run_3d(function(module, metadata, manipulator, x, z, y)
		local value_a = module.noises.a[x][z][y]
		local value_b = module.noises.b[x][z][y]
		
		if mathutil.in_range(value_a, module.params.threshold_min, module.params.threshold_max)
			and mathutil.in_range(value_b, module.params.threshold_min, module.params.threshold_max) then
			
			local below_elevation = metadata.heightmap[x][z] - y
			
			if below_elevation > module.params.fade_limit then
				metadata.crust_prototype[x][z][y] = PrototypeNode.CAVE
			else
				local fade_value = module.noises.fade[x][z][y]
				local fade_threshold = transform.linear(
					below_elevation,
					0,
					module.params.fade_limit,
					0.8,
					-1)
					
				if fade_value >= fade_threshold then
					metadata.crust_prototype[x][z][y] = PrototypeNode.CAVE
				end
			end
		end
	end)
end)

worldgen:register("Crust - Baking (Surface Detection)", function(constructor)
	constructor:add_param("max_depth", 47 + 3)
	constructor:add_param("overlap", 3)
	
	constructor:set_condition(function(module, metadata, minp, maxp)
		for x = minp.x, maxp.x, 1 do
			for z = minp.z, maxp.z, 1 do
				if (metadata.heightmap[x][z] - module.params.max_depth) <= maxp.y then
					return true
				end
			end
		end
		
		return false
	end)
	constructor:set_run_2d(function(module, metadata, manipulator, x, z)
		for y = metadata.maxp.y, metadata.minp.y, -1 do
			if metadata.crust_prototype[x][z][y] == PrototypeNode.ROCK then
				local overlap = module.params.overlap
				
				for x2 = x - overlap, x + overlap, 1 do
					for z2 = z - overlap, z + overlap, 1 do
						local current = metadata.crust_prototype[x2]
						
						if current ~= nil then
							current = current[z2]
							
							if current ~= nil then
								if is_air(current[y + 1]) and current[y] == PrototypeNode.ROCK then
									current[y] = PrototypeNode.SURFACE
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

worldgen:register("Crust - Baking (Finalize)", function(constructor)
	constructor:add_param("bedrock_max", 84)
	constructor:add_param("bedrock_min", 24)
	constructor:add_param("cave_flood_depth", 8)
	constructor:add_param("ocean_level", -58)
	constructor:add_param("shore_max", 6)
	constructor:add_param("shore_min", 2)
	constructor:add_param("subsurface_max", 29)
	constructor:add_param("subsurface_min", 1)
	
	constructor:require_node("rock", "core:rock")
	
	constructor:require_noise2d("bedrock", 4, 0.3, 1, 680)
	constructor:require_noise2d("shore", 4, 0.5, 1, 840)
	constructor:require_noise2d("subsurface", 4, 0.3, 1, 680)
	
	constructor:set_run_2d(function(module, metadata, manipulator, x, z)
		local shore_value = module.noises.shore[x][z]
		shore_value = mathutil.clamp(shore_value, -1, 1)
		shore_value = transform.linear(
			shore_value,
			-1,
			1,
			module.params.shore_min,
			module.params.shore_max)
		
		if metadata.heightmap[x][z] <= (module.params.ocean_level + shore_value) then
			metadata.heightmap_info[x][z].ocean = true
		end
	end)
	
	constructor:set_run_3d(function(module, metadata, manipulator, x, z, y)
		local prototype = metadata.crust_prototype[x][z]
		
		local biome = metadata.biomes[x][z]
		local elevation = metadata.heightmap[x][z]
		local elevation_info = metadata.heightmap_info[x][z]
		
		if biome ~= nil then
			if (y == elevation and not is_air(prototype[y]))
				or (y < elevation and prototype[y] == PrototypeNode.SURFACE) then
				if elevation_info.ocean then
					manipulator:set_node(x, z, y, biome.nodes.shore_surface)
				else
					manipulator:set_node(x, z, y, biome.nodes.surface)
				end
			elseif y < elevation and not is_air(prototype[y]) then
				local subsurface_value = module.noises.subsurface[x][z]
				subsurface_value = mathutil.clamp(subsurface_value, -1, 1)
				subsurface_value = transform.linear(
					subsurface_value,
					-1,
					1,
					module.params.subsurface_min,
					module.params.subsurface_max)
				
				if y >= elevation - subsurface_value then
					if elevation_info.cliffs or elevation_info.peaks then
						manipulator:set_node(x, z, y, biome.nodes.bedrock)
					else
						if elevation_info.ocean then
							manipulator:set_node(x, z, y, biome.nodes.shore_subsurface)
						else
							manipulator:set_node(x, z, y, biome.nodes.subsurface)
						end
					end
				else
					local bedrock_value = module.noises.bedrock[x][z]
					bedrock_value = mathutil.clamp(bedrock_value, -1, 1)
					bedrock_value = transform.linear(
						bedrock_value,
						-1,
						1,
						module.params.bedrock_min,
						module.params.bedrock_max)
					
					if y >= elevation - bedrock_value then
						manipulator:set_node(x, z, y, biome.nodes.bedrock)
					else
						manipulator:set_node(x, z, y, module.nodes.rock)
					end
				end
			elseif y <= module.params.ocean_level then
				if prototype[y] == PrototypeNode.AIR
					or prototype[y] == PrototypeNode.TRANSFORM
					or (prototype[y] == PrototypeNode.CAVE
						and elevation < module.params.ocean_level
						and y >= (elevation - module.params.cave_flood_depth)) then
					if y == module.params.ocean_level then
						manipulator:set_node(x, z, y, biome.nodes.water_surface)
					elseif y < module.params.ocean_level then
						manipulator:set_node(x, z, y, biome.nodes.water_subsurface)
					end
				end
			end
		end
	end)
end)

worldgen:register("Crust - Baking (Ramps)", function(constructor)
	local rampplacer = RampPlacer:new()
	
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
	
	register_ramp("glacial_ice", true, true)
	register_ramp("red_rock", true, true)
	register_ramp("rock", true, true)
	register_ramp("sand", true, false)
	register_ramp("sand_stone", true, true)
	register_ramp("snow", true, false)
	register_ramp("wasteland_dirt", true, false)
	
	constructor:add_object("rampplacer", rampplacer)
	
	constructor:set_run_before(function(module, metadata, manipulator, minp, maxp)
		module.objects.rampplacer:run(manipulator, minp, maxp)
	end)
end)

