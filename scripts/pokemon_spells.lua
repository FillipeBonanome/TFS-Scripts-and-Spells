function swordSlash(cid)
	if cid:getTarget() then
		local target = cid:getTarget()
		local spellAttack = 40
		local pokeInfo = POKEMON_LIST[cid:getName()]
		
		local pokeAttack = pokeInfo.attack
		
		local damage = spellAttack * pokeAttack / 10
		damage = math.random(0.8 * damage, 1.2 * damage)
		
		doSendDistanceShoot(cid:getPosition(), target:getPosition(), CONST_ANI_WHIRLWINDSWORD)
		doTargetCombat(cid, target, COMBAT_PHYSICALDAMAGE, -damage, -damage)
	end
end

function radialCut(cid)
	local spellAttack = 65
	local pokeInfo = POKEMON_LIST[cid:getName()]
	
	local pokeAttack = pokeInfo.attack or 40
	
	local damage = spellAttack * pokeAttack / 10
	damage = math.random(0.8 * damage, 1.2 * damage)
	
	for i = -1, 1 do
		for j = -1, 1 do
			local pos = cid:getPosition()
			local spellPos = {x = pos.x + i, y = pos.y + j, z = pos.z}
			doAreaCombat(cid, COMBAT_PHYSICALDAMAGE, spellPos, nil, -damage, -damage, CONST_ME_GROUNDSHAKER)
		end
	end
end

function lastStand(cid)
	local health = cid:getMaxHealth()
	
	for i = 1, 10 do
		addEvent(function(cid) 
			if Creature(cid) then
				local cid = Creature(cid)
				doTargetCombat(0, cid, COMBAT_HEALING, health/20, health/20)
				doSendMagicEffect(cid:getPosition(), CONST_ME_MAGIC_GREEN)
				
				createDiamondAnimation(cid:getPosition(), 0, CONST_ANI_SMALLHOLY, 4)
				createDiamondAnimation(cid:getPosition(), 2, CONST_ANI_SMALLHOLY, 4)
				
			end
		end, i * 2000, cid:getId())
	end
end