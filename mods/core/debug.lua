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

ap.core.artisanry:register("core:debug_axe", {})
ap.core.artisanry:register("core:debug_hammer", {})
ap.core.artisanry:register("core:debug_pickaxe", {})
ap.core.artisanry:register("core:debug_shovel", {})
ap.core.artisanry:register("torch:torch_burning 64", {})

