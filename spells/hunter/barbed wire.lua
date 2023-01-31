--[[
*****************************************************************************
	Magia --> Barbed Wire
		
	Descrição: Cria um arame farpado que causa dano contínuamente e paralisa
	o alvo
*****************************************************************************
]]--

function onCastSpell(cid, var)
	
	local element = COMBAT_PHYSICALDAMAGE
	local condition = createConditionParalyze(cid, 4, 0.45)
	local damage = calculateSpellDamage(cid, 3.15, 45)
	local duration = 8
	local pos = cid:getPosition()
	local size = 2
	local trapNumber = math.random(2, 5)
	local distanceAnimation = CONST_ANI_EXPLOSION
	
	for i = 1, trapNumber do
		local offset = {x = math.random(-size, size), y = math.random(-size, size)}
		local trapPos = {x = pos.x + offset.x, y = pos.y + offset.y, z = pos.z}
		
		if canAttackTile(pos, trapPos) then
			doSendDistanceShoot(pos, trapPos, distanceAnimation)
			createContinuousTrap(cid, trapPos, element, damage / (duration * 5), animation, condition, duration)
		end
	end
	
	
	
	return true
end

