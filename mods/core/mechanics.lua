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


local dirt = {
	name = "core:dirt"
}

local function grow_grass(pos, grass_node)
	for x = pos.x - 1, pos.x + 1, 1 do
		for z = pos.z - 1, pos.z + 1, 1 do
			local current_pos = {
				x = x,
				y = pos.y,
				z = z
			}
			
			local current_node = minetest.get_node(current_pos)
			
			if current_node.name == "core:dirt" then
				local node_above = minetest.get_node({
					x = x,
					y = pos.y + 1,
					z = z
				})
				
				if node_above.name == "air" then
					minetest.set_node(current_pos, grass_node)
					
					return true
				end
			end
		end
	end
	
	return false
end


-- The ABM that turns dirt into grass.
minetest.register_abm({
	chance = 20,
	interval = 30.0,
	neighbors = {
		"core:dirt",
		"air"
	},
	nodenames = {
		"group:grass"
	},
	action = function(pos, node, active_object_count, active_object_count_wider)
		-- Same height first.
		if grow_grass(pos, node) then
			return
		end
		
		-- Now we check below.
		local pos_below = {
			x = pos.x,
			y = pos.y - 1,
			z = pos.z
		}
		if grow_grass(pos_below, node) then
			return
		end
		
		-- New check above.
		local pos_above = {
			x = pos.x,
			y = pos.y + 1,
			z = pos.z
		}
		if grow_grass(pos_above, node) then
			return
		end
	end
})


-- Replace grass with dirt if a node is placed on it.
minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
	local pos_underneath = {
		x = pos.x,
		y = pos.y - 1,
		z = pos.z
	}
	
	local node = minetest.get_node(pos_underneath)
	
	-- TODO Testing the name isn't the best thing, maybe we can attach additional information to the node.
	-- TODO This removes the grass for everything, some nodes might not want to replace grass.
	if stringutil.endswith(node.name, "grass") then
		minetest.set_node(pos_underneath, dirt)
	end
end)

