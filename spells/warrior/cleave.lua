--[[
*****************************************************************************
	Magia --> Cleave
		
	Descrição: Ataca a sua frente com um ataque circular
*****************************************************************************
]]--

function onCastSpell(cid, var)
	local direction = cid:getDirection()
	
	local middlePoint = CIRCULAR_TABLE[direction * 2]
	local size = 2
	local delay = 100
	
	local damage = calculateSpellDamage(cid, 2.85, 25)
	
	for i = -size, size do
		addEvent(function(cid) 
			if Creature(cid) then
				local player = Creature(cid)
				local pos = player:getPosition()
				local offsetIndex = math.abs((direction * 2 + i) % 8)
				local offsetPos = CIRCULAR_TABLE[offsetIndex]
				local spellPos = {x = pos.x + offsetPos.x, y = pos.y + offsetPos.y, z = pos.z}
				
				if canAttackTile(pos, spellPos) then
					doAreaCombat(player, COMBAT_PHYSICALDAMAGE, spellPos, nil, -damage, -damage, CONST_ME_BLOCKHIT)
				end
				
				if i > -size then
					local lastIndex = math.abs((direction * 2 + i - 1) % 8)
					local lastOffset = CIRCULAR_TABLE[lastIndex]
					local lastPos = {x = pos.x + lastOffset.x, y = pos.y + lastOffset.y, z = pos.z}
					
					doSendDistanceShoot(lastPos, spellPos, CONST_ANI_WHIRLWINDAXE)
				end
				
			end
		end, (i + size) * delay, cid:getId())
	end
	
	return true
end

