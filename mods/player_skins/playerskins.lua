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


playerskins = {
	inventory = nil,
	skins = List:new()
}


function playerskins.activate()
	playerskins.create_inventory()
	
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

function playerskins.set_skin(player, item_name)
	if item_name == nil or #item_name == 0 then
		return
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

