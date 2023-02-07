--[[
*****************************************************************************
	Dworc Puppeteer Attack 3
		
	Descrição: Cria uma área em volta do alvo que causa dano contínuo de trevas
*****************************************************************************
]]--

function onCastSpell(creature, variant)
	if creature:getTarget() and isSightClear(creature:getPosition(), creature:getTarget():getPosition()) then
		local target = creature:getTarget()
		local pos = target:getPosition()
		
		local area = {
			{0,2,2,2,0},
			{2,1,1,1,2},
			{2,1,1,1,2},
			{2,1,1,1,2},
			{0,2,2,2,0}
		}
		
		
		local center = math.ceil(#area/2)
		
		for a = 1, 8 do
			local damage = math.random(2, 5)
			addEvent(function(creature) 
				if Creature(creature) then
					local creature = Creature(creature)
					for i = 1, #area do
						for j = 1, #area[i] do
							if area[i][j] > 0 then
								local spellPos = {x = pos.x + (j - center), y = pos.y + (i - center), z = pos.z}
								if canAttackTile(pos, spellPos) then
									doAreaCombat(creature, COMBAT_DEATHDAMAGE, spellPos, nil, -damage, -damage, CONST_ME_NONE)
								end
								if area[i][j] == 2 then 
									if math.random(1, 100) <= 65 then
										doSendMagicEffectRandomDelay(spellPos, CONST_ME_MORTAREA, 0, 800)
									else
										if math.random(1, 100) <= 45 then
											doSendMagicEffectRandomDelay(spellPos, CONST_ME_BLACKSMOKE, 0, 800)
										end
									end
								else 
									if math.random(1, 100) <= 55 then
										doSendMagicEffectRandomDelay(spellPos, CONST_ME_MAGIC_RED, 0, 800)
									elseif math.random(1, 100) <= 20 then
										doSendMagicEffectRandomDelay(spellPos, CONST_ME_BLACKSMOKE, 0, 800)
									end
								end
							end
						end
					end
				end
			end, (a - 1) * 500, creature:getId())
		end

		return true
	else
		return false
	end
	
end
