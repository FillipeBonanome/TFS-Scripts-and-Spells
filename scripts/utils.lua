--------------------------------------------------------------------- Constantes ---------------------------------------------------------------------

GLOBAL_STORAGEBUFFID = 100500
GLOBAL_STORAGEBUFFTIMER = 100501

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
	Função --> findfunction(x)
		- Input: Nome da função
		- Output: Função
		
	Descrição: Retorna uma função com nome x
*****************************************************************************
]]--

function findfunction(x)
	assert(type(x) == "string")
	local f=_G
	for v in x:gmatch("[^%.]+") do
		if type(f) ~= "table" then
			return nil, "looking for '"..v.."' expected table, not "..type(f)
		end
    f=f[v]
    end
    if type(f) == "function" then
      return f
    else
      return nil, "expected function, not "..type(f)
    end
end

--[[
*****************************************************************************
	Função --> isCreatureUnholy(creature)
		- Input: Criatura
		- Output: Booleano
		
	Descrição: Verifica se uma criatura é do  tipo Undead ou Fire
*****************************************************************************
]]--

function isCreatureUnholy(creature)
	return isMonster(creature) and (creature:getType():race() == 3 or creature:getType():race() == 4)
end

--[[
*****************************************************************************
	Função --> getItemAttribute(uid, key)
		- Input: UniqueId e Atributo
		- Output: Valor do atributo
		
	Descrição: Pega um atributo de um item já que item:getAttribute(valor)
	não funciona muito bem
*****************************************************************************
]]--

function getItemAttribute(uid, key)
    local i = ItemType(Item(uid):getId())
    local string_attributes = {
    [ITEM_ATTRIBUTE_NAME] = i:getName(),
    [ITEM_ATTRIBUTE_ARTICLE] = i:getArticle(),
    [ITEM_ATTRIBUTE_PLURALNAME] = i:getPluralName(),
    ["name"] = i:getName(),
    ["article"] = i:getArticle(),
    ["pluralname"] = i:getPluralName() }

    local numeric_attributes = {
    [ITEM_ATTRIBUTE_WEIGHT] = i:getWeight(),
    [ITEM_ATTRIBUTE_ATTACK] = i:getAttack(),
    [ITEM_ATTRIBUTE_DEFENSE] = i:getDefense(),
    [ITEM_ATTRIBUTE_EXTRADEFENSE] = i:getExtraDefense(),
    [ITEM_ATTRIBUTE_ARMOR] = i:getArmor(),
    [ITEM_ATTRIBUTE_HITCHANCE] = i:getHitChance(),
    [ITEM_ATTRIBUTE_SHOOTRANGE] = i:getShootRange(),
    ["weight"] = i:getWeight(),
    ["attack"] = i:getAttack(),
    ["defense"] = i:getDefense(),
    ["extradefense"] = i:getExtraDefense(),
    ["armor"] = i:getArmor(),
    ["hitchance"] = i:getHitChance(),
    ["shootrange"] = i:getShootRange() }

    local attr = Item(uid):getAttribute(key)
    if tonumber(attr) then
        if numeric_attributes[key] then
            return attr ~= 0 and attr or numeric_attributes[key]
        end
    else
        if string_attributes[key] then
            if attr == "" then
                return string_attributes[key]
            end
        end
    end
    return attr
end

--[[
*****************************************************************************
	Função --> getPlayerTotalAttribute(player, attribute, ammo)
		- Input: Jogador, atributo e um booleano se vai contar a munição ou não
		- Output: Soma de atributos encontrados nos itens do jogador
		
	Descrição: Verifica cada parte do corpo do jogador e pega um atributo em
	específico para somar no final e dar o resultado total.
*****************************************************************************
]]--

function getPlayerTotalAttribute(player, attribute, ammo)
	local value = 0
	local last = 9
	
	if ammo then
		last = 10
	end
	
	for i = 1, last do
		if player:getSlotItem(i) then
			local item = player:getSlotItem(i)
			value = value + getItemAttribute(item.uid, attribute)
		end
	end
	
	return value
end

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
	Função --> canAttackTile(positionA, positionB)
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
	Função --> canPlayerAttackCreature(player, creature)
		- Input: Jogador e alvo
		- Output: booleano
		
	Descrição: Verifica se o jogador pode ou não atacar a criatura
*****************************************************************************
]]--

function canPlayerAttackCreature(player, creature)
	if creature == player then
		return false
	end
	
	if isPlayer(creature) then
		if isPlayer(creature) and creature:getParty() ~= nil and creature:getParty() == player:getParty() then
			return false
		end
	end
	
	if isSummon(creature) then
		if isPlayer(creature:getMaster()) and creature:getMaster():getParty() ~= nil and creature:getMaster():getParty() == player:getParty() then
			return false
		end
		
		if player == creature:getMaster() then
			return false
		end
	end
	
	return true
end

--[[
*****************************************************************************
	Função --> getAttacklableCreaturesInPosition(player, position)
		- Input: Jogador e posição
		- Output: lista de criaturas
		
	Descrição: Retorna uma lista de criaturas atacáveis pelo jogador que estão
	em uma certa posição.
*****************************************************************************
]]--

function getAttacklableCreaturesInPosition(player, position)
	local creatureList = {}

	if Tile(position):getCreatureCount() > 0 then
		for _, creatures in ipairs(Tile(position):getCreatures()) do
			if canPlayerAttackCreature(player, creatures) then
				table.insert(creatureList, creatures)
			end
		end
	end
	
	return creatureList
end

--[[
*****************************************************************************
	Função --> getAttackableCreaturesInArea(cid, pos, size)
		- Input: Jogador, Posição, Tamanho
		- Output: Lista de criaturas atacáveis
		
	Descrição: Pega a lista de criaturas atacáveis numa distância de até
	size em volta da posição pos.
*****************************************************************************
]]--

function getAttackableCreaturesInArea(cid, pos, size)
	
	local array = {}

	for i = -size, size do
		for j = -size, size do
			local spellPos = {x = pos.x + j, y = pos.y + i, z = pos.z}
			if canAttackTile(cid:getPosition(), spellPos) and (i ~= 0 or j ~= 0) then
				local creatures = getAttacklableCreaturesInPosition(cid, spellPos)
				for k = 1, #creatures do
					local creature = creatures[k]
					table.insert(array, creature)
				end
			end
		end
	end
	
	return array
end

--[[
*****************************************************************************
	Função --> simpleMeleePlayerTargetPushOver(player, target)
		- Input: Jogador e alvo.
		- Output: Booleano
		
	Descrição: Empurra o alvo se possível, caso empurrar possui retorno ver-
	dadeiro, caso contrário falso.
*****************************************************************************
]]--

function simpleMeleePlayerTargetPushOver(player, target)
	local pPos = player:getPosition()
	local tPos = target:getPosition()
	
	local offset = CIRCULAR_TABLE
	local index = 0
	
	for i = 1, #offset do
		local offsetArray = offset[i]
		local checkPPos = {x = pPos.x + offsetArray.x, y = pPos.y + offsetArray.y, z = pPos.z}
		local checkTPos = {x = tPos.x, y = tPos.y, z = tPos.z}
		
		if checkPPos.x == checkTPos.x and checkPPos.y == checkTPos.y then
			index = i
			break
		end
		
	end
	
	local newPos = {x = tPos.x + offset[index].x, y = tPos.y + offset[index].y, z = tPos.z}
	
	if Tile(newPos):getCreatureCount() > 0 or Tile(newPos):hasFlag(TILESTATE_BLOCKSOLID) then
		return false
	else
		target:teleportTo(newPos, true)
		return true
	end
	
end

--[[
*****************************************************************************
	Função --> bounceOnContact(cid, targetPos, damage, multiplier, bounces, animation, element)
		- Input: Jogador, posição do alvo, dano, multiplicador, quiques, animação e elemento do dano.
		- Output: void.
		
	Descrição: Faz com que gere uma faísca do alvo, fazendo que ela quique em
	vários outros em sua volta
*****************************************************************************
]]--

function bounceOnContact(cid, targetPos, damage, multiplier, bounces, animation, element, lastTarget)
	if bounces > 0 and Creature(cid) then
		local player = Creature(cid)
		--local target = Creature(target)
		local size = 2
		local pos = targetPos
		local animation = animation or CONST_ANI_ENERGYBALL
		local element = element or COMBAT_ENERGYDAMAGE
		local cArray = {}
		
		for i = -size, size do
			for j = -size, size do
				local spellPos = {x = pos.x + i, y = pos.y + j, z = pos.z}
				if Tile(spellPos) and isSightClear(spellPos, pos) then
					if Tile(spellPos):getCreatureCount() > 0 then
						for _, creatures in ipairs(Tile(spellPos):getCreatures()) do
							if canPlayerAttackCreature(player, creatures) and creatures ~= lastTarget then
								table.insert(cArray, creatures)
							end
						end
					end
				end
			end
		end
		
		if #cArray > 0 then
			local creature = cArray[math.random(#cArray)]
			local bounces = bounces - 1
			local damage = damage * multiplier
			
			if Creature(creature) then
				local cPos = creature:getPosition()
				doSendDistanceShoot(targetPos, cPos, animation)
				doTargetCombat(player, creature, element, -damage, -damage)
				lastTarget = Creature(creature)
				addEvent(function(cid) 
					if Creature(cid) then
						local player = Creature(cid)
						bounceOnContact(player, cPos, damage, multiplier, bounces, animation, element, lastTarget)
					end
				end, 150, player:getId())
				
			end
		end
		
	end
end

--[[
*****************************************************************************
	Função --> spreadOnContact(cid, pos, damage, multiplier, size, element, animation)
		- Input: Jogador, posição do alvo, dano, multiplicador, tamanho, elemento e animação
		- Output: void.
		
	Descrição: Faz com que a sua magia se espalhe em alvos próximos causando
	uma porcentagem de dano.
*****************************************************************************
]]--

function spreadOnContact(cid, pos, damage, multiplier, size, element, animation)
	local pos = pos or cid:getPosition()
	local damage = damage or 10
	local multiplier = multiplier or 0.5
	local size = size or 2
	local element = element or COMBAT_ENERGYDAMAGE
	local animation = animation or CONST_ANI_ENERGY
	
	local creatures = getAttackableCreaturesInArea(cid, pos, size)
	
	if Tile(pos):getCreatureCount() > 0 then
		addEvent(function(cid) 
			if Creature(cid) then
				local cid = Creature(cid)
				for i = 1, #creatures do
					local creature = creatures[i]
					if Creature(creature) then
						local cPos = creature:getPosition()
						doSendDistanceShoot(pos, cPos, animation)
						doTargetCombat(cid, creature, element, -damage * multiplier, -damage * multiplier)
					end
				end
			end
		end, 150, cid:getId())
	end
end

--[[
*****************************************************************************
	Função --> createSimpleExplosion(cid, pos, area, damage, element, animation)
		- Input: Jogador, Posição, Matriz, Dano, Elemento e Animação
		- Output: void.
		
	Descrição: Cria uma área de dano igual a area com animação e elemento
	específico
*****************************************************************************
]]--

function createSimpleExplosion(cid, pos, area, damage, element, animation)
	local pos = pos or cid:getPosition()
	local area = area or {{1,1,1},{1,1,1},{1,1,1}}
	local damage = damage or 10
	local element = element or COMBAT_ENERGYDAMAGE
	local animation = animation or CONST_ME_TELEPORT
	
	local center = math.ceil(#area/2)
	
	for i = 1, #area do
		for j = 1, #area do
			if area[i][j] > 0 then
				local spellPos = {x = pos.x + (j - center), y = pos.y + (i - center), z = pos.z}
				if canAttackTile(cid:getPosition(), spellPos) then
					doAreaCombat(cid, element, spellPos, nil, -damage, -damage, animation)
				end
			end
		end
	end
	
end

--[[
*****************************************************************************
	Função --> createSimpleExplosion(cid, pos, area, damage, element, animation, condition)
		- Input: Jogador, Posição, Matriz, Dano, Elemento, Animação e Condição
		- Output: void.
		
	Descrição: Cria uma área de dano igual a area com animação e elemento
	específico, aplicando condição em todos os alvos atingidos pela magia
*****************************************************************************
]]--

function createSimpleExplosionCondition(cid, pos, area, damage, element, animation, condition)
	local pos = pos or cid:getPosition()
	local area = area or {{1,1,1},{1,1,1},{1,1,1}}
	local damage = damage or 10
	local element = element or COMBAT_ENERGYDAMAGE
	local animation = animation or CONST_ME_TELEPORT
	
	local center = math.ceil(#area/2)
	
	for i = 1, #area do
		for j = 1, #area do
			if area[i][j] > 0 then
				local spellPos = {x = pos.x + (j - center), y = pos.y + (i - center), z = pos.z}
				if canAttackTile(cid:getPosition(), spellPos) then
					doAreaCombat(cid, element, spellPos, nil, -damage, -damage, animation)
					if condition then
						applyTileCondition(cid, spellPos, condition)
					end
				end
			end
		end
	end
end

--[[
*****************************************************************************
	Função --> createExplosiveTrap(cid, pos, area, damage, element, trapAnimation, hitAnimation, duration)
		- Input: Jogador, Posição, Area da Explosão, Dano da Explosão, Elemento, Animação da Trap, Animação da Explosão, Duração da Trap
		- Output: void.
		
	Descrição: Cria uma armadilha em uma posição onde é ativada caso um inimigo
	pisar em cima
*****************************************************************************
]]--

function createExplosiveTrap(cid, pos, area, damage, element, trapAnimation, hitAnimation, duration)
	local pos = pos or cid:getPosition()
	local area = area or {{1,1,1},{1,1,1},{1,1,1}}
	local damage = damage or 15
	local element = element or COMBAT_PHYSICALDAMAGE
	local trapAnimation = trapAnimation or CONST_ME_EXPLOSIONAREA
	local hitAnimation = hitAnimation or CONST_ME_EXPLOSIONHIT
	local duration = duration or 8
	local checkTimes = 10
	local event = {}
	
	for i = 1, checkTimes * duration do
		table.insert(event, addEvent(function(cid) 
			if Creature(cid) then
				local cid = Creature(cid)
				
				if i % 5 == 1 then
					doSendMagicEffect(pos, trapAnimation)
				end
				
				if #getAttacklableCreaturesInPosition(cid, pos) > 0 then
					for j = 1, #event do
						local ev = event[j]
						stopEvent(ev)
					end
					
					createSimpleExplosion(cid, pos, area, damage, element, hitAnimation)
					
				end
				
			end
		end, (i - 1) * 1000 / checkTimes, cid:getId()))
	end
	
end

--[[
*****************************************************************************
	Função --> createContinuousTrap(cid, pos, element, damage, animation, condition, duration)
		- Input: Jogador, Posição, Elemento, Dano, Animação da Trap, Animação da Trap, Condição aplicada no inimigo, Duração da Trap
		- Output: void.
		
	Descrição: Cria uma armadilha contínua que não é desativada quando um inimigo
	pisa nela, mas causa algum dano + condition continuamente.
*****************************************************************************
]]--

function createContinuousTrap(cid, pos, element, damage, animation, condition, duration)
	local pos = pos or cid:getPosition()
	local element = element or COMBAT_PHYSICALDAMAGE
	local damage = damage or 10
	local animation = animation or CONST_ME_HITAREA
	local condition = condition or false
	local duration = duration or 8
	local checkTimes = 5
	local event = {}
	
	for i = 1, checkTimes * duration do
		table.insert(event, addEvent(function(cid) 
			if Creature(cid) then
				local cid = Creature(cid)
				
				if i % 5 == 1 then
					doSendMagicEffect(pos, animation)
				end
				
				if #getAttacklableCreaturesInPosition(cid, pos) > 0 then
					local creatures = getAttacklableCreaturesInPosition(cid, pos)
					
					for j = 1, #creatures do
						local creature = creatures[j]
						doTargetCombat(cid, creature, element, -damage, -damage)
						if condition then
							creature:addCondition(condition)
						end
					end
					
				end
				
			end
		end, (i - 1) * 1000 / checkTimes, cid:getId()))
	end
end

--[[
*****************************************************************************
	Função --> createCycloneAttack(cid, pos, element, distance, animation, rotations, damage, delay, posAnimation)
		- Input: Jogador, Posição, Elemento, Animação de Distância, Animação de Posição, Quantidade de Rotações, Dano, Delay entr cada Hit e Animação no Centro
		- Output: void.
		
	Descrição: Cria um vórtice que ataca inimigos em sua volta em sentido horário
	repetidas vezes.
*****************************************************************************
]]--

function createCycloneAttack(cid, pos, element, distance, animation, rotations, damage, delay, posAnimation)
	local pos = pos or cid:getPosition()
	local element = element or COMBAT_ENERGYDAMAGE
	local distance = distance or CONST_ANI_ENERGY
	local animation = animation or CONST_ME_ENERGYHIT
	local rotations = rotations or 4
	local damage = damage or 10
	local delay = delay or 150
	
	local offsets = CIRCULAR_TABLE
	
	for i = 1, #offsets * rotations do
		addEvent(function(cid) 
			if Creature(cid) then
				local cid = Creature(cid)
				local index = i % 8
				local offset = offsets[index]
				local spellPos = {x = pos.x + offset.x, y = pos.y + offset.y, z = pos.z}
				
				if i % 4 == 0 and posAnimation then
					doSendMagicEffect(pos, posAnimation)
				end
				
				if canAttackTile(pos, spellPos) then
					doSendDistanceShoot(pos, spellPos, distance)
					doSendMagicEffect(spellPos, animation)
					
					local creatures = getAttacklableCreaturesInPosition(cid, spellPos)
					
					for i = 1, #creatures do
						local creature = creatures[i]
						doTargetCombat(cid, creature, element, -damage, -damage)
					end
					
					if index == 1 then
						local creatures = getAttacklableCreaturesInPosition(cid, pos)
						
						for i = 1, #creatures do
							local creature = creatures[i]
							doTargetCombat(cid, creature, element, -damage, -damage)
						end
					end
					
				end
			end
		end, (i - 1) * delay, cid:getId())
		
	end
	
end

--[[
*****************************************************************************
	Função --> createFixedRain(cid, pos, elements, distances, animations, minDamage, maxDamage, size, duration, frequency)
		- Input: Jogador, Posição, Elementos, Animações de Distancia, Animações de Contato, Dano Mínimo, Dano Máximo, Tamanho, Duração e Frequencia
		- Output: void.
		
	Descrição: Cria uma chuva de tamanho size, com duração duration e que cai frequency pingos por segundo.
	Causa dano nos elementos elements aleatoriamente, separando cada distance e animations referindo ao elements aleatorizado.
*****************************************************************************
]]--

function createFixedRain(cid, pos, elements, distances, animations, minDamage, maxDamage, size, duration, frequency)
	local pos = pos or cid:getPosition()
	local elements = elements or {COMBAT_FIREDAMAGE}
	local distances = distances or {CONST_ANI_FIRE}
	local animations = animations or {CONST_ME_FIREAREA}
	local minDamage = minDamage or 10
	local maxDamage = maxDamage or 25
	local size = size or 3
	local duration = duration or 8
	local frequency = frequency or 20
	
	
	for i = 1, duration * frequency do
		addEvent(function(cid) 
		
			if Creature(cid) then
				local cid = Creature(cid)
				local randomOffset = {x = math.random(-size, size), y = math.random(-size, size)}
				local spellPos = {x = pos.x + randomOffset.x, y = pos.y + randomOffset.y, z = pos.z}
				
				if canAttackTile(pos, spellPos) then
					local initPos = {x = spellPos.x - 5, y = spellPos.y - 8, z = spellPos.z}
					local randomElementIndex = math.random(math.min(#elements, #distances, #animations))
					doSendDistanceShoot(initPos, spellPos, distances[randomElementIndex])
					doSendMagicEffect(spellPos, animations[randomElementIndex])
					
					local damage = math.random(minDamage, maxDamage)
					
					if Tile(spellPos):getCreatureCount() > 0 then
						for _, creatures in ipairs(Tile(spellPos):getCreatures()) do
							if canPlayerAttackCreature(cid, creatures) then
								doTargetCombat(cid, creatures, elements[randomElementIndex], -damage, -damage)
							end
						end
					end
					
				end
				
			end
		
		end, i * 1000 / frequency, cid:getId())
	end
	
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

--[[
*****************************************************************************
	Função --> createConditionParalyze(cid, ticks, percentage)
		- Input: Jogador, duração (valor em segundos), porcentagem (valor inteiro entre 0 e 1).
		- Output: Condition de paralyze.
		
	Descrição: Cria uma condição de paralisia que dura ticks segundos e tem
	força de percentage %.
*****************************************************************************
]]--

function createConditionParalyze(cid, ticks, percentage)
	local ticks = ticks or 10
	local percentage = percentage or 0.4
	
	local condition = createConditionObject(CONDITION_PARALYZE)
	setConditionParam(condition, CONDITION_PARAM_OWNER, cid:getId())
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
	setConditionParam(condition, CONDITION_PARAM_OWNER, cid:getId())
	condition:setParameter(CONDITION_PARAM_SUBID, subid)
	addDamageCondition(condition, ticks, interval, -damage)
	
	return condition
end

--[[
*****************************************************************************
	Função --> applyTileCondition(player, position, condition)
		- Input: Jogador, posição e condição
		- Output: Condition de dano.
		
	Descrição: Aplica uma condition em todos os inimigos que podem ser ataca-
	dos pelos jogador em um devido Tile.
*****************************************************************************
]]--

function applyTileCondition(player, position, condition)
	if Tile(position) and Tile(position):getCreatureCount() > 0 then
		for _, creatures in ipairs(Tile(position):getCreatures()) do
			if canPlayerAttackCreature(player, creatures) then
				creatures:addCondition(condition)
			end
		end
	end
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
	Função --> targetDiamondAnimation(target, start, animation, times)
		- Input: Target, offset (cima, esquerda, baixo, direita), 
				 animação de distância, quantas animações terá
		- Output: Void
		
	Descrição: Cria uma animação em formato de diamante que o percorre em
	sentido horário em volta de um alvo.
*****************************************************************************
]]--

function targetDiamondAnimation(target, start, animation, times)
	
	local start = start or 0
	local animation = animation or CONST_ANI_SUDDENDEATH
	local times = times or 8
	
	local offset = {
		[0] = {x = 0, y = -1},
		[1] = {x = 1, y = 0},
		[2] = {x = 0, y = 1},
		[3] = {x = -1, y = 0}
	}
	
	
	local posStart = nil
	
	for i = 1, times do
		addEvent(function(tar)
			if Creature(tar) then
				local target = Creature(tar)
				local pos = target:getPosition()
				if i == 1 then
					posStart = {x = pos.x + offset[start % 4].x, y = pos.y + offset[start % 4].y, z = pos.z}
				end
				local posEnd = {x = pos.x + offset[(start + 1) % 4].x, y = pos.y + offset[(start + 1) % 4].y, z = pos.z}
				doSendDistanceShoot(posStart, posEnd, animation)
				posStart = posEnd
				start = start + 1
			end
		end, (i - 1) * 120, target:getId())
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
	
	for i = 0, #offset do
		local initPos = {x = position.x + offset[i].x, y = position.y + offset[i].y, z = position.z}
		doSendDistanceShoot(initPos, position, distance or CONST_ANI_SMALLHOLY)
	end
end

--[[
*****************************************************************************
	Função --> doSendMagicEffectRandomDelay(pos, effect, minDelay, maxDelay)
		- Input: Posição, Efeito, Delay mínimo, Delay máximo
		- Output: Void
		
	Descrição: Cria uma animação em uma posição em um intervalo aleatório entre
	minDelay e maxDelay
*****************************************************************************
]]--

function doSendMagicEffectRandomDelay(pos, effect, minDelay, maxDelay)

	local effect = effect or CONST_ME_MAGIC_RED
	local minDelay = minDelay or 0
	local maxDelay = maxDelay or 500

	addEvent(function() 
		doSendMagicEffect(pos, effect)
	end, math.random(minDelay, maxDelay))
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