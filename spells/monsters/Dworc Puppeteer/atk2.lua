--[[
*****************************************************************************
	Dworc Puppeteer Attack 2
		
	Descrição: Coloca um efeito aleatório de condition no oponente durante 8 turnos
*****************************************************************************
]]--

function onCastSpell(creature, variant)
	if creature:getTarget() and isSightClear(creature:getPosition(), creature:getTarget():getPosition()) then
		local target = creature:getTarget()
		local damage = 2
		local ticks = 8
		local interval = 2000
		
		local conditions = {
			[1] = {name = CONDITION_CURSED, subid = 205, distance = CONST_ANI_SUDDENDEATH, animation = CONST_ME_MORTAREA},
			[2] = {name = CONDITION_FIRE, subid = 206, distance = CONST_ANI_FIRE, animation = CONST_ME_HITBYFIRE},
			[3] = {name = CONDITION_POISON, subid = 207, distance = CONST_ANI_POISON, animation = CONST_ME_GREEN_RINGS},
		}
		
		local conditionIndex = math.random(#conditions)
		local info = conditions[conditionIndex]
		
		target:addCondition(createConditionDamageOverTime(creature, info.name, ticks, damage, info.subid, interval))
		doSendMagicEffect(target:getPosition(), info.animation)
		targetDiamondAnimation(target, 0, info.distance, 4)
		targetDiamondAnimation(target, 2, info.distance, 4)
	
		return true
	else
		return false
	end
	
end
