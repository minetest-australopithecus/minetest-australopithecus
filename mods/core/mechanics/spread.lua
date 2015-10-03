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


--- Cached value of dirt.
local dirt = {
	name = "core:dirt"
}

--- Spreads the spreading_node around the given source_pos.
--
-- @param source_pos The source position.
-- @param spreading_node The node that should be spread.
-- @param minimum_light The minimum light required (inclusive).
-- @param maximum_light The maximum light required (inclusive).
-- @return true if the spreading_node was placed, false otherwise.
local function spread(source_pos, spreading_node, minimum_light, maximum_light)
	return nodeutil.surroundings(source_pos, -1, 1, -1, 1, 0, 0, function(pos, node)
		if node.name == dirt.name then
			local pos_above = {
				x = pos.x,
				y = pos.y + 1,
				z = pos.z
			}
			local node_above = minetest.get_node(pos_above)
			
			if node_above.name == "air" then
				local node_light = minetest.get_node_light(pos_above)
				
				if mathutil.in_range(node_light, minimum_light, maximum_light) then
					minetest.set_node(pos, spreading_node)
					return true
				end
			end
		end
	end)
end

--- Gets the required light levels for the given node.
--
-- @param node The node for which to get the light values.
-- @return The minimum and maximum light values.
local function get_light_values(node)
	-- Get the required light values.
	local minimum_light = minetest.get_item_group(node.name, "spread_minimum_light")
	local maximum_light = minetest.get_item_group(node.name, "spread_maximum_light")
	
	-- Minimum can happily stay at zero, however we need to fix the maximum
	-- value here.
	if maximum_light == 0 then
		maximum_light = 100
	end
	
	return minimum_light, maximum_light
end

--- The action function for the ABM.
--
-- @param pos The current position.
-- @param node The node at the current position
-- @param active_object_count The amount of active objects inside the node.
-- @param active_object_count_wider The amount of active objects inside
--                                  the node and its neighbours.
local function abm_action(pos, node, active_object_count, active_object_count_wider)
	local speed = minetest.get_node_group("spreads_on_dirt")
	local chance = 1
	
	if speed == DigSpeed.VERY_SLOW then
		chance = 8
	elseif speed == DigSpeed.SLOW then
		chance = 6
	elseif speed == DigSpeed.NORMAL then
		chance = 4
	elseif speed == DigSpeed.FAST then
		chance = 2
	end
	
	if chance ~= 1 and math.random(0, chance + 1) == chance then
		return
	end
	
	local minimum_light, maximum_light = get_light_values(node)
	
	-- Same height first.
	if spread(pos, node, minimum_light, maximum_light) then
		return
	end
	
	-- Now we check below.
	if spread(posutil.below(pos), node, minimum_light, maximum_light) then
		return
	end
	
	-- New check above.
	if spread(posutil.above(pos), node, minimum_light, maximum_light) then
		return
	end
end


-- Now register the ABM.
minetest.register_abm({
	chance = 32,
	interval = 10.0,
	neighbors = {
		dirt.name,
		"air"
	},
	nodenames = {
		"group:spreads_on_dirt"
	},
	action = abm_action
})

