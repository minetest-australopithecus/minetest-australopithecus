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


local torch_box = {
	type = "fixed",
	fixed = {
		-0.07, -0.5, -0.07,
		0.07, 0.35, 0.07
	}
}

local wallmounted_torch_box = {
	type = "fixed",
	fixed = {}
}

for count = 1, 9, 1 do
	local step = 0.85 / 9
	local y_step = step * (count - 1)
	local z_step = step * (count - 1) / 2
	
	table.insert(wallmounted_torch_box.fixed, {
		-0.07, -0.5 + y_step, 0.65 - z_step,
		0.07, -0.5 + y_step + step, 0.65 - z_step - step
	})
end

local torch_prototype = {
	diggable = true,
	drawtype = "mesh",
	light_source = 11,
	paramtype = "light",
	stack_max = 64,
	tiles = {
		{
			name = "torch_on.png",
			animation = {
				aspect_h = 32,
				aspect_w = 32,
				length = 7.0,
				type = "vertical_frames"
			}
		}
	}
}

local torch_burning_definition = tableutil.merge(torch_prototype, {
	collision_box = torch_box,
	description = "A burning torch.",
	drop = "torch:torch_burning",
	groups = {
		attached_to_wallmounted = DigSpeed.DUMMY,
		building = DigSpeed.VERY_FAST,
		oddly_breakable_by_hand = DigSpeed.VERY_FAST,
		preserves_below_node = DigSpeed.DUMMY,
	},
	mesh = "torch.obj",
	node_box = torch_box,
	name = "torch_burning",
	paramtype2 = "wallmounted",
	selection_box = torch_box,
	walkable = false,
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		local placed_torch = minetest.get_node(pos)
		
		if placed_torch.param2 == 0 then
			-- We don't allow to place torches on the ceiling.
			minetest.set_node(pos, {
				name = "air"
			})
			return true
		elseif placed_torch.param2 == 1 then
			-- All cool, nothing to do.
		else
			-- The torch has been attached to a wall.
			local attached_to_pos = vector.add(pos, wallmountedutil.get_vector(placed_torch.param2))
			local attached_to_node = minetest.get_node(attached_to_pos)
			
			if nodeutil.is_walkable(attached_to_node) then
				minetest.set_node(pos, {
					name = placed_torch.name .. "_wall",
					param1 = placed_torch.param1,
					param2 = wallmountedutil.to_facedir(placed_torch.param2)
				})
			else
				-- Disallow attaching the torch to a not walkable node.
				minetest.set_node(pos, {
					name = "air"
				})
				return true
			end
		end
	end,
	on_punch = function(pos, node, puncher, pointed_thing)
		minetest.set_node(pos, {
			name = "torch:torch",
			param1 = node.param1,
			param2 = node.param2
		})
	end
})
minetest.register_node("torch:torch_burning", tableutil.clone(torch_burning_definition))

local torch_definition = tableutil.merge(torch_burning_definition, {
	description = "A torch.",
	drop = "torch:torch",
	light_source = 0,
	name = "torch",
	tiles = {
		"torch_off.png"
	},
	on_punch = function(pos, node, puncher, pointed_thing)
		-- TODO This should only work with a lighter or something.
		minetest.set_node(pos, {
			name = "torch:torch_burning",
			param1 = node.param1,
			param2 = node.param2
		})
	end
})
minetest.register_node("torch:torch", tableutil.clone(torch_definition))

local torch_wall_prototype = tableutil.merge(torch_prototype, {
	collision_box = wallmounted_torch_box,
	groups = {
		attached_to_facedir = DigSpeed.DUMMY,
		building = DigSpeed.VERY_FAST,
		oddly_breakable_by_hand = DigSpeed.VERY_FAST,
		preserves_below_node = DigSpeed.DUMMY,
	},
	mesh = "torch_wall.obj",
	node_box = wallmounted_torch_box,
	paramtype2 = "facedir",
	selection_box = wallmounted_torch_box
})

local torch_burning_wall_definition = tableutil.merge(torch_burning_definition, torch_wall_prototype, {
	description = "A burning torch (mounted on a wall).",
	drop = "torch:torch_burning",
	name = "torch_burning_wall",
	after_place_node = nil,
	on_punch = function(pos, node, puncher, pointed_thing)
		minetest.set_node(pos, {
			name = "torch:torch_wall",
			param1 = node.param1,
			param2 = node.param2
		})
	end
})
minetest.register_node("torch:torch_burning_wall", tableutil.clone(torch_burning_wall_definition))

local torch_wall_definition = tableutil.merge(torch_definition, torch_wall_prototype, {
	description = "A torch (mounted on a wall).",
	drop = "torch:torch",
	light_source = 0,
	name = "torch_wall",
	tiles = {
		"torch_off.png"
	},
	on_punch = function(pos, node, puncher, pointed_thing)
		-- TODO This should only work with a lighter or something.
		minetest.set_node(pos, {
			name = "torch:torch_burning_wall",
			param1 = node.param1,
			param2 = node.param2
		})
	end
})
minetest.register_node("torch:torch_wall", tableutil.clone(torch_wall_definition))

