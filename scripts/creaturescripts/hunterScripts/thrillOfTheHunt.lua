local creatureevent = CreatureEvent("thrillOfTheHunt")

function creatureevent.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
		if primaryType ~= COMBAT_HEALING and isMonster(creature) then
			
			if isPlayer(attacker) and THRILL_OF_THE_HUNT_LIST[attacker:getId()] == creature:getName() then
				local damageAmp = attacker:getStorageValue(THRILL_OF_THE_HUNT_STORAGE)
				if damageAmp > 0 then
					primaryDamage = primaryDamage * (1 + damageAmp / 100)
				end
			end
			
		end
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

creatureevent:register()

local creatureevent = CreatureEvent("thrillOfTheHuntDeath")

function creatureevent.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
	if isPlayer(killer) and THRILL_OF_THE_HUNT_LIST[killer:getId()] == creature:getName() then
		local hunterStack = killer:getStorageValue(THRILL_OF_THE_HUNT_STORAGE)
		killer:setStorageValue(THRILL_OF_THE_HUNT_STORAGE, math.min(hunterStack + 1, 20))
		if hunterStack < 20 then
			killer:sendTextMessage(36, "You hunting bonus damage is now " .. hunterStack + 1 .. "%")
		end
	end
	return true
end

creatureevent:register()

local registerToMonsters = GlobalEvent("registerThrillOfTheHunt")

function registerToMonsters.onStartup()
		
	for name, monstertype in pairs(Game.getMonsterTypes()) do
		monstertype:registerEvent("thrillOfTheHunt")
		monstertype:registerEvent("thrillOfTheHuntDeath")
	end	
		
	return true
end

registerToMonsters:register()
