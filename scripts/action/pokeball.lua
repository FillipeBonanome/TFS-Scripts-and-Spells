local pokeball = Action()

local spellAttributes = {"spell1", "spell2", "spell3", "spell4", "spell5"}

function releasePokemon(cid, item)
	if item:getCustomAttribute("catch") == 1 then
		local pokeName = item:getCustomAttribute("pokeName")
		local pokeHealth = item:getCustomAttribute("pokeHealth")
		local pokeMaxHealth = item:getCustomAttribute("pokeMaxHealth")
		local pokeId = item:getCustomAttribute("pokeId")
		
		doCreatureSay(cid, "Vai " .. pokeName, TALKTYPE_ORANGE_1)
		
		local pokemon = Game.createMonster(pokeName, cid:getPosition())
		pokemon:setStorageValue(255, pokeId)
		
		doConvinceCreature(cid, pokemon)
		pokemon:setMaxHealth(pokeMaxHealth)
		pokemon:setHealth(pokeHealth)
		
		doSendDistanceShoot(cid:getPosition(), pokemon:getPosition(), CONST_ANI_HOLY)
		doSendMagicEffect(pokemon:getPosition(), CONST_ME_HOLYAREA)
		
		for i = 1, #spellAttributes do
			local cd = item:getCustomAttribute(spellAttributes[i]) or 0
			pokemon:setStorageValue(300 + i, cd)
		end
		
		local offsets = CIRCULAR_TABLE
		
		for i = 0, #offsets do
			local expand = 2
			local offset = offsets[i]
			
			if i % 2 == 0 then
				expand = 3
			end
			
			local pos = pokemon:getPosition()
			local newPos = {x = pos.x + offset.x * expand, y = pos.y + offset.y * expand, z = pos.z}
			
			doSendDistanceShoot(pos, newPos, CONST_ANI_SMALLHOLY)
		end
	end
end

function retrievePokemon(cid, item, pokemon)
	if pokemon:getStorageValue(255) == item:getCustomAttribute("pokeId") then
		local calcMaxHealth = POKEMON_LIST[pokemon:getName()].health
		local pokeHealthPerLevel = POKEMON_LIST[pokemon:getName()].healthPerLevel or 20
		
		local pokeMaxHealth = calcMaxHealth + pokeHealthPerLevel * cid:getLevel()
		
		item:setCustomAttribute("pokeHealth", pokemon:getHealth())
		item:setCustomAttribute("pokeMaxHealth", pokeMaxHealth)
		item:setCustomAttribute("pokeName", pokemon:getName())
		item:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, "This pokeball contains a " .. pokemon:getName() .. 
														"\nHealth: " ..pokemon:getHealth() .. "/" .. pokemon:getMaxHealth())
														
		for i = 1, #spellAttributes do
			item:setCustomAttribute(spellAttributes[i], pokemon:getStorageValue(300 + i))
		end
														
		local pos = pokemon:getPosition()
		createDiamondAnimation(pos, 0, CONST_ANI_SMALLHOLY, 4)
		createDiamondAnimation(pos, 2, CONST_ANI_SMALLHOLY, 4)
		doSendDistanceShoot(pos, cid:getPosition(), CONST_ANI_HOLY)
		doSendMagicEffect(pos, CONST_ME_HOLYAREA)
		doCreatureSay(cid, "Voce fez um otimo trabalho " .. pokemon:getName(), TALKTYPE_ORANGE_1)
		
		pokemon:remove()
		
	end
end

function pokeball.onUse(player, item, fromPosition, target, toPosition, isHotkey)

		if item:getCustomAttribute("catch") ~= 1 then
			if player:getTarget() then
				local target = player:getTarget()
				if  target:getHealth() < 0.35 * target:getMaxHealth() then
					doCreatureSay(player, "CATCH!", TALKTYPE_ORANGE_1)
					local itemId = item:getId()
					item:remove(1)
					local item = Game.createItem(itemId, 1)
					
					item:setCustomAttribute("catch", 1)
					item:setCustomAttribute("pokeName", target:getName())
					item:setCustomAttribute("pokeHealth", target:getHealth())
					item:setCustomAttribute("pokeMaxHealth", target:getMaxHealth())
					item:setCustomAttribute("pokeId", os.time())
					item:setAttribute(ITEM_ATTRIBUTE_DESCRIPTION, "This pokeball contains a " .. target:getName() ..
																	"\nHealth: " .. target:getHealth() .. "/" .. target:getMaxHealth())
					
					player:addItemEx(item)
					
					local pos = target:getPosition()
					createDiamondAnimation(pos, 0, CONST_ANI_SMALLHOLY, 4)
					createDiamondAnimation(pos, 2, CONST_ANI_SMALLHOLY, 4)
					doSendDistanceShoot(pos, player:getPosition(), CONST_ANI_HOLY)
					target:remove()
				end
			end
		else
			if #player:getSummons() > 0 then
				local pokemons = player:getSummons()
				local pokemon = pokemons[1]
				retrievePokemon(player, item, pokemon)
			else
				releasePokemon(player, item)
			end
			
		end
	return true
end

pokeball:id(11325)
pokeball:register()