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
	
	local skin_inventory = "list[detached:playerskins;" .. name .. ";10,8;1,1;]"
	
	local trash_inventory = "list[detached:trash;" .. name .. ";10,10;1,1;]"
	
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
		.. trash_inventory
		.. ring
	
	return formspec
end)



-- Get rid of the warnings.
minetest.register_alias("mapgen_stone", "core:rock");
minetest.register_alias("mapgen_water_source", "core:water_source");
minetest.register_alias("mapgen_river_water_source", "core:water_source");

