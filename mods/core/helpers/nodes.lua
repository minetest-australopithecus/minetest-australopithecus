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


local nodebox_cache = {}

local function postfix_name(name, postfix)
	if name == nil or name == "" then
		return postfix
	else
		return name .. "_" .. postfix
	end
end

local function register_conversion(source, target)
	ap.core.artisanry:register("core:" .. target, {
		{ "core:" .. source }
	})
	ap.core.artisanry:register("core:" .. source, {
		{ "core:" .. target }
	})
end

local function register_ramps(name, definition)
	if nodebox_cache.ramps == nil then
		nodebox_cache.ramps = {}
		nodebox_cache.ramps.stepped = {}
		nodebox_cache.ramps.stepped_inner = {}
		nodebox_cache.ramps.stepped_outer = {}
		nodebox_cache.ramps.steep = {}
		nodebox_cache.ramps.steep_inner = {}
		nodebox_cache.ramps.steep_outer = {}
		
		for counter = 2, 9, 1 do
			nodebox_cache.ramps.stepped[counter] = {
				type = "fixed",
				fixed = ramputil.create_ramp_nodebox(counter)
			}
			nodebox_cache.ramps.stepped_inner[counter] = {
				type = "fixed",
				fixed = ramputil.create_inner_corner_nodebox(counter)
			}
			nodebox_cache.ramps.stepped_outer[counter] = {
				type = "fixed",
				fixed = ramputil.create_outer_corner_nodebox(counter)
			}
			
			nodebox_cache.ramps.steep[counter] = {
				type = "fixed",
				fixed = ramputil.create_steep_ramp_nodebox(counter)
			}
			
			nodebox_cache.ramps.steep_inner[counter] = {
				type = "fixed",
				fixed = ramputil.create_inner_steep_corner_nodebox(counter)
			}
			
			nodebox_cache.ramps.steep_outer[counter] = {
				type = "fixed",
				fixed = ramputil.create_outer_steep_corner_nodebox(counter)
			}
		end
		
		nodebox_cache.ramps.smooth = nodebox_cache.ramps.stepped[9]
		nodebox_cache.ramps.smooth_inner = nodebox_cache.ramps.stepped_inner[9]
		nodebox_cache.ramps.smooth_outer = nodebox_cache.ramps.stepped_outer[9]
		
		nodebox_cache.ramps.steep_smooth = nodebox_cache.ramps.steep[9]
		nodebox_cache.ramps.steep_smooth_inner = nodebox_cache.ramps.steep_inner[9]
		nodebox_cache.ramps.steep_smooth_outer = nodebox_cache.ramps.steep_outer[9]
	end
	
	local ramp_definition = nil
	
	for counter = 2, 9, 1 do
		-- Ramp
		local ramp_name = name .. "_ramp_" .. counter
		ramp_definition = tableutil.merge(definition, {
			collision_box = nodebox_cache.ramps.stepped[counter],
			description = definition.description .. " (Ramp with " .. counter .. " steps)",
			drawtype = "nodebox",
			drop = "core:" .. ramp_name,
			name = ramp_name,
			node_box = nodebox_cache.ramps.stepped[counter],
			paramtype = "light",
			paramtype2 = "facedir"
		})
		
		minetest.register_node("core:" .. ramp_name, ramp_definition)
		register_conversion(name, ramp_name)
		
		-- Inner corner
		local inner_corner_name = name .. "_inner_corner_" .. counter
		local inner_corner_definition = tableutil.merge(ramp_definition, {
			collision_box = nodebox_cache.ramps.stepped_inner[counter],
			description = definition.description .. " (Inner corner with " .. counter .. " steps)",
			drop = "core:" .. inner_corner_name,
			name = inner_corner_name,
			node_box = nodebox_cache.ramps.stepped_inner[counter]
		})
		
		minetest.register_node("core:" .. inner_corner_name, inner_corner_definition)
		register_conversion(name, inner_corner_name)
		
		-- Outer corner
		local outer_corner_name = name .. "_outer_corner_" .. counter
		local outer_corner_definition = tableutil.merge(ramp_definition, {
			collision_box = nodebox_cache.ramps.stepped_outer[counter],
			description = definition.description .. " (Outer corner with " .. counter .. " steps)",
			drop = "core:" .. outer_corner_name,
			name = outer_corner_name,
			node_box = nodebox_cache.ramps.stepped_outer[counter]
		})
		
		minetest.register_node("core:" .. outer_corner_name, outer_corner_definition)
		register_conversion(name, outer_corner_name)
		
		-- Steep ramp
		local steep_ramp_name = name .. "_steep_ramp_" .. counter
		local steep_ramp_definition = tableutil.merge(ramp_definition, {
			collision_box = nodebox_cache.ramps.steep[counter],
			description = definition.description .. " (Steep ramp with " .. counter .. " steps)",
			drop = "core:" .. steep_ramp_name,
			name = steep_ramp_name,
			node_box = nodebox_cache.ramps.steep[counter],
		})
		
		minetest.register_node("core:" .. steep_ramp_name, steep_ramp_definition)
		register_conversion(name, steep_ramp_name)
		
		-- Inner steep corner
		local inner_steep_corner_name = name .. "_inner_steep_corner_" .. counter
		local inner_steep_corner_definition = tableutil.merge(ramp_definition, {
			collision_box = nodebox_cache.ramps.steep_inner[counter],
			description = definition.description .. " (Steep inner corner with " .. counter .. " steps)",
			drop = "core:" .. inner_steep_corner_name,
			name = inner_steep_corner_name,
			node_box = nodebox_cache.ramps.steep_inner[counter],
		})
		
		minetest.register_node("core:" .. inner_steep_corner_name, inner_steep_corner_definition)
		register_conversion(name, inner_steep_corner_name)
		
		-- Outer steep corner
		local outer_steep_corner_name = name .. "_outer_steep_corner_" .. counter
		local outer_steep_corner_definition = tableutil.merge(ramp_definition, {
			collision_box = nodebox_cache.ramps.steep_outer[counter],
			description = definition.description .. " (Steep outer corner with " .. counter .. " steps)",
			drop = "core:" .. outer_steep_corner_name,
			name = outer_steep_corner_name,
			node_box = nodebox_cache.ramps.steep_outer[counter],
		})
		
		minetest.register_node("core:" .. outer_steep_corner_name, outer_steep_corner_definition)
		register_conversion(name, outer_steep_corner_name)
	end
	
	-- Smooth ramp
	local smooth_ramp_name = name .. "_smooth_ramp"
	local smooth_ramp_definition = tableutil.merge(ramp_definition, {
		collision_box = nodebox_cache.ramps.smooth,
		description = definition.description .. " (Smooth ramp)",
		drawtype = "mesh",
		mesh = "ramp.obj",
		name = smooth_ramp_name,
		node_box = nodebox_cache.ramps.smooth
	})
	
	minetest.register_node("core:" .. smooth_ramp_name, smooth_ramp_definition)
	register_conversion(name, smooth_ramp_name)
	
	-- Smooth inner corner
	local smooth_inner_corner_name = name .. "_smooth_inner_corner"
	local smooth_inner_corner_definition = tableutil.merge(ramp_definition, {
		collision_box = nodebox_cache.ramps.smooth_inner,
		description = definition.description .. " (Smooth inner corner)",
		drawtype = "mesh",
		mesh = "inner_corner.obj",
		name = smooth_inner_corner_name,
		node_box = nodebox_cache.ramps.smooth_inner
	})
	
	minetest.register_node("core:" .. smooth_inner_corner_name, smooth_inner_corner_definition)
	register_conversion(name, smooth_inner_corner_name)
	
	-- Smooth outer corner
	local smooth_outer_corner_name = name .. "_smooth_outer_corner"
	local smooth_outer_corner_definition = tableutil.merge(ramp_definition, {
		collision_box = nodebox_cache.ramps.smooth_outer,
		description = definition.description .. " (Smooth outer corner)",
		drawtype = "mesh",
		mesh = "outer_corner.obj",
		name = smooth_outer_corner_name,
		node_box = nodebox_cache.ramps.smooth_outer
	})
	
	minetest.register_node("core:" .. smooth_outer_corner_name, smooth_outer_corner_definition)
	register_conversion(name, smooth_outer_corner_name)
	
	-- Steep smooth ramp
	local steep_smooth_ramp_name = name .. "_steep_smooth_ramp"
	local steep_smooth_ramp_definition = tableutil.merge(ramp_definition, {
		collision_box = nodebox_cache.ramps.steep_smooth,
		description = definition.description .. " (Steep smooth ramp)",
		drawtype = "mesh",
		mesh = "steep_ramp.obj",
		name = steep_smooth_ramp_name,
		node_box = nodebox_cache.ramps.steep_smooth
	})
	
	minetest.register_node("core:" .. steep_smooth_ramp_name, steep_smooth_ramp_definition)
	register_conversion(name, steep_smooth_ramp_name)
end

local function register_cobble(name, definition)
	local cobble_name = postfix_name(name, "cobble")
	
	definition = tableutil.merge(definition, {
		description = definition.description .. " Cobble",
		drop = "core:" .. cobble_name,
		name = cobble_name,
		tiles = {
			cobble_name .. ".png"
		}
	})
	
	minetest.register_node("core:" .. cobble_name, definition)
	
	register_ramps(cobble_name, definition)
end


ap.core.helpers.register_dirt = function(name, prototype)
	name = postfix_name(name, "dirt")
	
	local definition = {
		diggable = true,
		drop = "core:" .. name,
		groups = {
			crumbly = 2,
			soil = 1,
			oddly_breakable_by_hand = 1
		},
		tiles = {
			name .. ".png"
		}
	}
	
	if prototype ~= nil then
		definition = tableutil.merge(definition, prototype)
	end
	
	minetest.register_node("core:" .. name, definition)
	
	register_ramps(name, definition)
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
	
	minetest.register_node("core:" .. typed_name, definition)
end

ap.core.helpers.register_grass = function(name, crumbly)
	name = postfix_name(name, "grass")
	
	local top_side = name .. ".png"
	local side_side = "dirt.png^" .. name .. "_side_overlay.png"
	
	local node = {
		buildable_to = false,
		description = name,
		diggable = true,
		drop = "core:dirt",
		groups = {
			crumbly = crumbly or 3,
			soil = 1,
			oddly_breakable_by_hand = 1
		},
		name = name,
		tiles = {
			top_side, "dirt.png",
			side_side, side_side,
			side_side, side_side
		}
	}
	
	minetest.register_node("core:" .. name, node)
end

ap.core.helpers.register_ice = function(name, prototype)
	name = postfix_name(name, "ice")
	
	local definition = {
		diggable = true,
		drop = "core:" .. name,
		groups = {
			cracky = 2,
		},
		name = name,
		tiles = {
			name .. ".png"
		}
	}
	
	if prototype ~= nil then
		definition = tableutil.merge(definition, prototype)
	end
	
	minetest.register_node("core:" .. name, definition)
	
	register_ramps(name, definition)
end

ap.core.helpers.register_rock = function(name, prototype)
	name = postfix_name(name, "rock")
	
	local definition = {
		description = "Rock",
		diggable = true,
		drop = "core:" .. name .. "_cobble",
		groups = {
			cracky = 1
		},
		name = name,
		tiles = {
			name .. ".png"
		}
	}
	
	definition = tableutil.merge(definition, prototype)
	
	minetest.register_node("core:" .. name, definition)
	
	register_ramps(name, definition)
	register_cobble(name, definition)
end

ap.core.helpers.register_snow = function(name, prototype)
	name = postfix_name(name, "snow")
	
	local definition = {
		description = "Snow",
		diggable = true,
		groups = {
			crumbly = 3,
			oddly_breakable_by_hand = 1
		},
		name = name,
		tiles = {
			name .. ".png"
		}
	}
	
	minetest.register_node("core:" .. name, definition)
	
	register_cobble(name, definition)
	register_ramps(name, definition)
end

