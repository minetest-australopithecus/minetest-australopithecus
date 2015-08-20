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
	drawtype  = "mesh",
	drop = "torch:torch",
	groups = {
		oddly_breakable_by_hand = 1,
		preserves_grass = 1,
		simple_building = 1
	},
	light_source = 11,
	paramtype = "light",
	paramtype2 = "facedir",
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

local torch_definition = tableutil.merge(torch_prototype, {
	collision_box = torch_box,
	description = "A burning torch.",
	drawtype  = "mesh",
	node_box = torch_box,
	name = "torch_burning",
	paramtype2 = "wallmounted",
	selection_box = torch_box,
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
	},
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
			minetest.set_node(pos, {
				name = placed_torch.name .. "_wall",
				param1 = placed_torch.param1,
				param2 = nodeutil.wallmounted_to_facedir(placed_torch.param2)
			})
		end
	end
})

minetest.register_node("torch:torch", {
	collision_box = torch_box,
	description = "A torch.",
	diggable = true,
	drawtype  = "mesh",
	drops = "torch:torch",
	groups = {
		oddly_breakable_by_hand = 1,
		preserves_grass = 1,
		simple_building = 1
	},
	light_source = 11,
	mesh = "torch.obj",
	name = "torch",
	node_box = torch_box,
	paramtype = "light",
	paramtype2 = "wallmounted",
	selection_box = torch_box,
	tiles = {
		name = "torch_off.png"
	},
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
			minetest.set_node(pos, {
				name = "torch:torch_wall",
				param1 = placed_torch.param1,
				param2 = nodeutil.wallmounted_to_facedir(placed_torch.param2)
			})
		end
	end
})

minetest.register_node("torch:torch_wall", {
	collision_box = wallmounted_torch_box,
	description = "A torch (nounted on a wall).",
	diggable = true,
	drawtype  = "mesh",
	drop = "torch:torch",
	groups = {
		oddly_breakable_by_hand = 1,
		preserves_grass = 1,
		simple_building = 1
	},
	light_source = 11,
	mesh = "torch_wall.obj",
	name = "torch_wall",
	node_box = wallmounted_torch_box,
	paramtype = "light",
	paramtype2 = "facedir",
	selection_box = wallmounted_torch_box,
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
})

