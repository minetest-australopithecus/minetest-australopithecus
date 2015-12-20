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


playerskins = {
	inventory = nil,
	skins = List:new()
}


function playerskins.activate()
	playerskins.create_inventory()
	
	minetest.register_on_dieplayer(playerskins.drop_clothes)
	minetest.register_on_joinplayer(playerskins.setup_inventories)
end

function playerskins.create_inventory()
	playerskins.inventory = minetest.create_detached_inventory("playerskins", {
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
			playerskins.set_skin(player, stack:get_name())
			player:get_inventory():set_stack("skin", index, stack)
		end,
		
		on_take = function(inventory, listname, index, stack, player)
			playermodel.set_player_model(player, nil, "character.png", nil)
			player:get_inventory():remove_item("skin", stack)
		end
	})
end

function playerskins.drop_clothes(player)
	if deathinventorydrop.active then
		deathinventorydrop.drop_inventory(player, player:get_inventory(), "skin")
		playerskins.inventory:set_stack(player:get_player_name(), 1, ItemStack(""))
		playerskins.set_skin(player, nil)
	end
end

function playerskins.set_skin(player, item_name)
	if item_name == nil or #item_name == 0 then
		playermodel.set_player_model(player, nil, { "character.png" }, nil)
	end
	
	playerskins.skins:foreach(function(skin, index)
		if skin.item_name == item_name then
			playermodel.set_player_model(player, nil, { skin.texture }, nil)
			return true
		end
	end)
end

function playerskins.setup_inventories(player)
	local name = player:get_player_name()
	local inventory = player:get_inventory()
	
	if inventory:get_size("skin") == 0 then
		inventory:set_size("skin", 1)
	end
	
	playerskins.inventory:set_size(name, 1)
	playerskins.inventory:set_stack(name, 1, inventory:get_stack("skin", 1))
	
	playerskins.set_skin(player, playerskins.inventory:get_stack(name, 1):get_name())
end

