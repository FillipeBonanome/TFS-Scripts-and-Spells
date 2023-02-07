--[[
*****************************************************************************
	Dworc Puppeteer Attack 1
		
	Descrição: Ataca o oponente com dano de trevas
*****************************************************************************
]]--

function onCastSpell(creature, variant)
	if creature:getTarget() and isSightClear(creature:getPosition(), creature:getTarget():getPosition()) then
		local target = creature:getTarget()
		local damage = math.random(10, 30)
		
		doSendMagicEffect(target:getPosition(), CONST_ME_BLACKSMOKE)
		doSendDistanceShoot(creature:getPosition(), target:getPosition(), CONST_ANI_DEATH)
		doTargetCombat(creature, target, COMBAT_DEATHDAMAGE, -damage, -damage, nil, ORIGIN_RANGED, true, true)
	
		return true
	else
		return false
	end
	
end
