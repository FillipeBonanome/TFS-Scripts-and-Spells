--[[
*****************************************************************************
	Magia --> Arcane Missiles
		
	Descrição: Ataca o alvo com 4 mísseis arcanos causando dano de energia.
*****************************************************************************
]]--

function onCastSpell(cid, var)
	local target = cid:getTarget()
	
	local distance = 8
	local damage = calculateSpellDamage(cid, 2.9, 65)
	
	local path = stepPositions(cid:getPosition(), target:getPosition(), distance)
	
	for i = 1, #path do
		local spellPos = path[i]
		
		if canAttackTile(cid:getPosition(), spellPos) then				
			doAreaCombat(cid, COMBAT_ENERGYDAMAGE, spellPos, nil, -damage, -damage, CONST_ME_ENERGYHIT)
		end
		
	end
	
	return true
end

