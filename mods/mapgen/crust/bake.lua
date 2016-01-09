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


ap.mapgen.crust:register("baking.shore", function(constructor)
	constructor:add_param("ocean_level", -58)
	constructor:add_param("shore_max", 6)
	constructor:add_param("shore_min", 2)
	
	constructor:require_noise2d("shore", 4, 0.5, 1, 840)
	
	constructor:set_condition(function(module, metadata, minp, maxp)
		return metadata.heightmap_range.max >= minp.y
	end)
	constructor:set_run_before(function(module, metadata, manipulator, minp, maxp)
		metadata.shore = arrayutil.create2d(minp.x, minp.z, maxp.x, maxp.z, nil)
	end)
	constructor:set_run_2d(function(module, metadata, manipulator, x, z, y)
		local shore_height = module.noises.shore[x][z]
		shore_height = transform.linear(
			shore_height,
			-1,
			1,
			module.params.shore_min,
			module.params.shore_max)
		
		metadata.shore[x][z] = (metadata.heightmap[x][z] <= (module.params.ocean_level + shore_height))
	end)
end)

ap.mapgen.crust:register("baking.heightmap", function(constructor)
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
		metadata.biome = metadata.biomes[x][z]
		metadata.height = metadata.heightmap[x][z]
		metadata.is_shore = metadata.shore[x][z]
		metadata.bedrock_depth = transform.linear(
			module.noises.bedrock[x][z],
			-1,
			1,
			module.params.bedrock_min,
			module.params.bedrock_max)
		metadata.subsurface_depth = transform.linear(
			module.noises.subsurface[x][z],
			-1,
			1,
			module.params.subsurface_min,
			module.params.subsurface_max)
	end)
	constructor:set_run_3d(function(module, metadata, manipulator, x, z, y)
		if y > metadata.height then
			manipulator:set_node(x, z, y, module.nodes.air)
		elseif y == metadata.height then
			if metadata.is_shore then
				manipulator:set_node(x, z, y, metadata.biome.nodes.shore_surface)
			else
				manipulator:set_node(x, z, y, metadata.biome.nodes.surface)
			end
		elseif y < metadata.height
			and y >= (metadata.height - metadata.subsurface_depth) then
			if metadata.is_shore then
				manipulator:set_node(x, z, y, metadata.biome.nodes.shore_subsurface)
			else
				manipulator:set_node(x, z, y, metadata.biome.nodes.subsurface)
			end
		elseif y < (metadata.height - metadata.subsurface_depth)
			and y >= (metadata.height - metadata.subsurface_depth - metadata.bedrock_depth)then
			manipulator:set_node(x, z, y, metadata.biome.nodes.bedrock)
		else
			manipulator:set_node(x, z, y, module.nodes.rock)
		end
	end)
end)

ap.mapgen.crust:register("baking.transform", function(constructor)
	constructor:add_param("mask_threshold_max", 1.0)
	constructor:add_param("mask_threshold_min", 0.65)
	constructor:add_param("max_depth", 57)
	constructor:add_param("min_depth", 41)
	constructor:add_param("threshold_max", 0.75)
	constructor:add_param("threshold_min", 0.25)
	
	constructor:require_node("air", "air")
	
	constructor:require_noise2d("depth", 4, 0.8, 1, 430)
	
	constructor:require_noise3d("fade", 6, 0.8, 0.8, 1500)
	constructor:require_noise3d("main", 4, 0.6, 1, 150, 200, 150)
	constructor:require_noise3d("mask", 5, 0.7, 0.9, 2400)
	
	constructor:set_condition(function(module, metadata, minp, maxp)
		return maxp.y >= (metadata.heightmap_range.min - module.params.max_depth)
			and minp.y <= metadata.heightmap_range.max
	end)
	constructor:set_run_2d(function(module, metadata, manipulator, x, z)
		local depth = module.noises.depth[x][z]
		depth = transform.cosine(
			depth,
			-1,
			1,
			module.params.min_depth,
			module.params.max_depth)
		
		metadata.transform_depth = metadata.heightmap[x][z] - depth
	end)
	constructor:set_run_3d(function(module, metadata, manipulator, x, z, y)
		if y >= metadata.transform_depth then
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

ap.mapgen.crust:register("baking.upper-caves", function(constructor)
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
		return metadata.heightmap_range.max >= minp.y
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

ap.mapgen.crust:register("baking.lower-caves", function(constructor)
	constructor:add_param("depth_end", -2800)
	constructor:add_param("depth_flooded", -2600)
	constructor:add_param("depth_start", -1400)
	constructor:add_param("threshold_max", 1.0)
	constructor:add_param("threshold_min", 0.7)
	
	constructor:require_node("air", "air")
	constructor:require_node("water", "core:water_source")
	
	constructor:require_noise3d("main", 7, 0.9, 0.5, 462, 460, 462)
	
	constructor:set_condition(function(module, metadata, minp, maxp)
		return metadata.heightmap_range.max >= minp.y
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

ap.mapgen.crust:register("baking.surface-detection", function(constructor)
	constructor:add_param("max_depth", 57 + 5)
	constructor:add_param("ocean_level", -58)
	constructor:add_param("overlap", 3)
	
	constructor:require_node("air", "air")
	constructor:require_node("ignore", "ignore")
	
	constructor:set_condition(function(module, metadata, minp, maxp)
		metadata.surfacemap = arrayutil.create2d(minp.x, minp.z, maxp.x, maxp.z, nil)
		
		return metadata.heightmap_range.max >= minp.y
			and maxp.y >= module.params.ocean_level
	end)
	constructor:set_run_2d(function(module, metadata, manipulator, x, z)
		-- The +1 -1 is for overshooting our range, this fixes that the surface
		-- is not correctly detected on block borders.
		for y = metadata.maxp.y + 1, metadata.minp.y - 1, -1 do
			local current_node = manipulator:get_node(x, z, y)
			
			if current_node == module.nodes.ignore then
				-- Do nothing, continue on.
			elseif current_node ~= module.nodes.air then
				metadata.surfacemap[x][z] = y
				
				local overlap = module.params.overlap
				
				for x2 = x - overlap, x + overlap, 1 do
					for z2 = z - overlap, z + overlap, 1 do
						if manipulator:get_node(x2, z2, y + 1) == module.nodes.air
							and manipulator:get_node(x2, z2, y) ~= module.nodes.air then
							
							local biome = metadata.biomes[x2]
							if biome ~= nil then
								biome = biome[z2]
								
								if biome ~= nil then
									if metadata.shore[x2][z2] then
										manipulator:set_node(x2, z2, y, biome.nodes.shore_surface)
										
										if manipulator:get_node(x2, z2, y - 1) ~= module.nodes.air then
											manipulator:set_node(x2, z2, y - 1, biome.nodes.shore_subsurface)
										end
									elseif y >= module.params.ocean_level then
										manipulator:set_node(x2, z2, y, biome.nodes.surface)
										
										if manipulator:get_node(x2, z2, y - 1) ~= module.nodes.air then
											manipulator:set_node(x2, z2, y - 1, biome.nodes.subsurface)
										end
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

ap.mapgen.crust:register("baking.remove-single", function(constructor)
	constructor:add_param("nodes", {
		[nodeutil.get_id("core:sand")] = true,
		[nodeutil.get_id("core:snow")] = true
	})
	
	constructor:require_node("air", "air")
	
	constructor:set_condition(function(module, metadata, minp, maxp)
		return metadata.heightmap_range.max >= minp.y
	end)
	constructor:set_run_3d(function(module, metadata, manipulator, x, z, y)
		if module.params.nodes[manipulator:get_node(x, z, y)]
			and manipulator:get_node(x, z, y + 1) == module.nodes.air
			and manipulator:get_node(x, z, y - 1) == module.nodes.air then
			
			manipulator:set_node(x, z, y, module.nodes.air)
		end
	end)
end)

ap.mapgen.crust:register("baking.ramps", function(constructor)
	local placer = MaskBasedPlacer:new()
	local secondary_placer = MaskBasedPlacer:new()
	
	local register_ramp = function(name)
		placer:register_node({
			initial_rotation = rotationutil.ROT_90,
			node = "core:" .. name,
			node_above = "air",
			node_not_below = "air",
			replacement_node = "core:" .. name .. "_ramp",
			surroundings = {
				MaskBasedPlacer.MASK_VALUE_IGNORE,
				{ ["not"] = "air" },
				{ ["not"] = "air" },
				{ ["not"] = "air" },
				{ ["not"] = "air" },
				{ ["not"] = "air" },
				MaskBasedPlacer.MASK_VALUE_IGNORE,
				"air"
			},
			upside_down = true
		})
		
		placer:register_node({
			initial_rotation = rotationutil.ROT_90,
			node = "core:" .. name,
			node_above = "air",
			node_not_below = "air",
			replacement_node = "core:" .. name .. "_ramp",
			surroundings = {
				MaskBasedPlacer.MASK_VALUE_IGNORE,
				"air",
				MaskBasedPlacer.MASK_VALUE_IGNORE,
				{ ["not"] = "air" },
				MaskBasedPlacer.MASK_VALUE_IGNORE,
				"air",
				MaskBasedPlacer.MASK_VALUE_IGNORE,
				"air"
			},
			upside_down = true,
			upside_down_pseudo_mirroring = true
		})
		
		placer:register_node({
			initial_rotation = rotationutil.ROT_90,
			node = "core:" .. name,
			node_above = "air",
			node_not_below = "air",
			replacement_node = "core:" .. name .. "_ramp_outer_corner_flat",
			surroundings = {
				MaskBasedPlacer.MASK_VALUE_IGNORE,
				"air",
				MaskBasedPlacer.MASK_VALUE_IGNORE,
				{ ["not"] = "air" },
				{ ["not"] = "air" },
				{ ["not"] = "air" },
				MaskBasedPlacer.MASK_VALUE_IGNORE,
				"air"
			},
			upside_down = true,
			upside_down_pseudo_mirroring = true,
			after_place = function(x, z, y, definition, rotation, upside_down, manipulator)
				if upside_down then
					secondary_placer:run_on_coordinates(manipulator, x, z, y + 1)
				else
					secondary_placer:run_on_coordinates(manipulator, x, z, y - 1)
				end
			end
		})
		
		placer:register_node({
			initial_rotation = rotationutil.ROT_90,
			node = "core:" .. name,
			node_above = "air",
			node_not_below = "air",
			replacement_node = "core:" .. name .. "_ramp_inner_corner_flat",
			surroundings = {
				"air",
				{ ["not"] = "air" },
				{ ["not"] = "air" },
				{ ["not"] = "air" },
				{ ["not"] = "air" },
				{ ["not"] = "air" },
				{ ["not"] = "air" },
				{ ["not"] = "air" }
			},
			upside_down = true,
			upside_down_pseudo_mirroring = true
		})
		
		secondary_placer:register_node({
			initial_rotation = rotationutil.ROT_90,
			node = "core:" .. name,
			node_name_above = ".*_ramp_outer_corner_flat",
			node_not_below = "air",
			replacement_node = "core:" .. name .. "_ramp_inner_corner_flat",
			surroundings = {
				"air",
				MaskBasedPlacer.MASK_VALUE_IGNORE,
				MaskBasedPlacer.MASK_VALUE_IGNORE,
				{ ["not"] = "air" },
				{ ["not"] = "air" },
				{ ["not"] = "air" },
				MaskBasedPlacer.MASK_VALUE_IGNORE,
				MaskBasedPlacer.MASK_VALUE_IGNORE
			},
			upside_down = true,
			upside_down_pseudo_mirroring = true,
			after_place = function(x, z, y, definition, rotation, upside_down, manipulator)
				-- Clone the rotation from the parent node.
				local direction = 1
				if upside_down then
					direction = -1
				end
				
				local parent_node, param2 = manipulator:get_node(x, z, y + direction)
				manipulator:set_node(x, z, y, definition.replacement_node, param2)
			end
		})
	end
	
	register_ramp("dirt")
	register_ramp("glacial_ice")
	register_ramp("gravel")
	register_ramp("red_rock")
	register_ramp("rock")
	register_ramp("sand")
	register_ramp("sand_stone")
	register_ramp("snow")
	register_ramp("wasteland_dirt")
	
	constructor:add_object("placer", placer)
	
	constructor:set_condition(function(module, metadata, minp, maxp)
		return metadata.heightmap_range.max >= minp.y
	end)
	constructor:set_run_before(function(module, metadata, manipulator, minp, maxp)
		local extended_minp = vector.subtract(minp, 1)
		local extended_maxp = vector.add(maxp, 1)
		
		module.objects.placer:run(manipulator, extended_minp, extended_maxp)
	end)
end)

ap.mapgen.crust:register("baking.ocean", function(constructor)
	constructor:add_param("cave_flood_depth", 23)
	constructor:add_param("max_depth", 47 + 3)
	constructor:add_param("ocean_level", -58)
	
	constructor:require_node("air", "air")
	
	constructor:set_condition(function(module, metadata, minp, maxp)
		return minp.y <= (module.params.ocean_level - module.params.cave_flood_depth)
			and maxp.y >= (metadata.heightmap_range.min - module.params.max_depth)
	end)
	constructor:set_run_2d(function(module, metadata, manipulator, x, z)
		local current_height = metadata.surfacemap[x][z] or metadata.heightmap[x][z]
		
		if current_height <= module.params.ocean_level then
			local biome = metadata.biomes[x][z]
			
			-- Main operation for flodding everything with water.
			for y = metadata.maxp.y, math.max(metadata.minp.y, current_height), -1 do
				if manipulator:get_node(x, z, y) == module.nodes.air then
					if y == module.params.ocean_level then
						manipulator:set_node(x, z, y, biome.nodes.water_surface)
					elseif y <= module.params.ocean_level then
						manipulator:set_node(x, z, y, biome.nodes.water_subsurface)
					end
				end
			end
			
			-- Now we will flood the caves below us.
			if current_height > metadata.minp.y then
				for y = current_height, math.max(metadata.minp.y, current_height - module.params.cave_flood_depth), -1 do
					if manipulator:get_node(x, z, y) == module.nodes.air then
						manipulator:set_node(x, z, y, biome.nodes.water_subsurface)
					end
				end
			end
		end
	end)
end)

