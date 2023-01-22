--------------------------------------------------------------------- Constantes ---------------------------------------------------------------------

OFFSET_TABLE = {
	[0] = {x = 0, y = -1},
	[1] = {x = 1, y = 0},
	[2] = {x = 0, y = 1},
	[3] = {x = -1, y = 0}
}

CIRCULAR_TABLE = {
	[0] = {x = 0, y = -1},
	[1] = {x = 1, y = -1},
	[2] = {x = 1, y = 0},
	[3] = {x = 1, y = 1},
	[4] = {x = 0, y = 1},
	[5] = {x = -1, y = 1},
	[6] = {x = -1, y = 0},
	[7] = {x = -1, y = -1}
}

WEAPON_ANIMATION_TABLE = {
	[0] = CONST_ANI_LARGEROCK,
	[1] = CONST_ANI_WHIRLWINDSWORD,
	[2] = CONST_ANI_WHIRLWINDCLUB,
	[3] = CONST_ANI_WHIRLWINDAXE,
	[5] = CONST_ANI_ETHEREALSPEAR
}
--------------------------------------------------------------------- Funções Utilitárias ---------------------------------------------------------------------

--[[
*****************************************************************************
	Função --> stepPositions(posA, posB, n)
		- Input: posição A, posição B, valor inteiro n.
		- Output: n posições.
		
	Descrição: Cria n passos entre a posição A e a posição B, para cada passo
	criado é adicionado a table de posições que será retornada no final. 
*****************************************************************************
]]--

function stepPositions(posa, posb, n)
	local positionA = {x = posa.x, y = posa.y, z = posa.z} or nil
	local positionB = {x = posb.x, y = posb.y, z = posb.z} or nil
	local posA = Position(positionA.x, positionA.y, positionA.z)
	local posB = Position(positionB.x, positionB.y, positionB.z)
	local distance = getDistanceBetween(posA, posB)
	
	local positionsLerp = {}
	if positionA and positionB then
		for i = 1, n do
			positionsLerp[i] = {x = positionA.x + math.floor((positionB.x - positionA.x) * (i/distance) + 0.5), y = positionA.y + math.floor((positionB.y - positionA.y) * (i/distance) + 0.5), z = positionA.z}
		end
		return positionsLerp
	else
		return false
	end
end

--[[
*****************************************************************************
	Função --> canAttackTile(position)
		- Input: posição A, posição B
		- Output: booleano
		
	Descrição: Verifica se um tile pode ser "atacado" ou não
*****************************************************************************
]]--

function canAttackTile(positionA, positionB)
	return Tile(positionB) and isSightClear(positionA, positionB) and not Tile(positionB):hasFlag(TILESTATE_PROTECTIONZONE)
end

--[[
*****************************************************************************
	Função --> getPlayerWeaponType(player)
		- Input: Jogador.
		- Output: Valor inteiro que representa o tipo da arma.
		
	Descrição: Checa se existe um item na mão esquerda do jogador, caso
	for verdadeiro é retornado o weaponType do item.
*****************************************************************************
]]--

function getPlayerWeaponType(player)
	local weaponType = 0
	if getPlayerSlotItem(player, CONST_SLOT_LEFT).itemid > 0 then
		local weapon = getPlayerSlotItem(player, CONST_SLOT_LEFT)
		local item = Item(weapon.uid)
		weaponType = item:getType():getWeaponType()
	end
	
	return weaponType
end

--[[
*****************************************************************************
	Função --> getPlayerMainOffensiveSkillValue(player)
		- Input: Jogador
		- Output: Valor da maior skill ofensiva do jogador (fist, sword, axe, club ou ml)
		
	Descrição: Verifica qual é a maior skill do jogador e a retorna
*****************************************************************************
]]--

function getPlayerMainOffensiveSkillValue(player)
	local mainSkill = 0
	
	for i = SKILL_FIST, SKILL_DISTANCE do
		if player:getEffectiveSkillLevel(i) > mainSkill then
			mainSkill = player:getEffectiveSkillLevel(i)
		end
	end
	
	if player:getMagicLevel() > mainSkill then
		mainSkill = player:getMagicLevel()
	end
	
	return mainSkill
	
end

--[[
*****************************************************************************
	Função --> createConditionParalyze(cid, ticks, percentage)
		- Input: Jogador, duração (valor em segundos), porcentagem (valor inteiro entre 0 e 1).
		- Output: Condition de paralyze.
		
	Descrição: Cria uma condição de paralisia que dura ticks segundos e tem
	força de percentage %.
*****************************************************************************
]]--

--[[
*****************************************************************************
	Função --> calculateSpellDamage(player, multiplier, base)
		- Input: Jogador, multiplicador de dano, dano base
		
	Descrição: Calcula o dano de uma spell com variação de 70% a 100% do dano
	com multiplicador e dano base.
*****************************************************************************
]]--

function calculateSpellDamage(player, multiplier, base)

	local skill = getPlayerMainOffensiveSkillValue(player)
	local multiplier = multiplier or 1
	local base = base or 15
	local damage = player:getLevel() / 5 + skill * multiplier + base
	damage = math.random(0.7 * damage, damage)
	
	return damage
	
end

function createConditionParalyze(cid, ticks, percentage)
	local ticks = ticks or 10
	local percentage = percentage or 0.4
	
	local condition = createConditionObject(CONDITION_PARALYZE)
	setConditionParam(condition, CONDITION_PARAM_OWNER, cid)
	setConditionParam(condition, CONDITION_PARAM_TICKS, ticks * 1000)
	setConditionFormula(condition, -percentage, 0, -percentage, 0)
	
	return condition
end

--[[
*****************************************************************************
	Função --> createConditionDamageOverTime(cid, conditionType, ticks, damage, subid, interval)
		- Input: Jogador, tipo de condição (poison, fire, cursed, dazzled, freeze, etc.), 
				 ticks (valor em segundos), damage (dano da condição), subid (subid da condição),
				 interval (intervalo entre os DoTs).
		- Output: Condition de dano.
		
	Descrição: Cria uma condição de dano do tipo conditionType que dura ticks segundos,
	causando damage de dano em um intervalo interval.
*****************************************************************************
]]--

function createConditionDamageOverTime(cid, conditionType, ticks, damage, subid, interval)
	local conditionType = conditionType or CONDITION_FREEZING
	local ticks = ticks or 10
	local damage = damage or 10
	local subid = subid or 0
	local interval = interval or 2000
	
	local condition = createConditionObject(conditionType)
	setConditionParam(condition, CONDITION_PARAM_DELAYED, 1)
	setConditionParam(condition, CONDITION_PARAM_OWNER, cid)
	condition:setParameter(CONDITION_PARAM_SUBID, subid)
	addDamageCondition(condition, ticks, interval, -damage)
	
	return condition
end

--------------------------------------------------------------------- Animações ---------------------------------------------------------------------

--[[
*****************************************************************************
	Função --> createDiamondAnimation(position, start, distance, times)
		- Input: Posição, offset (cima, esquerda, baixo, direita), 
				 animação de distância, quantas animações terá
		- Output: Void
		
	Descrição: Cria uma animação em formato de diamante que o percorre em
	sentido horário.
*****************************************************************************
]]--

function createDiamondAnimation(position, start, distance, times)
	local pos = {x = position.x, y = position.y, z = position.z}
	local start = start or 0
	local distance = distance or CONST_ANI_SUDDENDEATH
	local times = times or 8
	local offset = OFFSET_TABLE
	
	local posStart = {x = pos.x + offset[start % 4].x, y = pos.y + offset[start % 4].y, z = pos.z}
	
	
	for i = 1, times do
		addEvent(function()
			local posEnd = {x = pos.x + offset[(start + 1) % 4].x, y = pos.y + offset[(start + 1) % 4].y, z = pos.z}
			doSendDistanceShoot(posStart, posEnd, distance)
			posStart = posEnd
			start = start + 1
		end, (i - 1) * 120)
	end
	
end

--[[
*****************************************************************************
	Função --> createImplosionAnimation(position, distance)
		- Input: Posição, animação de distance
		- Output: Void
		
	Descrição: Cria 8 animações de distance em volta da posição com destino
	ao centro.
*****************************************************************************
]]--

function createImplosionAnimation(position, distance)

	local offset = CIRCULAR_TABLE
	
	for i = 1, #offset do
		local initPos = {x = position.x + offset[i].x, y = position.y + offset[i].y, z = position.z}
		doSendDistanceShoot(initPos, position, distance or CONST_ANI_SMALLHOLY)
	end
end

--------------------------------------------------------------------- Storage for Monsters ---------------------------------------------------------------------
MONSTER_STORAGE = MONSTER_STORAGE or {}

function Monster.setStorageValue(self, key, value)
    local cid = self:getId()
    local storageMap = MONSTER_STORAGE[cid]
    if not storageMap then
        MONSTER_STORAGE[cid] = {[key] = value}
    else
        storageMap[key] = value
    end
end

function Monster.getStorageValue(self, key)
    local storageMap = MONSTER_STORAGE[self:getId()]
    if storageMap then
        return storageMap[key] or 0
    end
    return 0
end