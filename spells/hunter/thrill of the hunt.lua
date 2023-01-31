--[[
*****************************************************************************
	Magia --> Thrill of the Hunt
		
	Descrição: Marca uma criatura para ser caçada, a cada abate dessa criatura
	o seu dano causao nela é aumentado em 1%. Máx. 20%
*****************************************************************************
]]--

THRILL_OF_THE_HUNT_LIST = {}
THRILL_OF_THE_HUNT_STORAGE = 25447

function onCastSpell(cid, var)
	
	if cid:getTarget() and isMonster(cid:getTarget()) then
		local target = cid:getTarget()
		doSendMagicEffect(target:getPosition(), CONST_ME_TUTORIALARROW)
		THRILL_OF_THE_HUNT_LIST[cid:getId()] = target:getName()
		cid:setStorageValue(THRILL_OF_THE_HUNT_STORAGE, 0)
		
		cid:sendTextMessage(36, "The creature " .. target:getName() .. " is now on your hunt list!")
		
	end
	
	return true
end

