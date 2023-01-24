--[[
*****************************************************************************
	Magia --> Arcane Missiles
		
	Descrição: Ataca o alvo com 4 mísseis arcanos causando dano de energia.
*****************************************************************************
]]--

function onCastSpell(cid, var)
	
	local pos = cid:getTarget():getPosition()
	local target = cid:getTarget()
	local tPos = target:getPosition()
	local delay = 300
	
	local area = {
		{0,0,1,1,1,0,0},
		{0,1,2,2,2,1,0},
		{1,2,3,3,3,2,1},
		{1,2,3,4,3,2,1},
		{1,2,3,3,3,2,1},
		{0,1,2,2,2,1,0},
		{0,0,1,1,1,0,0}
	}
	
	local center = math.ceil(#area/2)
	
	for i = 1, #area do
		for j = 1, #area[i] do
			if area[i][j] > 0 then
				local spellPos = {x = pos.x + (j - center), y = pos.y + (i - center), z = pos.z}
				doAreaCombat(cid, COMBAT_ENERGYDAMAGE, spellPos, nil, -50, -50, CONST_ME_NONE)
			end
		end
	end
	
	for a = 1, 4 do
		addEvent(function(cid) 
			if Creature(cid) then
				local player = Creature(cid)
				for i = 1, #area do
					for j = 1, #area[i] do
						if area[i][j] == a then
							local spellPos = {x = pos.x + (j - center), y = pos.y + (i - center), z = pos.z}
							doSendMagicEffect(spellPos, CONST_ME_ENERGYAREA)
						end
					end
				end
			end
		end, (a - 1) * delay, cid:getId())
	end
	
	return true
end

