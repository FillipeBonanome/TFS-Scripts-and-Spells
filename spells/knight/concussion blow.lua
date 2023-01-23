--[[
*****************************************************************************
	Magia --> Concussion Blow
		
	Descrição: Ataca o oponente com dano físico empurrando-o em 1sqm. Caso
	o oponente bater em uma parede ou criatura ele receberá +50% de dano e
	paralisia de 60% por 1s.
*****************************************************************************
]]--

function onCastSpell(cid, var)
	
	local target = cid:getTarget()
	
	local damage = calculateSpellDamage(cid, 1.95, 20)
	doTargetCombat(cid, target, COMBAT_PHYSICALDAMAGE, -damage, -damage)
	
	if not simpleMeleePlayerTargetPushOver(cid, target) then
		doTargetCombat(cid, target, COMBAT_PHYSICALDAMAGE, -damage / 2, -damage / 2)
		doSendMagicEffect(target:getPosition(), CONST_ME_STUN)
		target:addCondition(createConditionParalyze(cid, 1, 0.6))
	end
	
	return true
end

