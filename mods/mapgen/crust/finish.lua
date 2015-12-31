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


-- We will fill everything with air that is still filled with "ignore".
-- That removes odd lighting glitches that I've been seeing.
ap.mapgen.crust:register("air", function(constructor)
	constructor:require_node("air", "air")
	
	constructor:set_run_3d(function(module, metadata, manipulator, x, z, y)
		if manipulator:get_node(x, z, y) == 126 then
			manipulator:set_node(x, z, y, module.nodes.air)
		end
	end)
end)

