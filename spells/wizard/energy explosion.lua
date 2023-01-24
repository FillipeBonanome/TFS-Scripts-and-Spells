--[[
*****************************************************************************
	Magia --> Energy Explosion
		
	Descrição: Causa uma explosão de área 4 em volta do caster
*****************************************************************************
]]--

function onCastSpell(cid, var)
	
	local area = {
		{0,0,1,1,1,0,0},
		{0,1,1,1,1,1,0},
		{1,1,1,1,1,1,1},
		{1,1,1,1,1,1,1},
		{1,1,1,1,1,1,1},
		{0,1,1,1,1,1,0},
		{0,0,1,1,1,0,0}
	}
	
	local damage = calculateSpellDamage(cid, 2.85, 85)
	local element = COMBAT_ENERGYDAMAGE
	local animation = CONST_ME_ENERGYHIT
	local condition = createConditionDamageOverTime(cid, CONDITION_ENERGY, 2, damage * 0.1, subid, 1000)
	
	createSimpleExplosionCondition(cid, pos, area, damage, element, animation, condition)
	
	return true
end

