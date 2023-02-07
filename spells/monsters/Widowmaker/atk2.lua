--[[
*****************************************************************************
	Lerna Attack 2
		
	Descrição: Tenta criar um casulo em volta do alvo, caso conseguir causa
	um dano massivo
*****************************************************************************
]]--

function onCastSpell(creature, variant)
	if creature:getTarget() and isSightClear(creature:getPosition(), creature:getTarget():getPosition()) then
		local target = creature:getTarget()
		local damage = 0
		local events = {}
		local times = 20
		
		for i = 1, times do
			local damage = math.random(680, 810)
			table.insert(events, addEvent(function(cid, tar) 
				if Creature(cid) and Creature(tar) then
					local creature = Creature(cid)
					local target = Creature(tar)
					
					if getDistanceBetween(creature:getPosition(), target:getPosition()) < 2 then
						target:setDirection(i % 4)
						target:addCondition(createConditionParalyze(creature, 1, 0.035 * i))
						doSendDistanceShoot(creature:getPosition(), target:getPosition(), CONST_ANI_POISON)
						if i % 4 == 1 then
							doTargetCombat(creature, target, COMBAT_POISONDAMAGE, -damage/times, -damage/times)
						end
						if i < times - 2 then
							createDiamondAnimation(target:getPosition(), i % 4, CONST_ANI_POISON, 1)
							createDiamondAnimation(target:getPosition(), (i + 2) % 4, CONST_ANI_POISON, 1)
						end
						if i == times - 1 then
							doSetCreatureOutfit(target, {lookTypeEx = 7556}, 1000)
							createImplosionAnimation(target:getPosition(), CONST_ANI_POISON)
						end
						if i == times then
							doTargetCombat(creature, target, COMBAT_PHYSICALDAMAGE, -damage/2, -damage/2)
							doTargetCombat(creature, target, COMBAT_POISONDAMAGE, -damage/2, -damage/2)
						end
					else
						for j = 1, #events do
							stopEvent(events[j])
						end
					end
				end
			end, (i - 1) * 150, creature:getId(), target:getId()))
		end
		
		return true
	else
		return false
	end
	
end
