--[[
*****************************************************************************
	Magia --> Stomp
		
	Descrição: Causa dano em sua volta e possui 30% de paralisia
*****************************************************************************
]]--

function onCastSpell(cid, var)
	
	local area = {
		{1,1,1},
		{1,1,1},
		{1,1,1}
	}
	
	local pos = cid:getPosition()
	local center = math.ceil(#area/2)
	local damage = calculateSpellDamage(cid, 2.65, 35)
	local condition =createConditionParalyze(cid, 4, 0.4)
	local chance = 30
	local paralyze = false
	
	if math.random(1, 100) <= chance then
		paralyze = true
	end
	
	for i = 1, #area do
		for j = 1, #area[i] do
			local spellPos = {x = pos.x + (j - center), y = pos.y + (i - center), z = pos.z}
			if canAttackTile(pos, spellPos) then
				doAreaCombat(cid, COMBAT_PHYSICALDAMAGE, spellPos, nil, -damage, -damage, CONST_ME_GROUNDSHAKER)
				if paralyze then
					applyTileCondition(cid, spellPos, condition)
				end
			end
		end
	end
	
	return true
end

