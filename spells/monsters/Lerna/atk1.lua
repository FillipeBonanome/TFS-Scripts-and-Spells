--[[
*****************************************************************************
	Lerna Attack 1
		
	Descrição: Ataca até 3 oponentes corpo a corpo
*****************************************************************************
]]--

function shuffleTable(tbl)
  for i = #tbl, 2, -1 do
    local j = math.random(i)
    tbl[i], tbl[j] = tbl[j], tbl[i]
  end
  return tbl
end

function onCastSpell(creature, variant)
	if creature:getTarget() and isSightClear(creature:getPosition(), creature:getTarget():getPosition()) then
		local target = creature:getTarget()
		local targets = {}
		local pos = creature:getPosition()
		local size = 1
		local damage = math.random(220, 280)
		
		for i = -size, size do
			for j = -size, size do
				local checkPos = {x = pos.x + j, y = pos.y + i, z = pos.z}
				if Tile(checkPos):getCreatureCount() > 0 then
					for _, creatures in ipairs(Tile(checkPos):getCreatures()) do
						if creatures ~= creature and creatures ~= target then
							table.insert(targets, creatures)
						end
					end
				end
			end
		end
		
		shuffleTable(targets)
		
		doTargetCombat(creature, target, COMBAT_PHYSICALDAMAGE, -damage, -damage, nil, ORIGIN_MELEE, true, true)
		
		for i = 1, 2 do
			if targets[i] then
				doTargetCombat(creature, targets[i], COMBAT_PHYSICALDAMAGE, -damage, -damage, nil, ORIGIN_MELEE, true, true)
			end
		end
	
		return true
	else
		return false
	end
	
end
