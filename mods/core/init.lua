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


-- Main setup
australopithecus = {}
ap = australopithecus

-- Main module
ap.core = {}

ap.core.artisanry = Artisanry:new()



-- Load all files
local base_path = minetest.get_modpath(minetest.get_current_modname())

-- Helpers first
dofile(base_path .. "/helpers/helpers.lua")
dofile(base_path .. "/helpers/nodes.lua")

-- Main files
dofile(base_path .. "/debug.lua")
dofile(base_path .. "/nodes.lua")
dofile(base_path .. "/setup.lua")

-- Mechanics.
dofile(base_path .. "/mechanics/attached.lua")
dofile(base_path .. "/mechanics/removetopping.lua")
dofile(base_path .. "/mechanics/spread.lua")



-- Activate Artisanry
artisanryui.activate(ap.core.artisanry, function(player, groups)
	local name = player:get_player_name()
	
	local window = "size[15,13;]"
	
	local input ="list[detached:artisanryui;" .. name .. "-input;1,2;5,5;]"
	local output = "list[detached:artisanryui;" .. name .. "-output;7,2;7,5;]"
	
	local groups_string = ""
	groups:foreach(function(group, index)
		groups_string = groups_string .. "," .. group
	end)
	
	local groups_list = "dropdown[7,1;4,1;artisanryui-group;All,None" .. groups_string .. ";1]"
	
	local previous_button = "button[12,1;1,1;artisanryui-previous-page;<<]"
	local next_button = "button[13,1;1,1;artisanryui-next-page;>>]"
	
	local inventory = "list[current_player;main;1,8;8,3;8]"
	local hotbar = "list[current_player;main;1,11;8,1;0]"
	
	local skin_inventory = "list[detached:playerskins;" .. name .. ";9,8;1,1;]"
	
	local ring = "listring[current_player;main]"
	ring = ring .. "listring[detached:artisanryui;" .. name .. "-input]"
	ring = ring .. "listring[current_player;main]"
	ring = ring .. "listring[detached:artisanryui;" .. name .. "-output]"
	ring = ring .. "listring[current_player;main]"
	
	local formspec = window
		.. input
		.. output
		.. groups_list
		.. previous_button
		.. next_button
		.. inventory
		.. hotbar
		.. skin_inventory
		.. ring
	
	return formspec
end)



-- Get rid of the warnings.
minetest.register_alias("mapgen_stone", "core:rock");
minetest.register_alias("mapgen_water_source", "core:water_source");
minetest.register_alias("mapgen_river_water_source", "core:water_source");

