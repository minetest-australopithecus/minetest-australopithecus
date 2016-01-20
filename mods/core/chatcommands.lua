--[[
Australopithecus, a game for Minetest.
Copyright (C) 2016, Robert 'Bobby' Zenz

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



minetest.register_chatcommand("suicide", {
	description = "Commit suicide.",
	params = "",
	func = function(player_name, params)
		if not settings.get_bool("enable_damage", true) then
			return false, "Damage is disabled."
		end
		
		local player = minetest.get_player_by_name(player_name)
		
		player:set_hp(0)
		
		return true
	end
})

