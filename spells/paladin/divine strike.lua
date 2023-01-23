--[[
*****************************************************************************
	Magia --> Divine Strike
		
	Descrição: Ataca o oponente com dano físico + luz
*****************************************************************************
]]--

function onCastSpell(cid, var)
	
	local target = cid:getTarget()
	local damage = calculateSpellDamage(cid, 1.75, 8)
	local elements = {COMBAT_PHYSICALDAMAGE, COMBAT_HOLYDAMAGE}
	
	for i = 1, #elements do
		doTargetCombat(cid, target, elements[i], -damage / #elements, -damage / #elements)
	end
	
	
	return true
end

