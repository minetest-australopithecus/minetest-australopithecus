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


local function create_dig_group(dig_time)
	return {
		maxlevel = 1,
		times = {
			dig_time * 2,
			dig_time * 1.5,
			dig_time,
			dig_time  / 2,
			dig_time / 4
		},
		uses = 0
	}
end

minetest.register_tool("core:debug_axe", {
	description = "A mighty debug axe.",
	inventory_image = "iron_axe.png",
	range = 5.0,
	tool_capabilities = {
		damage_groups = {
			fleshy = 1
		},
		full_punch_interval = 1.0,
		groupcaps = {
			wood = create_dig_group(2.0)
		},
		max_drop_level = 9000
	}
})
minetest.register_tool("core:debug_hammer", {
	description = "A mighty debug hammer.",
	inventory_image = "iron_hammer.png",
	range = 5.0,
	tool_capabilities = {
		damage_groups = {
			fleshy = 1
		},
		full_punch_interval = 1.0,
		groupcaps = {
			building = create_dig_group(1.0),
			ice = create_dig_group(2.0),
			rock = create_dig_group(2.0),
			stone = create_dig_group(2.0)
		},
		max_drop_level = 9000
	}
})
minetest.register_tool("core:debug_pickaxe", {
	description = "A mighty debug pickaxe.",
	inventory_image = "iron_pickaxe.png",
	range = 5.0,
	tool_capabilities = {
		damage_groups = {
			fleshy = 1
		},
		full_punch_interval = 1.0,
		groupcaps = {
			dirt = create_dig_group(2.0),
			ice = create_dig_group(1.0),
			gravel = create_dig_group(2.0),
			rock = create_dig_group(1.0),
			sand = create_dig_group(3.0),
			snow = create_dig_group(3.0),
			stone = create_dig_group(1.0)
		},
		max_drop_level = 0
	}
})
minetest.register_tool("core:debug_shovel", {
	description = "A mighty debug shovel.",
	inventory_image = "iron_shovel.png",
	range = 5.0,
	tool_capabilities = {
		damage_groups = {
			fleshy = 1
		},
		full_punch_interval = 1.0,
		groupcaps = {
			dirt = create_dig_group(1.0),
			gravel = create_dig_group(2.0),
			sand = create_dig_group(0.5),
			snow = create_dig_group(0.5)
		},
		max_drop_level = 9000
	}
})

ap.core.artisanry:register("Debug", "core:debug_axe", {})
ap.core.artisanry:register("Debug", "core:debug_hammer", {})
ap.core.artisanry:register("Debug", "core:debug_pickaxe", {})
ap.core.artisanry:register("Debug", "core:debug_shovel", {})
ap.core.artisanry:register("Debug", "torch:torch_burning 64", {})

-- skins
playerskins.skins:foreach(function(skin, index)
	ap.core.artisanry:register("Clothes", skin.item_name, {})
end)

