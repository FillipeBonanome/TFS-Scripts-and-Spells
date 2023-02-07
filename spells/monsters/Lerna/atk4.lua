--[[
*****************************************************************************
	Lerna Attack 4
		
	Descrição: Ataca até 3 oponentes com raios venenosos
*****************************************************************************
]]--


function onCastSpell(creature, variant)
	if creature:getTarget() and isSightClear(creature:getPosition(), creature:getTarget():getPosition()) then
		local target = creature:getTarget()
		local direction = creature:getDirection()
		local targets = {}
		local pos = creature:getPosition()
		local size = 4
		local damage = math.random(150, 210)
		local delay = 75
		
		local offsets = OFFSET_TABLE
		
		for i = -size, size do
			for j = -size, size do
				local checkPos = {x = pos.x + j + offsets[direction].x * size, y = pos.y + i + offsets[direction].y * size, z = pos.z}
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
		
		local randomAnim = {
			[1] = {name = CONST_ME_GREEN_RINGS, chance = 35},
			[2] = {name = CONST_ME_YELLOWSMOKE, chance = 35},
			[3] = {name = CONST_ME_GREENSMOKE, chance = 65},
			[4] = {name = CONST_ME_YELLOW_RINGS, chance = 65},
			[5] = {name = CONST_ME_POISONAREA, chance = 15}
		}
		
		local path = stepPositions(creature:getPosition(), target:getPosition(), 8)
		for i = 1, #path do
			addEvent(function(cid) 
				if Creature(cid) then
					local creature = Creature(cid)
					doAreaCombat(creature, COMBAT_POISONDAMAGE, path[i], nil, -damage, -damage, CONST_ME_NONE)
					local randomIndex = selectRandomAnim(randomAnim)
					doSendMagicEffect(path[i], randomAnim[randomIndex].name)
				end
			end, (i - 1) * delay, creature:getId())
		end
		
		for i = 1, 2 do
			addEvent(function(cid) 
				if Creature(cid) then
					local creature = Creature(cid)
					if targets[i] then
						local path = stepPositions(creature:getPosition(), targets[i]:getPosition(), 8)
						for j = 1, #path do
							addEvent(function(cid) 
								if Creature(cid) then
									local creature = Creature(cid)
									doAreaCombat(creature, COMBAT_POISONDAMAGE, path[j], nil, -damage, -damage, CONST_ME_NONE)
									local randomIndex = selectRandomAnim(randomAnim)
									doSendMagicEffect(path[j], randomAnim[randomIndex].name)
								end
							end, (j - 1) * delay, creature:getId())
						end
					end
				end
			end, i * (2 * delay), creature:getId())
		end
	end
	
	return true
	
end
