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


ap.core.helpers.register_dirt()
ap.core.helpers.register_dirt("snowy_tundra", {
	drop = "core:dirt",
	groups = {
		dirt = DigSpeed.SLOW,
		oddly_breakable_by_hand = 2,
		becomes_dirt = NodeGroup.DUMMY,
		spreads_on_dirt = DigSpeed.SLOW
	},
	tiles = {
		"snow.png", "dirt.png",
		textureutil.tileable("snow_side.png", true, false), textureutil.tileable("snow_side.png", true, false),
		textureutil.tileable("snow_side.png", true, false), textureutil.tileable("snow_side.png", true, false)
	}
})
ap.core.helpers.register_dirt("wasteland")

ap.core.helpers.register_fluid("water", 160, 1)

ap.core.helpers.register_grass("chaparral")
ap.core.helpers.register_grass("deciduous_forest")
ap.core.helpers.register_grass("grassland", { spreads_on_dirt = DigSpeed.FAST })
ap.core.helpers.register_grass("rainforest", { spreads_on_dirt = DigSpeed.VERY_FAST })
ap.core.helpers.register_grass("savannah", { spreads_on_dirt = DigSpeed.VERY_SLOW })
ap.core.helpers.register_grass("seasonal_rainforest", { spreads_on_dirt = DigSpeed.FAST })
ap.core.helpers.register_grass("seasonal_shrubland")
ap.core.helpers.register_grass("swamp", { spreads_on_dirt = DigSpeed.VERY_FAST })
ap.core.helpers.register_grass("taiga")
ap.core.helpers.register_grass("tropical_seasonal_rainforest", { spreads_on_dirt = DigSpeed.FAST} )
ap.core.helpers.register_grass("tundra", { spreads_on_dirt = DigSpeed.SLOW })

ap.core.helpers.register_gravel()

ap.core.helpers.register_ice()
ap.core.helpers.register_ice("glacial", {
	groups = {
		ice = DigSpeed.SLOW
	}
})

ap.core.helpers.register_rock()
ap.core.helpers.register_rock("red")

ap.core.helpers.register_sand()

ap.core.helpers.register_snow()

ap.core.helpers.register_stone("sand", {
	groups = {
		stone = DigSpeed.FAST
	}
})

