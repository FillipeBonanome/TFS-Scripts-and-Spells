--[[
*****************************************************************************
	Magia --> Unstoppable Charge
		
	Descrição: Corre para frente e causa dano em sua volta a cada passo
*****************************************************************************
]]--

local area = createCombatArea{{1,1,1},{1,3,1},{1,1,1}}

function onCastSpell(cid, var)
	
	local steps = 16
	local delay = 100
	
	for i = 1, steps do
		addEvent(function(cid) 
			if Creature(cid) then
				local player = Creature(cid)
				local pos = player:getPosition()
				local dir = player:getDirection()
				local offset = OFFSET_TABLE[dir]
				local nextPos = {x = pos.x + offset.x, y = pos.y + offset.y, z = pos.z}
				local damage = calculateSpellDamage(player, 9.4, 120) / steps
				
				if Tile(nextPos) and not Tile(nextPos):hasFlag(TILESTATE_BLOCKSOLID) and Tile(nextPos):getCreatureCount() < 1 then
					player:teleportTo(nextPos, true)
					doAreaCombat(player, COMBAT_PHYSICALDAMAGE, nextPos, area, -damage, -damage, CONST_ME_GROUNDSHAKER)
				end
				
			end
		end, (i - 1) * delay, cid:getId())
	end
	
	
	return true
end

