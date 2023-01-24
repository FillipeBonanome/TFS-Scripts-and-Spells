--[[
*****************************************************************************
	Magia --> Energy Flux
		
	Descrição: Joga uma bola de energia no alvo, que se espalha em criaturas
	adjascentes.
*****************************************************************************
]]--

function onCastSpell(cid, var)
	
	local target = cid:getTarget()
	local damage = calculateSpellDamage(cid, 3, 110)
	local size = 2
	local multiplier = 0.4
	local element = COMBAT_ENERGYDAMAGE
	local animation = CONST_ANI_ENERGY
	
	doSendDistanceShoot(cid:getPosition(), target:getPosition(), CONST_ANI_ENERGYBALL)
	doTargetCombat(cid, target, element, -damage, -damage)
	
	spreadOnContact(cid, target:getPosition(), damage, multiplier, size, element, animation)
	
	return true
end

