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

