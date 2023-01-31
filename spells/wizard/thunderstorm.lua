--[[
*****************************************************************************
	Magia --> Thunderstorm
		
	Descrição: Cria uma chuva de raios em uma posição fixa.
*****************************************************************************
]]--

function onCastSpell(cid, var)

	local pos = cid:getTarget():getPosition()
	local elements = {COMBAT_ENERGYDAMAGE}
	local distances = {CONST_ANI_NONE}
	local animations = {CONST_ME_BIGCLOUDS}
	local maxDamage = cid:getLevel() / 5 + cid:getMagicLevel() * 2.45 + 35
	local minDamage = maxDamage * 0.7
	local size = 8
	local duration = 8
	local frequency = 80
	
	createFixedRain(cid, pos, elements, distances, animations, minDamage, maxDamage, size, duration, frequency)
	
	return true
end

