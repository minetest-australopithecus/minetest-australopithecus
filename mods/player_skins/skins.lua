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


local default_skins = ""
	.. "AC|ac.png,"
	.. "Bandit|bandit.png,"
	.. "Bloned|bloned.png,"
	.. "Builder|builder.png,"
	.. "Food|food.png,"
	.. "Forge|forge.png,"
	.. "Elite Guard|guardelite.png,"
	.. "Guild|guild.png,"
	.. "Headmage|headmage.png,"
	.. "Head|head.png,"
	.. "Headpriest|headpriest.png,"
	.. "Hunter|hunter.png,"
	.. "Inn|inn.png,"
	.. "Knight|knight.png,"
	.. "Librarian|librarian.png,"
	.. "Lone|lone.png,"
	.. "Man 1|man1.png,"
	.. "Man 2|man2.png,"
	.. "Man 3|man3.png,"
	.. "Man 4|man4.png,"
	.. "Man 5|man5.png,"
	.. "Man 6|man6.png,"
	.. "Man 7|man7.png,"
	.. "Member|member.png,"
	.. "Paladin|paladin.png,"
	.. "Priest|priest.png,"
	.. "Reficul Guardian|reficulGuardian.png,"
	.. "Reficul Mage|reficulMage.png,"
	.. "Reficul Soldier|reficulSoldier.png,"
	.. "Smith|smith.png,"
	.. "Stock|stock.png,"
	.. "Tavern|tavern.png,"
	.. "Tyber|tyber.png,"
	.. "Warrior|warrior.png,"
	.. "Wizard|wizard.png,"
	.. "Worker|worker.png"

local skins = settings.get_string("playerskins_skins", default_skins)
skins = stringutil.split(skins, ",")

skins:foreach(function(skin, index)
	local splitted = stringutil.split(skin, "|")
	
	local fancy_name = splitted:get(1)
	local texture = splitted:get(2)
	
	local name = string.sub(texture, 1, #texture - 4)
	
	minetest.register_craftitem("player_skins:" .. name, {
		description = "Clothes (" .. fancy_name .. ")",
		groups = {
			clothes = 1
		},
		inventory_image = "clothes.png",
		stack_max = 1
	})
	
	playerskins.skins:add({
		fancy_name = fancy_name,
		item_name = "player_skins:" .. name,
		name = name,
		texture = texture
	})
end)

