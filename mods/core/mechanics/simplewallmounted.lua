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



-- Corrects the orientation of the nodes withe group "simple_wallmounted".
minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
	if nodeutil.has_group(newnode, "simple_wallmounted") then
		local direction = vector.direction(pointed_thing.under, pointed_thing.above)
		
		if direction.x == 1 then
			newnode.param2 = rotationutil.facedir(rotationutil.POS_X, rotationutil.ROT_90)
		elseif direction.x == -1 then
			newnode.param2 = rotationutil.facedir(rotationutil.NEG_X, rotationutil.ROT_90)
		elseif direction.z == 1 then
			newnode.param2 = rotationutil.facedir(rotationutil.POS_Z, rotationutil.ROT_90)
		elseif direction.z == -1 then
			newnode.param2 = rotationutil.facedir(rotationutil.NEG_Z, rotationutil.ROT_90)
		elseif direction.y == 1 then
			-- Reset the rotation.
			newnode.param2 = nil
		elseif direction.y == -1 then
			newnode.param2 = rotationutil.facedir(rotationutil.NEG_Y, rotationutil.ROT_180)
		end
		
		minetest.set_node(pos, newnode)
	end
end)

