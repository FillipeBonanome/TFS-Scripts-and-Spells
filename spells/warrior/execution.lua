--[[
*****************************************************************************
	Magia --> Execution
		
	Descrição: Ataca o alvo com dano de físico, quanto menos a vida do seu
	alvo maior o dano da magia (Máx. 400%)
*****************************************************************************
]]--

function onCastSpell(cid, var)
	local animation = WEAPON_ANIMATION_TABLE[getPlayerWeaponType(cid)]
	local target = cid:getTarget()
	local tPHealth = target:getHealth() / target:getMaxHealth()
	local tPos = target:getPosition()
	
	local damage = calculateSpellDamage(cid, 1.8, 35) * (1 + (1 - tPHealth) * 4)
	
	local offsets = {
		[1] = {x = 1, y = -1},
		[2] = {x = 1, y = 1},
		[3] = {x = -1, y = 1},
		[4] = {x = -1, y = -1}
	}
	
	for i = 1, #offsets do
		local aniPos = {x = tPos.x + offsets[i].x, y = tPos.y + offsets[i].y, z = tPos.z}
		doSendDistanceShoot(aniPos, tPos, CONST_ANI_WHIRLWINDSWORD)
	end
	
	doTargetCombat(cid, target, COMBAT_PHYSICALDAMAGE, -damage, -damage)
	
	return true
end

