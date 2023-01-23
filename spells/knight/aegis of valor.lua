--[[
*****************************************************************************
	Magia --> Aegis of Valor
		
	Descrição: Faz com que o jogador receba 10% a menos de dano, 20% para
	danos físicos por 60 segundos.
*****************************************************************************
]]--

function onCastSpell(cid, var)
	
	local duration = 60
	
	cid:setStorageValue(GLOBAL_STORAGEBUFFID, 1)
	cid:setStorageValue(GLOBAL_STORAGEBUFFTIMER, os.time() + duration)
	
	targetDiamondAnimation(cid, 0, CONST_ANI_LARGEROCK, 8)
	targetDiamondAnimation(cid, 2, CONST_ANI_LARGEROCK, 8)
	doSendMagicEffect(cid:getPosition(), CONST_ME_CRAPS)
	
	cid:registerEvent("globalBuffsHandler")
	cid:registerEvent("globalBuffsHandlerTimer")
	
	cid:sendTextMessage(36, "You are protected by the Aegis of Valor, reducing incomming damage by 10%. Double effectiveness against physical damage.")
	
	return true
end

