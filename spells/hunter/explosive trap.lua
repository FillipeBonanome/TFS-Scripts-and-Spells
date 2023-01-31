--[[
*****************************************************************************
	Magia --> Explosive Trap
		
	Descrição: Cria várias armadilha que explodem quanto um inimigo pisar nelas
*****************************************************************************
]]--

function onCastSpell(cid, var)
	
	local area = {
		{0,1,1,1,0},
		{1,1,1,1,1},
		{1,1,1,1,1},
		{1,1,1,1,1},
		{0,1,1,1,0},
	}
	
	local element = COMBAT_PHYSICALDAMAGE
	local trapAnimation = CONST_ME_EXPLOSIONAREA
	local hitAnimation = CONST_ME_EXPLOSIONHIT
	local damage = calculateSpellDamage(cid, 3.15, 45)
	local distanceAnimation = CONST_ANI_EXPLOSION
	local trapNumber = math.random(2, 4)
	local size = 3
	local pos = cid:getPosition()
	
	for i = 1, trapNumber do
		local offset = {x = math.random(-size, size), y = math.random(-size, size)}
		local trapPos = {x = pos.x + offset.x, y = pos.y + offset.y, z = pos.z}
		
		if canAttackTile(pos, trapPos) then
			doSendDistanceShoot(pos, trapPos, distanceAnimation)
			createExplosiveTrap(cid, trapPos, area, damage, element, trapAnimation, hitAnimation, duration)
		end
	end
	
	
	return true
end

