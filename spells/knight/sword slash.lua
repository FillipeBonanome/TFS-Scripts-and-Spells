--[[
*****************************************************************************
	Magia --> Sword Slash
		
	Descrição: Corta em uma área a sua frente causando dano de físico, possui
	change de causar um sangramento baixo. Magia similar a Cleave.
*****************************************************************************
]]--

function onCastSpell(cid, var)
	local direction = cid:getDirection()
	
	local middlePoint = CIRCULAR_TABLE[direction * 2]
	local size = 1
	
	local damage = calculateSpellDamage(cid, 2.35, 25)
	
	for i = -size, size do
		local player = Creature(cid)
		local pos = player:getPosition()
		local offsetIndex = math.abs((direction * 2 + i) % 8)
		local offsetPos = CIRCULAR_TABLE[offsetIndex]
		local spellPos = {x = pos.x + offsetPos.x, y = pos.y + offsetPos.y, z = pos.z}
		
		if canAttackTile(pos, spellPos) then
			doAreaCombat(player, COMBAT_PHYSICALDAMAGE, spellPos, nil, -damage, -damage, CONST_ME_BLOCKHIT)
			applyTileCondition(player, spellPos, createConditionDamageOverTime(player, CONDITION_BLEEDING, 4, damage * 0.1, subid, 1000))
		end
	end
	
	
	local pos = cid:getPosition()
	local initOffset = math.abs((direction * 2 - size) % 8)
	local initOffsetPos = CIRCULAR_TABLE[initOffset]
	local initPos = {x = pos.x + initOffsetPos.x, y = pos.y + initOffsetPos.y, z = pos.z}
	
	local offsetIndex = math.abs((direction * 2 + size) % 8)
	local offsetPos = CIRCULAR_TABLE[offsetIndex]
	local endPos = {x = pos.x + offsetPos.x, y = pos.y + offsetPos.y, z = pos.z}
	
	if math.random(1, 100) <= 50 then
		doSendDistanceShoot(initPos, endPos, CONST_ANI_WHIRLWINDSWORD)
	else
		doSendDistanceShoot(endPos, initPos, CONST_ANI_WHIRLWINDSWORD)
	end
	
	return true
end

