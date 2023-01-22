--[[
*****************************************************************************
	Magia --> Spinning Axe
		
	Descrição: Causa dano contínuo em sua volta
*****************************************************************************
]]--

local area = createCombatArea{{1,1,1},{1,3,1},{1,1,1}}

function onCastSpell(cid, var)
	
	targetDiamondAnimation(cid, 0, CONST_ANI_WHIRLWINDAXE, 40)
	targetDiamondAnimation(cid, 2, CONST_ANI_WHIRLWINDAXE, 40)
	
	local times = 20
	
	for i = 1, times do
		addEvent(function(cid) 
			if Creature(cid) then
				local player = Creature(cid)
				local pos = player:getPosition()
				local damage = calculateSpellDamage(player, 4.85, 100) / times
				doAreaCombat(player, COMBAT_PHYSICALDAMAGE, pos, area, -damage, -damage, CONST_ME_NONE)
			end
		end, (i - 1) * 250, cid:getId())
	end
	
	return true
end

