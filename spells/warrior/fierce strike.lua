--[[
*****************************************************************************
	Magia --> Fierce Strike
		
	Descrição: Ataca o alvo com dano de físico baseado na sua maior skill
*****************************************************************************
]]--

function onCastSpell(cid, var)
	local animation = WEAPON_ANIMATION_TABLE[getPlayerWeaponType(cid)]
	local target = cid:getTarget()
	
	local damage = calculateSpellDamage(cid, 2.25, 8)
	
	--doSendDistanceShoot(cid:getPosition(), target:getPosition(), animation)
	doTargetCombat(cid, target, COMBAT_PHYSICALDAMAGE, -damage, -damage)
	
	return true
end

