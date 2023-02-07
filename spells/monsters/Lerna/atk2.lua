--[[
*****************************************************************************
	Lerna Attack 1
		
	Descrição: Ataca 3 vezes o mesmo alvo
*****************************************************************************
]]--

function onCastSpell(creature, variant)
	if creature:getTarget() and isSightClear(creature:getPosition(), creature:getTarget():getPosition()) then
		local target = creature:getTarget()
		
		for i = 1, 3 do
			addEvent(function(cid, tar) 
				if Creature(cid) and Creature(tar) then
					local creature = Creature(cid)
					local target = Creature(tar)
					
					local damage = math.random(80, 150)
					
					if getDistanceBetween(creature:getPosition(), target:getPosition()) < 2 then
						doTargetCombat(creature, target, COMBAT_PHYSICALDAMAGE, -damage, -damage, nil, ORIGIN_MELEE, true, true)
					end
					
				end
			end, (i - 1) * 500, creature:getId(), target:getId())
		end
	
		return true
	else
		return false
	end
	
end
