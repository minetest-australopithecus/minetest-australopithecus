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


local dirt = {
	name = "core:dirt"
}

-- Replace grass with dirt if a node is placed on it.
minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
	if nodeutil.has_group(newnode, "preserves_below_node")
		or not nodeutil.is_walkable(newnode) then
		
		-- If the node that is placed has either the needed group or is not
		-- walkable, it should not remove the topping.
		return
	end
	
	local pos_underneath = {
		x = pos.x,
		y = pos.y - 1,
		z = pos.z
	}
	
	local node = minetest.get_node(pos_underneath)
	
	if nodeutil.has_group(node, "becomes_dirt") then
		minetest.set_node(pos_underneath, dirt)
	end
end)

