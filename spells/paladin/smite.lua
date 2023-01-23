--[[
*****************************************************************************
	Magia --> Smite
		
	Descrição: Causa dano de luz no oponente, caso for undead ou fire o dano
	é aumentado em 30%
*****************************************************************************
]]--

function onCastSpell(cid, var)
	
	local target = cid:getTarget()
	local damage = calculateSpellDamage(cid, 1.75, 20)
	
	if isCreatureUnholy(target) then
		damage = damage * 1.3
		print("Bonus")
		doSendMagicEffect(target:getPosition(), CONST_ME_HOLYAREA)
	end
	
	print(target:getType():race())
	
	doTargetCombat(cid, target, COMBAT_HOLYDAMAGE, -damage, -damage)
	
	
	return true
end

