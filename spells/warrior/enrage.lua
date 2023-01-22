--[[
*****************************************************************************
	Magia --> Enrage
		
	Descrição: Aumenta as suas skills em 25% por 30 segundos
*****************************************************************************
]]--

function onCastSpell(cid, var)
	
	local condition = createConditionObject(CONDITION_ATTRIBUTES)
	condition:setParameter(CONDITION_PARAM_SKILL_MELEEPERCENT, 125)
	condition:setParameter(CONDITION_PARAM_SKILL_FISTPERCENT, 125)
	condition:setParameter(CONDITION_PARAM_TICKS, 30000)
	condition:setParameter(CONDITION_PARAM_SUBID, 200)
	
	cid:addCondition(condition)
	doSendMagicEffect(cid:getPosition(), CONST_ME_MAGIC_RED)
	
	return true
end

