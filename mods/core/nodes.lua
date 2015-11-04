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


ap.core.helpers.register_dirt()
ap.core.helpers.register_dirt("snowy_tundra", {
	drop = "core:dirt",
	groups = {
		dirt = DigSpeed.SLOW,
		oddly_breakable_by_hand = 2,
		becomes_dirt = DigSpeed.DUMMY,
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

