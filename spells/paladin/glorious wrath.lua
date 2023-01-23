--[[
*****************************************************************************
	Magia --> Glorious Wrath
		
	Descrição: Causa dano no oponente, possuindo chance de se curar em 5%
	da vida máxima
*****************************************************************************
]]--

function onCastSpell(cid, var)
	
	local target = cid:getTarget()
	local damage = calculateSpellDamage(cid, 2, 40)
	local chance = 50
	
	doTargetCombat(cid, target, COMBAT_HOLYDAMAGE, -damage, -damage)
	
	if math.random(1, 100) <= chance then
		local pHealth = cid:getMaxHealth() * 0.05
		doTargetCombat(0, cid, COMBAT_HEALING, pHealth, pHealth)
		doSendMagicEffect(cid:getPosition(), CONST_ME_MAGIC_BLUE)
	end
	
	
	return true
end

