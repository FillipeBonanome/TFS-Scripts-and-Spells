--[[
*****************************************************************************
	Lerna Attack 1
		
	Descrição: Ataca oponente com veneno,  diferente a distancia e melee
*****************************************************************************
]]--

function shuffleTable(tbl)
  for i = #tbl, 2, -1 do
    local j = math.random(i)
    tbl[i], tbl[j] = tbl[j], tbl[i]
  end
  return tbl
end

function randomBehindRelativePosition(posA, posB, distance, area)
	local distance = distance or 6
	local area = area or 1
	local path = stepPositions(posA, posB, 6)
	local lastPath = path[#path]
	local positons = {}
	
	for i = -area, area do
		for j = -area, area do
			local pos = {x = lastPath.x + j, y = lastPath.y + i, z = lastPath.z}
			if isSightClear(posA, pos) then
				table.insert(positons, pos)
			end
		end
	end
	
	return positons
	
end

function onCastSpell(creature, variant)
	if creature:getTarget() and isSightClear(creature:getPosition(), creature:getTarget():getPosition()) then
		local target = creature:getTarget()
		local damage = 0
		local times = 12
		if getDistanceBetween(creature:getPosition(), target:getPosition()) > 1 then
			damage = math.random(180, 285)
			
			for i = 1, times do
				addEvent(function(cid, tar)
					if Creature(cid) and Creature(tar) then
						local creature = Creature(cid)
						local target = Creature(tar)
						local randomBehind = randomBehindRelativePosition(creature:getPosition(), target:getPosition())
						local behindIndex = math.random(#randomBehind)
						local path = stepPositions(creature:getPosition(), randomBehind[behindIndex], getDistanceBetween(creature:getPosition(), randomBehind[behindIndex]))
						doSendDistanceShoot(creature:getPosition(), randomBehind[behindIndex], CONST_ANI_POISON)
						for j = 1, #path do
							doAreaCombat(cid, COMBAT_POISONDAMAGE, path[j], nil, -damage / times, -damage / times, CONST_ME_NONE)
						end
					end
				end, (i - 1) * 50, creature:getId(), target:getId())
			end

		else
			damage = math.random(240, 345)
			doTargetCombat(creature, target, COMBAT_POISONDAMAGE, -damage, -damage, nil, true, true)
		end
		
		return true
	else
		return false
	end
	
end
