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



local upsidedown_handler_default = facedirutil.create_after_node_placed_upsidedown_handler()

local upsidedown_handler_mirrored = facedirutil.create_after_node_placed_upsidedown_handler(true)

local nodebox_cache = nil

local function init_nodebox_cache()
	if nodebox_cache == nil then
		nodebox_cache = {}
		
		nodebox_cache.corners = {}
		nodebox_cache.corners.stepped = {}
		
		nodebox_cache.corners.corner = {
			type = "fixed",
			fixed = cornerutil.create_corner_nodebox(9)
		}
		
		for counter = 2, 9, 1 do
			nodebox_cache.corners.stepped[counter] = {
				type = "fixed",
				fixed = cornerutil.create_corner_nodebox(counter)
			}
		end
		
		nodebox_cache.stairs = {}
		nodebox_cache.stairs.stepped = {}
		nodebox_cache.stairs.stepped_inner = {}
		nodebox_cache.stairs.stepped_inner_flat = {}
		nodebox_cache.stairs.stepped_outer = {}
		nodebox_cache.stairs.stepped_outer_flat = {}
		
		for counter = 2, 9, 1 do
			nodebox_cache.stairs.stepped[counter] = {
				type = "fixed",
				fixed = ramputil.create_ramp_nodebox(counter)
			}
			nodebox_cache.stairs.stepped_inner[counter] = {
				type = "fixed",
				fixed = ramputil.create_inner_corner_nodebox(counter)
			}
			nodebox_cache.stairs.stepped_inner_flat[counter] = {
				type = "fixed",
				fixed = ramputil.create_inner_corner_flat_nodebox(counter)
			}
			nodebox_cache.stairs.stepped_outer[counter] = {
				type = "fixed",
				fixed = ramputil.create_outer_corner_nodebox(counter)
			}
			nodebox_cache.stairs.stepped_outer_flat[counter] = {
				type = "fixed",
				fixed = ramputil.create_outer_corner_flat_nodebox(counter)
			}
		end
		
		nodebox_cache.ramps = {}
		nodebox_cache.ramps.smooth = nodebox_cache.stairs.stepped[9]
		nodebox_cache.ramps.smooth_inner = nodebox_cache.stairs.stepped_inner[9]
		nodebox_cache.ramps.smooth_inner_flat = nodebox_cache.stairs.stepped_inner_flat[9]
		nodebox_cache.ramps.smooth_outer = nodebox_cache.stairs.stepped_outer[9]
		nodebox_cache.ramps.smooth_outer_flat = nodebox_cache.stairs.stepped_outer_flat[9]
		
		nodebox_cache.pyramids = {}
		nodebox_cache.pyramids.stepped = {}
		nodebox_cache.pyramids.stepped_connected_corner = {}
		nodebox_cache.pyramids.stepped_connected_cross = {}
		nodebox_cache.pyramids.stepped_connected_end = {}
		nodebox_cache.pyramids.stepped_connected_straight = {}
		nodebox_cache.pyramids.stepped_connected_t = {}
		
		for counter = 2, 9, 1 do
			nodebox_cache.pyramids.stepped[counter] = {
				type = "fixed",
				fixed = pyramidutil.create_nodebox(counter)
			}
			nodebox_cache.pyramids.stepped_connected_corner[counter] = {
				type = "fixed",
				fixed = pyramidutil.create_connected_corner_nodebox(counter)
			}
			nodebox_cache.pyramids.stepped_connected_cross[counter] = {
				type = "fixed",
				fixed = pyramidutil.create_connected_cross_nodebox(counter)
			}
			nodebox_cache.pyramids.stepped_connected_end[counter] = {
				type = "fixed",
				fixed = pyramidutil.create_connected_end_nodebox(counter)
			}
			nodebox_cache.pyramids.stepped_connected_straight[counter] = {
				type = "fixed",
				fixed = pyramidutil.create_connected_straight_nodebox(counter)
			}
			nodebox_cache.pyramids.stepped_connected_t[counter] = {
				type = "fixed",
				fixed = pyramidutil.create_connected_t_nodebox(counter)
			}
		end
		
		nodebox_cache.pyramids.smooth = nodebox_cache.pyramids.stepped[9]
		nodebox_cache.pyramids.smooth_connected_corner = nodebox_cache.pyramids.stepped_connected_corner[9]
		nodebox_cache.pyramids.smooth_connected_cross = nodebox_cache.pyramids.stepped_connected_cross[9]
		nodebox_cache.pyramids.smooth_connected_end = nodebox_cache.pyramids.stepped_connected_end[9]
		nodebox_cache.pyramids.smooth_connected_straight = nodebox_cache.pyramids.stepped_connected_straight[9]
		nodebox_cache.pyramids.smooth_connected_t = nodebox_cache.pyramids.stepped_connected_t[9]
		
		nodebox_cache.pyramids_halfheight = {}
		nodebox_cache.pyramids_halfheight.stepped = {}
		nodebox_cache.pyramids_halfheight.stepped_connected_corner = {}
		nodebox_cache.pyramids_halfheight.stepped_connected_cross = {}
		nodebox_cache.pyramids_halfheight.stepped_connected_end = {}
		nodebox_cache.pyramids_halfheight.stepped_connected_straight = {}
		nodebox_cache.pyramids_halfheight.stepped_connected_t = {}
		
		for key, value in pairs(nodebox_cache.pyramids) do
			if stringutil.startswith(key, "smooth") then
				nodebox_cache.pyramids_halfheight[key] = nodeboxutil.set_height(value, 0.5)
			else
				nodebox_cache.pyramids_halfheight[value] = {}
				
				for index, nodebox in ipairs(value) do
					nodebox_cache.pyramids_halfheight[value][index] = nodeboxutil.set_height(nodebox, 0.5)
				end
			end
		end
	end
end

local function make_description(name)
	-- First char to upper.
	name = string.upper(string.sub(name, 1, 1)) .. string.sub(name, 2)
	-- All other chars to upper.
	name = string.gsub(name, "_[a-z]", string.upper)
	-- Replace underscores.
	name = string.gsub(name, "_", " ")
	
	return name
end

local function register_node(definition)
	if definition.node_box ~= nil then
		definition.collision_box = definition.node_box
		definition.selection_box = definition.node_box
	end
	if definition.max_stack == nil then
		definition.stack_max = 64
	end
	
	local name = definition.name
	
	if not stringutil.startswith(name, "core:") then
		name = "core:" .. name
	end
	
	minetest.register_node(name, tableutil.clone(definition))
end

local function postfix_name(name, postfix, separator)
	if postfix == nil or #postfix == 0 then
		return name
	end
	
	if name == nil or #name == 0 then
		return postfix
	end
	
	separator = separator or "_"
	
	return name .. separator .. postfix
end

local function postfix_dropnames(drops, postfix)
	if type(drops) == "string" then
		return postfix_name(drops, postfix)
	end
	
	drops = tableutil.clone(drops)
	
	for index, item in ipairs(drops.items) do
		item.items[1] = postfix_name(item.items[1], postfix)
	end
	
	return drops
end


local function register_conversion(group, source, target)
	ap.core.artisanry:register(group, "core:" .. target, {
		{ "core:" .. source }
	})
	ap.core.artisanry:register("Blocks", "core:" .. source, {
		{ "core:" .. target }
	})
end


local function register_corners(definition)
	if nodebox_cache == nil then
		init_nodebox_cache()
	end
	
	for counter = 2, 9, 1 do
		local corner_name = definition.name .. "_corner_" .. counter
		local corner_definition = tableutil.merge(definition, {
			description = definition.description .. " (Corner with " .. counter .. " steps)",
			drawtype = "nodebox",
			drop = postfix_dropnames(definition.drop, "corner_" .. counter),
			groups = tableutil.merge(definition.groups, { preserves_below_node = NodeGroup.DUMMY }),
			name = corner_name,
			node_box = nodebox_cache.corners.stepped[counter],
			paramtype = "light",
			paramtype2 = "facedir"
		})
		
		register_node(corner_definition)
		register_conversion("Corners", definition.name, corner_name)
	end
	
	-- Corner
	local corner_smooth_name = definition.name .. "_corner_smooth"
	local corner_smooth_definition = tableutil.merge(definition, {
		description = definition.description .. " (Smooth Corner)",
		drawtype = "mesh",
		drop = postfix_dropnames(definition.drop, "corner_smooth"),
		groups = tableutil.merge(definition.groups, { preserves_below_node = NodeGroup.DUMMY }),
		mesh = "corner.obj",
		name = corner_smooth_name,
		node_box = nodebox_cache.corners.corner,
		paramtype = "light",
		paramtype2 = "facedir",
		tiles = { textureutil.cube(definition.tiles) }
	})
	
	register_node(corner_smooth_definition)
	register_conversion("Corners", definition.name, corner_smooth_name)
end

local function register_plates(definition)
	for thickness = 1, 9, 1 do
		local plate_name = definition.name .. "_plate_" .. thickness
		local plate_definition = tableutil.merge(definition, {
			description = definition.description .. " (Plate, " .. thickness .. "/10)",
			drawtype = "mesh",
			drop = "core:" .. plate_name,
			groups = tableutil.merge(definition.groups, { preserves_below_node_when_wallmounted = NodeGroup.DUMMY }),
			mesh = "block_" .. thickness .. ".obj",
			name = plate_name,
			node_box = {
				type = "wallmounted",
				wall_bottom = {
					-0.5, -0.5, -0.5,
					0.5, thickness * 0.1 - 0.5, 0.5
				},
				wall_side = {
					-0.5, -0.5, -0.5,
					thickness * 0.1 - 0.5, 0.5, 0.5
				},
				wall_top = {
					-0.5, 0.5 - thickness * 0.1, -0.5,
					0.5, 0.5, 0.5
				}
			},
			paramtype = "light",
			paramtype2 = "wallmounted",
			tiles = { textureutil.cube(definition.tiles) }
		})
		
		register_node(plate_definition)
		
		register_conversion("Plates", definition.name, plate_name .. " " .. math.floor(10 / thickness))
	end
end

local function register_pyramids(definition)
	if nodebox_cache == nil then
		init_nodebox_cache()
	end
	
	local prototype = tableutil.merge(definition, {
		description = definition.description .. " (Pyramid)",
		drawtype = "mesh",
		drop = postfix_dropnames(definition.drop, "pyramid"),
		mesh = "pyramid.obj",
		name = definition.name .. "_pyramid",
		node_box = nodebox_cache.pyramids.smooth,
		paramtype = "light",
		paramtype2 = "facedir",
		tiles = { textureutil.cube(definition.tiles) },
		after_place_node = upsidedown_handler_default
	})
	
	local register_pyramid = function(name_postfix)
		name_postfix = name_postfix or ""
		
		local full_name = name_postfix
		if #full_name > 0 then
			full_name = name_postfix .. "_"
		end
		
		local full_definition = tableutil.merge(prototype, {
			description = definition.description .. " (" .. postfix_name("Pyramid", stringutil.trim(string.gsub(full_name, "_", " ")), " ") .. ")",
			drop = postfix_dropnames(prototype.drop, name_postfix),
			mesh = postfix_name("pyramid", name_postfix) .. ".obj",
			name = postfix_name(prototype.name, name_postfix),
			node_box = nodebox_cache.pyramids[postfix_name("smooth", name_postfix)]
		})
		
		register_node(full_definition)
		register_conversion("Pyramids", definition.name, full_definition.name)
		
		local halfheight_name = postfix_name("halfheight", name_postfix)
		
		local halfheight_definition = tableutil.merge(prototype, {
			description = definition.description .. " (" .. postfix_name("Pyramid", stringutil.trim(string.gsub(halfheight_name, "_", " ")), " ") .. ")",
			drop = postfix_dropnames(prototype.drop, halfheight_name),
			mesh = "pyramid_" .. halfheight_name .. ".obj",
			name = postfix_name(prototype.name, halfheight_name),
			node_box = nodebox_cache.pyramids_halfheight[postfix_name("smooth", name_postfix)]
		})
		
		register_node(halfheight_definition)
		register_conversion("Pyramids (half-height)", definition.name, halfheight_definition.name)
	end
	
	register_pyramid()
	register_pyramid("connected_corner")
	register_pyramid("connected_cross")
	register_pyramid("connected_end")
	register_pyramid("connected_straight")
	register_pyramid("connected_t")
end

local function register_pyramids_stepped(definition)
	if nodebox_cache == nil then
		init_nodebox_cache()
	end
	
	local pyramid_name = definition.name .. "_pyramid"
	
	local prototype = tableutil.merge(definition, {
		drawtype = "nodebox",
		drop = postfix_dropnames(definition.drop, "pyramid"),
		name = pyramid_name,
		paramtype = "light",
		paramtype2 = "facedir",
		after_place_node = upsidedown_handler_default
	})
	
	for counter = 2, 9, 1 do
		local register_pyramid = function(name_postfix)
			name_postfix = name_postfix or ""
			
			local full_name = name_postfix
			if #full_name > 0 then
				full_name = name_postfix .. "_"
			end
			
			local full_definition = tableutil.merge(prototype, {
				description = definition.description .. " (Pyramid " .. string.gsub(full_name, "_", " ") .. "with " .. counter .. " steps)",
				drop = postfix_dropnames(prototype.drop, full_name .. counter),
				name = pyramid_name .. "_" .. full_name .. counter,
				node_box = nodebox_cache.pyramids[postfix_name("stepped", name_postfix)][counter]
			})
			
			register_node(full_definition)
			register_conversion("Pyramids", definition.name, full_definition.name)
			
			local halfheight_name = postfix_name("halfheight", full_name)
			
			local halfheight_definition = tableutil.merge(prototype, {
				description = definition.description .. " (Pyramid " .. string.gsub(halfheight_name, "_", " ") .. "with " .. counter .. " steps)",
				drop = postfix_dropnames(prototype.drop, halfheight_name .. counter),
				name = pyramid_name .. "_" .. halfheight_name .. counter,
				node_box = nodeboxutil.set_height(full_definition.node_box, 0.5)
			})
			
			register_node(halfheight_definition)
			register_conversion("Pyramids (half-height)", definition.name, halfheight_definition.name)
		end
		
		register_pyramid()
		register_pyramid("connected_corner")
		register_pyramid("connected_cross")
		register_pyramid("connected_end")
		register_pyramid("connected_straight")
		register_pyramid("connected_t")
	end
end

local function register_ramps(definition)
	if nodebox_cache == nil then
		init_nodebox_cache()
	end
	
	-- Ramp
	local ramp_name = definition.name .. "_ramp"
	local ramp_definition = tableutil.merge(definition, {
		description = definition.description .. " (Ramp)",
		drawtype = "mesh",
		drop = postfix_dropnames(definition.drop, "ramp"),
		mesh = "ramp.obj",
		name = ramp_name,
		node_box = nodebox_cache.ramps.smooth,
		paramtype = "light",
		paramtype2 = "facedir",
		tiles = { textureutil.cube(definition.tiles) },
		after_place_node = upsidedown_handler_default
	})
	
	register_node(ramp_definition)
	register_conversion("Ramps", definition.name, ramp_name)
	
	-- Inner corner
	local ramp_inner_corner_name = definition.name .. "_ramp_inner_corner"
	local ramp_inner_corner_definition = tableutil.merge(ramp_definition, {
		description = definition.description .. " (Ramp inner corner)",
		drawtype = "mesh",
		drop = postfix_dropnames(definition.drop, "ramp_inner_corner"),
		mesh = "inner_corner_ramp.obj",
		name = ramp_inner_corner_name,
		node_box = nodebox_cache.ramps.smooth_inner,
		after_place_node = upsidedown_handler_mirrored
	})
	
	register_node(ramp_inner_corner_definition)
	register_conversion("Ramps", definition.name, ramp_inner_corner_name)
	
	-- Outer corner
	local ramp_outer_corner_name = definition.name .. "_ramp_outer_corner"
	local ramp_outer_corner_definition = tableutil.merge(ramp_definition, {
		description = definition.description .. " (Ramp outer corner)",
		drawtype = "mesh",
		drop = postfix_dropnames(definition.drop, "ramp_outer_corner"),
		mesh = "outer_corner_ramp.obj",
		name = ramp_outer_corner_name,
		node_box = nodebox_cache.ramps.smooth_outer,
		after_place_node = upsidedown_handler_mirrored
	})
	
	register_node(ramp_outer_corner_definition)
	register_conversion("Ramps", definition.name, ramp_outer_corner_name)
	
	-- Inner corner flat
	local ramp_inner_corner_flat_name = definition.name .. "_ramp_inner_corner_flat"
	local ramp_inner_corner_flat_definition = tableutil.merge(ramp_definition, {
		description = definition.description .. " (Ramp flat inner corner)",
		drawtype = "mesh",
		drop = postfix_dropnames(definition.drop, "ramp_inner_corner_flat"),
		mesh = "inner_corner_ramp_flat.obj",
		name = ramp_inner_corner_flat_name,
		node_box = nodebox_cache.ramps.smooth_inner_flat,
		after_place_node = upsidedown_handler_mirrored
	})
	
	register_node(ramp_inner_corner_flat_definition)
	register_conversion("Ramps", definition.name, ramp_inner_corner_flat_name)
	
	-- Outer corner flat
	local ramp_outer_corner_flat_name = definition.name .. "_ramp_outer_corner_flat"
	local ramp_outer_corner_flat_definition = tableutil.merge(ramp_definition, {
		description = definition.description .. " (Ramp flat outer corner)",
		drawtype = "mesh",
		drop = postfix_dropnames(definition.drop, "ramp_outer_corner_flat"),
		groups = tableutil.merge(definition.groups, { preserves_below_node = NodeGroup.DUMMY }),
		mesh = "outer_corner_ramp_flat.obj",
		name = ramp_outer_corner_flat_name,
		node_box = nodebox_cache.ramps.smooth_outer_flat,
		after_place_node = upsidedown_handler_mirrored
	})
	
	register_node(ramp_outer_corner_flat_definition)
	register_conversion("Ramps", definition.name, ramp_outer_corner_flat_name)
end

local function register_stairs(definition)
	if nodebox_cache.stairs == nil then
		init_nodebox_cache()
	end
	
	for counter = 2, 9, 1 do
		-- Stair
		local stair_name = definition.name .. "_stair_" .. counter
		local stair_definition = tableutil.merge(definition, {
			description = definition.description .. " (Stair with " .. counter .. " steps)",
			drawtype = "nodebox",
			drop = postfix_dropnames(definition.drop, "stair_" .. counter),
			name = stair_name,
			node_box = nodebox_cache.stairs.stepped[counter],
			paramtype = "light",
			paramtype2 = "facedir",
			after_place_node = upsidedown_handler_default
		})
		
		register_node(stair_definition)
		register_conversion("Stairs", definition.name, stair_name)
		
		-- Inner corner
		local inner_corner_name = definition.name .. "_stair_inner_corner_" .. counter
		local inner_corner_definition = tableutil.merge(stair_definition, {
			description = definition.description .. " (Stair inner corner with " .. counter .. " steps)",
			drop = postfix_dropnames(definition.drop, "stair_inner_corner_" .. counter),
			name = inner_corner_name,
			node_box = nodebox_cache.stairs.stepped_inner[counter],
			after_place_node = upsidedown_handler_default
		})
		
		register_node(inner_corner_definition)
		register_conversion("Stairs", definition.name, inner_corner_name)
		
		-- Inner corner flat
		local inner_corner_flat_name = definition.name .. "_stair_inner_corner_flat_" .. counter
		local inner_corner_flat_definition = tableutil.merge(stair_definition, {
			description = definition.description .. " (Stair flat inner corner with " .. counter .. " steps)",
			drop = postfix_dropnames(definition.drop, "stair_inner_corner_flat_" .. counter),
			name = inner_corner_flat_name,
			node_box = nodebox_cache.stairs.stepped_inner_flat[counter],
			after_place_node = upsidedown_handler_default
		})
		
		register_node(inner_corner_flat_definition)
		register_conversion("Stairs", definition.name, inner_corner_flat_name)
		
		-- Outer corner
		local outer_corner_name = definition.name .. "_stair_outer_corner_" .. counter
		local outer_corner_definition = tableutil.merge(stair_definition, {
			description = definition.description .. " (Stair outer corner with " .. counter .. " steps)",
			drop = postfix_dropnames(definition.drop, "stair_outer_corner_" .. counter),
			name = outer_corner_name,
			node_box = nodebox_cache.stairs.stepped_outer[counter],
			after_place_node = upsidedown_handler_default
		})
		
		register_node(outer_corner_definition)
		register_conversion("Stairs", definition.name, outer_corner_name)
		
		-- Outer corner flat
		local outer_corner_flat_name = definition.name .. "_stair_outer_corner_flat_" .. counter
		local outer_corner_flat_definition = tableutil.merge(stair_definition, {
			description = definition.description .. " (Stair flat outer corner with " .. counter .. " steps)",
			drop = postfix_dropnames(definition.drop, "stair_outer_corner_flat_" .. counter),
			groups = tableutil.merge(definition.groups, { preserves_below_node = NodeGroup.DUMMY }),
			name = outer_corner_flat_name,
			node_box = nodebox_cache.stairs.stepped_outer_flat[counter],
			after_place_node = upsidedown_handler_default
		})
		
		register_node(outer_corner_flat_definition)
		register_conversion("Stairs", definition.name, outer_corner_flat_name)
	end
end


local function register_bricks(definition)
	local name = postfix_name(definition.name, "bricks")
	
	local top = name .. "_top.png"
	local side = name .. ".png"
	
	ap.core.artisanry:register("Blocks", "core:" .. postfix_name(definition.name, "cobble"), {
		{ "core:" .. name }
	})
	
	definition = tableutil.merge(definition, {
		description = definition.description .. " Bricks",
		drop = {
			items = {
				{
					items = { "core:" .. name },
					tools = { "~hammer" }
				},
				{
					items = { "core:" .. postfix_name(definition.name, "rubble") },
					tools = { "~pickaxe" }
				}
			}
		},
		name = name,
		tiles = {
			top, top,
			side, side,
			side, side
		}
	})
	
	register_node(definition)
	
	register_corners(definition)
	register_plates(definition)
	register_pyramids(definition)
	register_pyramids_stepped(definition)
	register_ramps(definition)
	register_stairs(definition)
end

local function register_cobble(definition)
	local name = postfix_name(definition.name, "cobble")
	
	ap.core.artisanry:register("Blocks", "core:" .. postfix_name(definition.name, "rubble"), {
		{ "core:" .. name }
	})
	
	definition = tableutil.merge(definition, {
		description = definition.description .. " Cobble",
		drop = {
			items = {
				{
					items = { "core:" .. name },
					tools = { "~hammer" }
				},
				{
					items = { "core:" .. postfix_name(definition.name, "rubble") },
					tools = { "~pickaxe" }
				}
			}
		},
		name = name,
		tiles = {
			name .. ".png"
		}
	})
	
	register_node(definition)
	
	register_corners(definition)
	register_plates(definition)
	register_pyramids(definition)
	register_pyramids_stepped(definition)
	register_ramps(definition)
	register_stairs(definition)
end

local function register_rubble(definition)
	local rubble_name = postfix_name(definition.name, "rubble")
	
	definition = tableutil.merge(definition, {
		description = definition.description .. " Rubble",
		drop = "core:" .. rubble_name,
		name = rubble_name,
		tiles = {
			rubble_name .. ".png"
		}
	})
	
	register_node(definition)
	
	register_corners(definition)
	register_plates(definition)
	register_pyramids(definition)
	register_pyramids_stepped(definition)
	register_ramps(definition)
	register_stairs(definition)
end


ap.core.helpers.register_dirt = function(name, prototype)
	name = postfix_name(name, "dirt")
	
	local definition = {
		description = make_description(name),
		diggable = true,
		drop = "core:" .. name,
		groups = {
			dirt = DigSpeed.NORMAL,
			oddly_breakable_by_hand = 2
		},
		name = name,
		tiles = {
			name .. ".png"
		}
	}
	
	if prototype ~= nil then
		definition = tableutil.merge(definition, prototype)
	end
	
	register_node(definition)
	
	register_corners(definition)
	register_plates(definition)
	register_pyramids(definition)
	register_pyramids_stepped(definition)
	register_ramps(definition)
	register_stairs(definition)
end

ap.core.helpers.register_fluid = function(name, alpha, viscosity, type)
	if type == nil then
		ap.core.helpers.register_fluid(name, alpha, viscosity, "source")
		ap.core.helpers.register_fluid(name, alpha, viscosity, "flowing")
		return
	end
	
	local typed_name = name .. "_" .. type
	local texture = typed_name ..".png"
	local texture_animated = typed_name .. "_animated.png"
	
	local liquid_type = "liquid"
	if type == "flowing" then
		liquid_type = "flowingliquid"
	end
	
	local definition = {
		alpha = alpha,
		buildable_to = true,
		description = name .. " (" .. type .. ")",
		diggable = false,
		drawtype = liquid_type,
		drowning = 1,
		groups = {
			water = 3,
			liquid = 3
		},
		inventory_image = minetest.inventorycube(texture),
		liquidtype = type,
		liquid_alternative_flowing = "core:" .. name .. "_flowing",
		liquid_alternative_source = "core:" .. name .. "_source",
		liquid_viscosity = viscosity,
		name = typed_name,
		paramtype = "light",
		pointable = false,
		post_effect_color = {
			a = 64,
			r = 100,
			g = 100,
			b = 200
		},
		special_tiles = {
			{
				name = texture_animated,
				animation = {
					aspect_h = 32,
					aspect_w = 32,
					length = 3.0,
					type = "vertical_frames"
				},
				backface_culling = false
			}
		},
		tiles = {
			{
				name = texture_animated,
				animation = {
					aspect_h = 32,
					aspect_w = 32,
					length = 3.0,
					type = "vertical_frames"
				}
			}
		},
		walkable = false
	}
	
	register_node(definition)
end

ap.core.helpers.register_grass = function(name, group_addition, definition_override)
	name = postfix_name(name, "grass")
	
	local top_side = name .. ".png"
	local side_front = textureutil.tileable("dirt.png^" .. name .. "_front_overlay.png", true, false)
	local side_side = textureutil.tileable("dirt.png^" .. name .. "_side_overlay.png", true, false)
	
	local definition = {
		description = make_description(name),
		diggable = true,
		drop = "core:dirt",
		groups = {
			becomes_dirt = NodeGroup.DUMMY,
			dirt = DigSpeed.NORMAL,
			oddly_breakable_by_hand = 2,
			spread_minimum_light = 9,
			spreads_on_dirt = DigSpeed.NORMAL
		},
		name = name,
		tiles = {
			top_side, "dirt.png",
			side_front, side_front,
			side_side, side_side
		}
	}
	
	if group_addition ~= nil then
		definition.groups = tableutil.merge(definition.groups, group_addition)
	end
	
	if definition_override ~= nil then
		definition = tableutil.merge(definition, definition_override)
	end
	
	register_node(definition)
end

ap.core.helpers.register_gravel = function(name, prototype)
	name = postfix_name(name, "gravel")
	
	local definition = {
		description = make_description(name),
		diggable = true,
		drop = "core:" .. name,
		groups = {
			gravel = DigSpeed.NORMAL,
			oddly_breakable_by_hand = 2
		},
		name = name,
		tiles = {
			name .. ".png"
		}
	}
	
	if prototype ~= nil then
		definition = tableutil.merge(definition, prototype)
	end
	
	register_node(definition)
	
	register_corners(definition)
	register_plates(definition)
	register_pyramids(definition)
	register_ramps(definition)
end

ap.core.helpers.register_ice = function(name, prototype)
	name = postfix_name(name, "ice")
	
	local definition = {
		description = make_description(name),
		diggable = true,
		drop = {
			items = {
				{
					items = { "core:" .. name .. "_bricks" },
					tools = { "~hammer" }
				},
				{
					items = { "core:" .. name .. "_rubble" },
					tools = { "~pickaxe" }
				}
			}
		},
		groups = {
			ice = DigSpeed.NORMAL,
		},
		name = name,
		tiles = {
			name .. ".png"
		}
	}
	
	if prototype ~= nil then
		definition = tableutil.merge(definition, prototype)
	end
	
	register_node(definition)
	
	register_corners(definition)
	register_plates(definition)
	register_pyramids(definition)
	register_pyramids_stepped(definition)
	register_ramps(definition)
	register_stairs(definition)
	
	register_bricks(definition)
	register_cobble(definition)
	register_rubble(definition)
end

ap.core.helpers.register_rock = function(name, prototype)
	name = postfix_name(name, "rock")
	
	local definition = {
		description = make_description(name),
		diggable = true,
		drop = {
			items = {
				{
					items = { "core:" .. name .. "_bricks" },
					tools = { "~hammer" }
				},
				{
					items = { "core:" .. name .. "_rubble" },
					tools = { "~pickaxe" }
				}
			}
		},
		groups = {
			rock = DigSpeed.NORMAL,
		},
		name = name,
		tiles = {
			name .. ".png"
		}
	}
	
	definition = tableutil.merge(definition, prototype)
	
	register_node(definition)
	
	register_plates(definition)
	register_pyramids(definition)
	register_pyramids_stepped(definition)
	register_ramps(definition)
	register_stairs(definition)
	
	register_bricks(definition)
	register_cobble(definition)
	register_rubble(definition)
end

ap.core.helpers.register_sand = function(name, prototype)
	name = postfix_name(name, "sand")
	
	local definition = {
		description = make_description(name),
		diggable = true,
		drop = "core:" .. name,
		groups = {
			sand = DigSpeed.NORMAL,
			oddly_breakable_by_hand = 2
		},
		name = name,
		tiles = {
			name .. ".png"
		}
	}
	
	register_node(definition)
	
	register_corners(definition)
	register_ramps(definition)
	register_pyramids(definition)
end

ap.core.helpers.register_snow = function(name, prototype)
	name = postfix_name(name, "snow")
	
	local definition = {
		description = make_description(name),
		diggable = true,
		drop = "core:" .. name,
		groups = {
			snow = DigSpeed.NORMAL,
			oddly_breakable_by_hand = 2
		},
		name = name,
		tiles = {
			name .. ".png"
		}
	}
	
	definition = tableutil.merge(definition, prototype)
	
	register_node(definition)
	
	register_corners(definition)
	register_plates(definition)
	register_pyramids(definition)
	register_ramps(definition)
	register_stairs(definition)
end

ap.core.helpers.register_stone = function(name, prototype)
	name = postfix_name(name, "stone")
	
	local definition = {
		description = make_description(name),
		diggable = true,
		drop = "core:" .. name,
		groups = {
			stone = DigSpeed.NORMAL
		},
		name = name,
		tiles = {
			name .. ".png"
		}
	}
	
	definition = tableutil.merge(definition, prototype)
	
	register_node(definition)
	
	register_corners(definition)
	register_plates(definition)
	register_pyramids(definition)
	register_pyramids_stepped(definition)
	register_ramps(definition)
	register_stairs(definition)
end

ap.core.helpers.register_wood = function(name, prototype)
	local log_name = postfix_name(name, "log")
	local log_definition = {
		description = make_description(log_name),
		diggable = true,
		drop = "core:" .. log_name,
		groups = {
			simple_wallmounted = NodeGroup.DUMMY,
			wood = DigSpeed.NORMAL
		},
		name = log_name,
		paramtype2 = "facedir",
		tiles = {
			log_name .. "_top.png", log_name .. "_top.png",
			log_name .. ".png", log_name .. ".png",
			log_name .. ".png", log_name .. ".png"
		}
	}
	
	register_node(log_definition)
	
	-- Remove the simple wallmounted group to make sure that it does not
	-- interfere with the other definitions.
	log_definition = tableutil.clone(log_definition)
	log_definition.groups.simple_wallmounted = nil
	
	local planks_name = postfix_name(name, "planks")
	local planks_definition = {
		description = make_description(planks_name),
		diggable = true,
		drop = "core:" .. planks_name,
		groups = {
			wood = DigSpeed.NORMAL
		},
		name = planks_name,
		tiles = {
			planks_name .. ".png"
		}
	}
	
	register_node(planks_definition)
	
	ap.core.artisanry:register("Blocks", "core:" .. planks_name, {
		{ "core:" .. log_name }
	})
	
	register_corners(log_definition)
	register_plates(log_definition)
	register_ramps(log_definition)
	register_stairs(log_definition)
	
	register_corners(planks_definition)
	register_plates(planks_definition)
	register_pyramids(planks_definition)
	register_pyramids_stepped(planks_definition)
	register_ramps(planks_definition)
	register_stairs(planks_definition)
end

