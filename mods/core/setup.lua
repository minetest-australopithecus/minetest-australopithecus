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


--- Disables the sneak glitch, given that disabling the sneak glitch hasn't
-- been disabled by setting "ap_sneak_glitch_available" to true in
-- the configuration.
--
-- @param player The Player on which to set it.
local function disable_sneak_glitch(player)
	player:set_physics_override({
		sneak_glitch = settings.get_bool("ap_sneak_glitch_available", false)
	})
end

--- Hides the crosshair unless the option "ap_crosshair_visible" for showing
-- the crosshair has been set in the configuration.
--
-- @param player The Player on which to set it.
local function hide_crosshair(player)
	player:hud_set_flags({
		crosshair = settings.get_bool("ap_crosshair_visible", false)
	})
end

--- Disables the minimap unless the option "ap_minimap_available" for showing
-- the minimap has been set in the configuration.
--
-- @param player The Player on which to set it.
local function hide_minimap(player)
	player:hud_set_flags({
		minimap = settings.get_bool("ap_minimap_available", false)
	})
end

--- Hides the nametag unless the option "ap_nametags_visible" for showing
-- the nametags has been set in the configuration.
--
-- @param player The Player on which to set it.
local function hide_nametag(player)
	if settings.get_bool("ap_nametags_visible", false) then
		player:set_nametag_attributes({
			color = "00000000"
		})
	end
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

