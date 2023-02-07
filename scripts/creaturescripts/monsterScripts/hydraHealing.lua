local creatureevent = CreatureEvent("hydraHealing")

function creatureevent.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
	if primaryType == COMBAT_PHYSICALDAMAGE then
		if math.random(1, 100) <= 35 then
			print("Curando em 3 segundos")
			addEvent(function(cid) 
				if Creature(cid) then
					local creature = Creature(cid)
					doTargetCombat(0, creature, COMBAT_HEALING, -primaryDamage, -primaryDamage)
					doSendMagicEffect(creature:getPosition(), CONST_ME_MAGIC_GREEN)
				end
			end, 3000, creature:getId())
		end
	end
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

creatureevent:register()
