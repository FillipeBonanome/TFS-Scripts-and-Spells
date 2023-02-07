--[[
*****************************************************************************
	Lerna Attack 3
		
	Descrição: Pula no alvo causando dano de veneno
*****************************************************************************
]]--

function onCastSpell(creature, variant)
	if creature:getTarget() and isSightClear(creature:getPosition(), creature:getTarget():getPosition()) then
		local target = creature:getTarget()
		local path = stepPositions(creature:getPosition(), target:getPosition(), getDistanceBetween(creature:getPosition(), target:getPosition()))
		local damage = math.random(170, 340)
		local tpPos = path[#path - 1]
		doSendMagicEffect(creature:getPosition(), CONST_ME_GREEN_RINGS)
		creature:teleportTo(tpPos)
		doTargetCombat(creature, target, COMBAT_POISONDAMAGE, -damage, -damage)
		
		return true
	else
		return false
	end
	
end
