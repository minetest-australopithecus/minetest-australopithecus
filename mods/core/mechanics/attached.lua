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


local air = {
	name = "air"
}

-- Drop nodes that are attached to the dug node.
minetest.register_on_dignode(function(pos, oldnode, digger)
	local tool = digger:get_wielded_item()
	if tool ~= nil then
		tool = tool:get_name()
	end
	
	nodeutil.surroundings(pos, -1, 1, -1, 1, -1, 1, function(spos, node)
		local attached_to_vector = nil
		
		if nodeutil.has_group(node, "attached_to_facedir") then
			attached_to_vector = facedirutil.get_vector(node.param2)
		elseif nodeutil.has_group(node, "attached_to_wallmounted") then
			attached_to_vector = wallmountedutil.get_vector(node.param2)
		end
		
		if attached_to_vector ~= nil then
			if vector.equals(pos, vector.add(spos, attached_to_vector)) then
				local dropped_items = minetest.get_node_drops(node.name, tool)
				
				for index, dropped_item in ipairs(dropped_items) do
					local dropped_node = minetest.add_item(spos, dropped_item)
				end
				
				minetest.set_node(spos, air)
			end
		end
	end)
end)


