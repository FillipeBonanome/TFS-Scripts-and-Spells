--[[
*****************************************************************************
	Magia --> Arcane Missiles
		
	Descrição: Ataca o alvo com 4 mísseis arcanos causando dano de energia.
*****************************************************************************
]]--

function onCastSpell(cid, var)
	local target = cid:getTarget()
	
	local times = 4
	local delay = 100
	
	for i = 1, times do
		addEvent(function(cid, tar) 
			if Creature(cid) and Creature(tar) then
				local player = Creature(cid)
				local target = Creature(tar)
				local damage = calculateSpellDamage(player, 2.35, 25)
				
				if canAttackTile(player:getPosition(), target:getPosition()) then				
					doSendDistanceShoot(player:getPosition(), target:getPosition(), CONST_ANI_ENERGY)
					doTargetCombat(player, target, COMBAT_ENERGYDAMAGE, -damage / times, -damage / times)
				end
				
			end
		end, (i - 1) * delay, cid:getId(), target:getId())
	end
	
	return true
end

