--[[
*****************************************************************************
	Lerna Attack 3
		
	Descrição: Wave tripla de veneno
*****************************************************************************
]]--

function selectRandomAnim(animArray)
	local total = 0
	
	for i = 1, #animArray do
		local value = animArray[i].chance
		total = total + value
	end
	
	local randomValue = math.random(total)
	local randomIndex = 1
	
	for i = 1, #animArray do
		randomValue = randomValue - animArray[i].chance
		if randomValue <= 0 then
			randomIndex = i
			break
		end
	end
	
	return randomIndex
end

function createWaveWithDelay(creature, element, area, animation, damage, delay, randomAnim)
	local pos = creature:getPosition()
	local direction = creature:getDirection()
	local element = element or COMBAT_FIREDAMAGE
	local animation = animation or CONST_ME_FIREAREA
	local damage = damage or 10
	local delay = delay or 0
	
	local waveArea = area or {{4,4,4},{3,3,3},{2,2,2},{1,1,1}}
	
	local centerPos = {x = #waveArea, y = math.ceil(#waveArea[1]/2)}
	
	for a = 1, #waveArea do
		addEvent(function(cid) 
			if Creature(cid) then
				local creature = Creature(cid)
				for i = 1, #waveArea do
					for j = 1, #waveArea[i] do
						local spellArea = {x = pos.x + (i - centerPos.x - 1), y = pos.y + (j - centerPos.y), z = pos.z}
						if direction == 0 then
							spellArea = {x = pos.x + (j - centerPos.y), y = pos.y + (i - centerPos.x - 1), z = pos.z}
						elseif direction == 1 then
							spellArea = {x = pos.x - (i - centerPos.x - 1), y = pos.y - (j - centerPos.y), z = pos.z}
						elseif direction == 2 then
							spellArea = {x = pos.x - (j - centerPos.y), y = pos.y - (i - centerPos.x - 1), z = pos.z}
						end
						if canAttackTile(creature:getPosition(), spellArea) and waveArea[i][j] == a then
							local tile = Tile(spellArea)
							if not randomAnim then
								doSendMagicEffect(spellArea, animation)
							else
								local randomIndex = selectRandomAnim(randomAnim)
								doSendMagicEffect(spellArea, randomAnim[randomIndex].name)
							end
							if tile:getCreatureCount() > 0 then
								for _, creatures in ipairs(tile:getCreatures()) do
									doTargetCombatHealth(creature, creatures, COMBAT_POISONDAMAGE, -damage, -damage, nil, ORIGIN_SPELL)
								end
							end
						end
					end
				end
			end
		end, (a - 1) * delay, creature:getId())
	end

end

function onCastSpell(creature, variant)
	local direction = creature:getDirection()
	
	local area = {
		{5,5,5,5,5},
		{4,4,4,4,4},
		{0,3,3,3,0},
		{0,2,2,2,0},
		{0,0,1,0,0},
	}
	
	local delay = 75
	
	local randomAnim = {
		[1] = {name = CONST_ME_GREEN_RINGS, chance = 35},
		[2] = {name = CONST_ME_YELLOWSMOKE, chance = 35},
		[3] = {name = CONST_ME_GREENSMOKE, chance = 65},
		[4] = {name = CONST_ME_YELLOW_RINGS, chance = 65},
		[5] = {name = CONST_ME_POISONAREA, chance = 15}
	}
	
	local damage = math.random(130, 170)
	createWaveWithDelay(creature, element, area, animation, damage, delay, randomAnim)
	
	return true
	
end
