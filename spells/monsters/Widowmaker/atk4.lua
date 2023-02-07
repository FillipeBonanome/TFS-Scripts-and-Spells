--[[
*****************************************************************************
	Lerna Attack 4
		
	Descrição: Invocações temporárias
*****************************************************************************
]]--

function onCastSpell(creature, variant)
	if creature:getTarget() and isSightClear(creature:getPosition(), creature:getTarget():getPosition()) then
		local pos = creature:getPosition()
		local summons = math.random(1, 4)
		local timer = 6000
		for i = 1, summons do
			local monsterPos = {x = pos.x + math.random(-1, 1), y = pos.y + math.random(-1, 1), z = pos.z}
			if Tile(monsterPos) and Tile(monsterPos):getCreatureCount() < 1 then
				doSendDistanceShoot(pos, monsterPos, CONST_ANI_POISON)
				local monster = Game.createMonster("Giant Spider", monsterPos, true, true)
				addEvent(function(cid)
					if Creature(cid) then
						local effectPos = Creature(cid):getPosition()
						createDiamondAnimation(effectPos, 0, CONST_ANI_POISON, 4)
						createDiamondAnimation(effectPos, 2, CONST_ANI_POISON, 4)
						doSendMagicEffect(effectPos, CONST_ME_POISONAREA)
						Creature(cid):remove()
					end
				end, timer, monster:getId())
			end
		end
		
		return true
	else
		return false
	end
	
end
