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


--- Disables the sneak glitch, given that disabling the sneak glitch hasn't
-- been disabled by setting "ap_sneak_glitch_available" to true in
-- the configuration.
--
-- @param player The Player on which to set it.
local function disable_sneak_glitch(player)
	local physics_override = player:get_physics_override()
	
	physics_override.sneak_glitch = settings.get_bool("ap_sneak_glitch_available", false),
	
	player:set_physics_override(physics_override)
end

--- Hides the crosshair unless the option "ap_crosshair_visible" for showing
-- the crosshair has been set in the configuration.
--
-- @param player The Player on which to set it.
local function hide_crosshair(player)
	local hud_flags = player:hud_get_flags()
	
	hud_flags.crosshair = settings.get_bool("ap_crosshair_visible", false)
	
	player:hud_set_flags(hud_flags)
end

--- Disables the minimap unless the option "ap_minimap_available" for showing
-- the minimap has been set in the configuration.
--
-- @param player The Player on which to set it.
local function hide_minimap(player)
	local hud_flags = player:hud_get_flags()
	
	hud_flags.minimap = settings.get_bool("ap_minimap_available", false)
	
	player:hud_set_flags(hud_flags)
end

--- Hides the nametag unless the option "ap_nametags_visible" for showing
-- the nametags has been set in the configuration.
--
-- @param player The Player on which to set it.
local function hide_nametag(player)
	if not settings.get_bool("ap_nametags_visible", false) then
		return
	end
	
	local nametag_attributes = player:get_nametag_attributes()
	
	nametag_attributes.color = "00000000"
	
	player:set_nametag_attributes(nametag_attributes)
end

--- Sets the time of day to the configured time.
local function set_gamestart_time()
	minetest.set_timeofday(settings.get_number("ap_gamestart_time", 0.18))
end


-- Actions for when a player has been spawned.
spawnusher.register_after_spawn_callback(function(player)
	disable_sneak_glitch(player)
end)

-- Actions for when a player joins.
minetest.register_on_joinplayer(function(player)
	hide_crosshair(player)
	hide_minimap(player)
	hide_nametag(player)
end)

minetest.register_on_newplayer(function(player)
	-- Only set the time of day when the game starts, that is (most of
	-- the time) the first join of the player "singleplayer".
	if player:get_player_name() == "singleplayer" then
		set_gamestart_time()
	end
end)

