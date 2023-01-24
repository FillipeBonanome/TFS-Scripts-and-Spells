--[[
*****************************************************************************
	Magia --> Arcane Missiles
		
	Descrição: Ataca o alvo com 4 mísseis arcanos causando dano de energia.
*****************************************************************************
]]--

function onCastSpell(cid, var)
	local target = cid:getTarget()
	
	local times = 4
	local delay = 100
	local size = 2
	local damage = calculateSpellDamage(cid, 2.1, 20)
	local multiplier = 0.7
	local bounces = 6
	local animation = CONST_ANI_ENERGYBALL
	local element = COMBAT_ENERGYDAMAGE
	
	doSendDistanceShoot(cid:getPosition(), target:getPosition(), animation)
	doTargetCombat(cid, target, element, -damage, -damage)
	
	bounceOnContact(cid, target, damage, multiplier, bounces, animation, element)
	
	return true
end

