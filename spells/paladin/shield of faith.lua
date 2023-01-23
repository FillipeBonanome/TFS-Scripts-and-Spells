--[[
*****************************************************************************
	Magia --> Shield of Faith
		
	Descrição: Faz com que ataques recebidos sejam refletidos em 10% do dano
	com o elemento luz.
*****************************************************************************
]]--

function onCastSpell(cid, var)
	
	local duration = 
	
	local target = cid:getTarget()
	
	cid:setStorageValue(GLOBAL_STORAGEBUFFID, 2)
	cid:setStorageValue(GLOBAL_STORAGEBUFFTIMER, os.time() + duration)
	
	targetDiamondAnimation(cid, 0, CONST_ANI_HOLY, 8)
	targetDiamondAnimation(cid, 2, CONST_ANI_HOLY, 8)
	doSendMagicEffect(cid:getPosition(), CONST_ME_HOLYAREA)
	
	cid:registerEvent("globalBuffsHandler")
	cid:registerEvent("globalBuffsHandlerTimer")
	
	cid:sendTextMessage(36, "With God on your side, incomming attacks will be reflected as the purest light back to your opponents.")
	
	return true
end

