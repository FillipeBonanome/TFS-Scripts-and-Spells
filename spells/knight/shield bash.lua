--[[
*****************************************************************************
	Magia --> Shield Bash
		
	Descrição: Ataca o oponente com dano físico, o dano aumenta de acordo
	com a defesa do jogador.Paralisa o alvo em 20% por 1.5s.
*****************************************************************************
]]--

function onCastSpell(cid, var)
	
	local target = cid:getTarget()
	
	local defense = getPlayerTotalAttribute(cid, ITEM_ATTRIBUTE_DEFENSE, false)
	local skill = cid:getEffectiveSkillLevel(SKILL_SHIELD)
	
	local damage = cid:getLevel() / 5 + skill * 1.95 + 15
	damage = damage * (1 + defense / 100)
	damage = math.random(0.7 * damage, damage)
	
	doTargetCombat(cid, target, COMBAT_PHYSICALDAMAGE, -damage, -damage)
	target:addCondition(createConditionParalyze(cid, 1.5, 0.2))
	
	return true
end

