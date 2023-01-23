--[[
*****************************************************************************
	Script --> Buff Handler
		
	Descrição: Lida com os buffs próprios de um jogador, deve ser registrado
	no login.lua para funcionar normalmente.
*****************************************************************************
]]--

local creatureevent = CreatureEvent("globalBuffsHandler")

function creatureevent.onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
		if Creature(creature) and creature:getStorageValue(GLOBAL_STORAGEBUFFTIMER) >= os.time() then
			local buffId = creature:getStorageValue(GLOBAL_STORAGEBUFFID)
			if buffId == 1 then
				if primaryType ~= COMBAT_HEALING then
					if primaryType == COMBAT_PHYSICALDAMAGE then
						primaryDamage = primaryDamage * 0.8
					else
						primaryDamage = primaryDamage * 0.9
					end
				end
			elseif buffId == 2 then
				if attacker and origin ~= 99 then
					doTargetCombat(creature, attacker, COMBAT_HOLYDAMAGE, -primaryDamage * 0.15, - primaryDamage * 0.15, nil, 99)
					doSendDistanceShoot(creature:getPosition(), attacker:getPosition(), CONST_ANI_SMALLHOLY)
				end
			end
		end
	return primaryDamage, primaryType, secondaryDamage, secondaryType
end

creatureevent:register()

local creatureevent = CreatureEvent("globalBuffsHandlerTimer")

function creatureevent.onThink(creature, interval)

	local buffsWords = {
		[1] = "Your Aegis of Valor ended...",
		[2] = "Your Shield of Faith ended...",
	}

	if creature:getStorageValue(GLOBAL_STORAGEBUFFTIMER) == os.time() then
		local text = buffsWords[creature:getStorageValue(GLOBAL_STORAGEBUFFID)] or "Your buff ended..."
		creature:sendTextMessage(36, text)
		doSendMagicEffect(creature:getPosition(), CONST_ME_MAGIC_GREEN)
	end
	
	return true
end

creatureevent:register()
