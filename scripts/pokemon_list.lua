POKEMON_LIST = {
	["Hero"] = {
		health = 1400,
		healthPerLevel = 35,
		attack = 75,
		defense = 50,
		spAttack = 35,
		spDefense = 50,
		speed = 60,
		type = {"normal", "fightning"},
		moves = {
			[1] = {name = "Sword Slash", type = "fighting", cd = 4, target = true, range = 1, combat = "physical", f = "swordSlash"},
			[2] = {name = "Radial Cut", type = "fighting", cd = 6, target = false, range = 0, combat = "physical", f = "radialCut"},
			[3] = {name = "Last Stand", type = "Normal", cd = 30, target = false, range = 0, combat = "physical", f = "lastStand"},
		}
	}
}


function doCastPokemonSpell(cid, number)
	local pokemons = cid:getSummons()
	local pokemon = pokemons[1]
	
	local pokeInfo = POKEMON_LIST[pokemon:getName()]
	
	if pokeInfo.moves[number] then
		local move = pokeInfo.moves[number]
		local canCast = true
		
		if move.target then
			if not pokemon:getTarget() then
				cid:sendCancelMessage("You need a target to cast " .. move.name)
				canCast = false
			else
				if getDistanceBetween(pokemon:getPosition(), pokemon:getTarget():getPosition()) > move.range then
					cid:sendCancelMessage("Target is too far away from your pokemon")
					canCast = false
				end
			end
		end
		
		
		if canCast then
			if pokemon:getStorageValue(300 + number) <= os.time() then
				pokemon:setStorageValue(300 + number, os.time() + move.cd)
				local func = findfunction(pokeInfo.moves[number].f)
				func(pokemon)
				local spellName = pokeInfo.moves[number].name
				doCreatureSay(cid, pokemon:getName() .. ", use " .. spellName, TALKTYPE_ORANGE_1)
				doCreatureSay(pokemon, tostring(spellName):upper() .. "!", TALKTYPE_ORANGE_1)
				return true
			else
				cid:sendCancelMessage(pokeInfo.moves[number].name .. " is on cooldown for " .. pokemon:getStorageValue(300 + number) - os.time() .. " seconds")
				return false
			end
			
		else
			return false
		end
		
	else
		return false
	end
end