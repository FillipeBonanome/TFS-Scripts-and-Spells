--[[
*****************************************************************************
	Magia --> Iron Defense
		
	Descrição: Aumenta a sua skill de shield em 30% por 30s.
*****************************************************************************
]]--

function onCastSpell(cid, var)
	
	local condition = createConditionObject(CONDITION_ATTRIBUTES)
	condition:setParameter(CONDITION_PARAM_SKILL_SHIELDPERCENT, 130)
	condition:setParameter(CONDITION_PARAM_TICKS, 30000)
	condition:setParameter(CONDITION_PARAM_SUBID, 200)
	
	cid:addCondition(condition)
	createImplosionAnimation(cid:getPosition(), CONST_ANI_SMALLSTONE)
	doSendMagicEffect(cid:getPosition(), CONST_ME_GROUNDSHAKER)
	
	return true
end

