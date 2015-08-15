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
dofile(base_path .. "/nodegroup.lua")
dofile(base_path .. "/mechanics.lua")
dofile(base_path .. "/nodes.lua")

-- Activate Artisanry
ArtisanryUI.activate(ap.core.artisanry)

-- Activate Spawn Usher
spawnusher.activate(
	80, -- Spread the players really far.
	7 -- Let's try to avoid *most* cave spawns.
)

-- Activate Voice.
voice.activate()

