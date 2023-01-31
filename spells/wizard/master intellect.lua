--[[
*****************************************************************************
	Magia --> Master Intellect
		
	Descrição: Amplifica o seu dano de raio causado em 15%
*****************************************************************************
]]--

function onCastSpell(cid, var)
	
	local duration = 5
	
	local target = cid:getTarget()
	
	cid:setStorageValue(GLOBAL_STORAGEBUFFID, 3)
	cid:setStorageValue(GLOBAL_STORAGEBUFFTIMER, os.time() + duration)
	
	targetDiamondAnimation(cid, 0, CONST_ANI_ENERGYBALL, 8)
	targetDiamondAnimation(cid, 2, CONST_ANI_ENERGYBALL, 8)
	
	cid:registerEvent("globalBuffsHandler")
	cid:registerEvent("globalBuffsHandlerTimer")
	
	cid:sendTextMessage(36, "With the power of your intellect, you energy spells you deal 15% more damage.")
	
	return true
end

