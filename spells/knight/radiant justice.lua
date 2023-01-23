--[[
*****************************************************************************
	Magia --> Radiant Justice
		
	Descrição: Gera um corte em sua volta, causando dano de físico nos
	oponentes.
*****************************************************************************
]]--

function onCastSpell(cid, var)
	local pos = cid:getPosition()
	local dir = cid:getDirection()
	local offsets = CIRCULAR_TABLE
	local damage = calculateSpellDamage(cid, 2.55, 25)
	local delay = 55
	
	for i = 0, #offsets do
		addEvent(function(cid) 
			if Creature(cid) then
				local player = Creature(cid)
				local offset = offsets[(i + dir * 2) % 8]
				local spellPos = {x = pos.x + offset.x, y = pos.y + offset.y, z = pos.z}
				if canAttackTile(pos, spellPos) then
					doAreaCombat(player, COMBAT_PHYSICALDAMAGE, spellPos, nil, -damage, -damage, CONST_ME_HITAREA)
				end
			end
		end, i * delay, cid:getId())			
	end
	
	
	
	return true
end

