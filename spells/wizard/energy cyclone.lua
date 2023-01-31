--[[
*****************************************************************************
	Magia --> Thunderstorm
		
	Descrição: Cria uma chuva de raios em uma posição fixa.
*****************************************************************************
]]--

function onCastSpell(cid, var)

	local damage = calculateSpellDamage(cid, 2.15, 30)

	createCycloneAttack(cid, pos, element, distance, animation, 8, damage, 100, CONST_ME_ENERGYAREA)
	
	return true
end

