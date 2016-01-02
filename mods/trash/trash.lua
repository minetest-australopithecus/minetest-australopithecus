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


trash = {
	inventory = nil
}


function trash.activate()
	trash.create_inventory()
	
	minetest.register_on_joinplayer(trash.setup_inventories)
end

function trash.create_inventory()
	trash.inventory = minetest.create_detached_inventory("trash", {
		allow_move = function(inventory, from_list, from_index, to_list, to_index, count, player)
			return count
		end,
		
		allow_put = function(inventory, listname, index, stack, player)
			return stack:get_count()
		end,
		
		allow_take = function(inventory, listname, index, stack, player)
			return stack:get_count()
		end,
		
		on_move = function(inventory, from_list, from_index, to_list, to_index, count, player)
			-- Not needed.
		end,
		
		on_put = function(inventory, listname, index, stack, player)
			inventory:set_stack(listname, index, nil)
		end,
		
		on_take = function(inventory, listname, index, stack, player)
			-- Not needed.
		end
	})
end

function trash.setup_inventories(player)
	local name = player:get_player_name()
	
	trash.inventory:set_size(name, 1)
end

