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


minetest.register_tool("core:iron_axe", {
	description = "A mighty axe.",
	inventory_image = "iron_axe.png",
	range = 5.0,
	tool_capabilities = {
		full_punch_interval = 1.0,
		groupcaps = {
			wood = { times =  { 0.5, 0.5, 0.5, 0.5, 0.5 }, uses = 0, maxlevel = 9000 }
		},
		max_drop_level = 9000
	}
})
minetest.register_tool("core:iron_hammer", {
	description = "A mighty hammer.",
	inventory_image = "iron_hammer.png",
	range = 5.0,
	tool_capabilities = {
		full_punch_interval = 1.0,
		groupcaps = {
			building = { times =  { 0.5, 0.5, 0.5, 0.5, 0.5 }, uses = 0, maxlevel = 9000 },
			ice = { times =  { 0.5, 0.5, 0.5, 0.5, 0.5 }, uses = 0, maxlevel = 9000 },
			rock = { times =  { 0.5, 0.5, 0.5, 0.5, 0.5 }, uses = 0, maxlevel = 9000 },
			stone = { times =  { 0.5, 0.5, 0.5, 0.5, 0.5 }, uses = 0, maxlevel = 9000 }
		},
		max_drop_level = 9000
	}
})
minetest.register_tool("core:iron_pickaxe", {
	description = "A mighty pickaxe.",
	inventory_image = "iron_pickaxe.png",
	range = 5.0,
	tool_capabilities = {
		full_punch_interval = 1.0,
		groupcaps = {
			dirt = { times =  { 0.5, 0.5, 0.5, 0.5, 0.5 }, uses = 0, maxlevel = 9000 },
			ice = { times =  { 0.5, 0.5, 0.5, 0.5, 0.5 }, uses = 0, maxlevel = 9000 },
			gravel = { times =  { 0.5, 0.5, 0.5, 0.5, 0.5 }, uses = 0, maxlevel = 9000 },
			rock = { times =  { 0.5, 0.5, 0.5, 0.5, 0.5 }, uses = 0, maxlevel = 9000 },
			snow = { times =  { 0.5, 0.5, 0.5, 0.5, 0.5 }, uses = 0, maxlevel = 9000 },
			stone = { times =  { 0.5, 0.5, 0.5, 0.5, 0.5 }, uses = 0, maxlevel = 9000 }
		},
		max_drop_level = 9000
	}
})
minetest.register_tool("core:iron_shovel", {
	description = "A mighty shovel.",
	inventory_image = "iron_shovel.png",
	range = 5.0,
	tool_capabilities = {
		full_punch_interval = 1.0,
		groupcaps = {
			dirt = { times =  { 0.5, 0.5, 0.5, 0.5, 0.5 }, uses = 0, maxlevel = 9000 },
			gravel = { times =  { 0.5, 0.5, 0.5, 0.5, 0.5 }, uses = 0, maxlevel = 9000 },
			sand = { times =  { 0.5, 0.5, 0.5, 0.5, 0.5 }, uses = 0, maxlevel = 9000 },
			snow = { times =  { 0.5, 0.5, 0.5, 0.5, 0.5 }, uses = 0, maxlevel = 9000 }
		},
		max_drop_level = 9000
	}
})

minetest.register_on_joinplayer(function(player)
	player:get_inventory():set_stack("main", 1, ItemStack("core:iron_pickaxe"))
	player:get_inventory():set_stack("main", 2, ItemStack("core:iron_shovel"))
	player:get_inventory():set_stack("main", 3, ItemStack("core:iron_axe"))
	player:get_inventory():set_stack("main", 4, ItemStack("core:iron_hammer"))
	player:get_inventory():set_stack("main", 5, ItemStack("torch:torch_burning 64"))
end)

minetest.register_chatcommand("get-torches", {
	description = "Gets you some torches.",
	params = "",
	func = function(name, params)
		local player = minetest.get_player_by_name(name)
		player:get_inventory():set_stack("main", 2, ItemStack("torch:torch_burning 64"))
		
		return true, "Done"
	end
})

