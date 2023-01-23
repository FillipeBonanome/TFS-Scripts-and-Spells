--[[
*****************************************************************************
	Magia --> Holy Aura
		
	Descrição: Durante 12 segundos o seu personagem causa dano em sua volta
	constantemente
*****************************************************************************
]]--

function onCastSpell(cid, var)
	
	local size = 3
	local duration = 12
	
	for a = 1, duration do
		addEvent(function(cid) 
			if Creature(cid) then
				local player = Creature(cid)
				local pos = player:getPosition()
				local damage = calculateSpellDamage(player, 5.85, 100)
				targetDiamondAnimation(player, 0, CONST_ANI_SMALLHOLY, 4)
				targetDiamondAnimation(player, 2, CONST_ANI_SMALLHOLY, 4)
				doSendMagicEffect(pos, CONST_ME_HOLYDAMAGE)
				for i = -size, size do
					for j = -size, size do
						local spellPos = {x = pos.x + i, y = pos.y + j, z = pos.z}
						if canAttackTile(pos, spellPos) then
							doAreaCombat(player, COMBAT_HOLYDAMAGE, spellPos, nil, -damage / duration, -damage / duration, CONST_ME_NONE)
						end
					end
				end
			end
		end, (a - 1) * 1000, cid:getId())
	end
	
	
	
	return true
end

