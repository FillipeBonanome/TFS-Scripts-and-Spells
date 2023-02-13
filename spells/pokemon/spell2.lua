function onCastSpell(cid, var)

	if doCastPokemonSpell(cid, 2) then
		return false
	else
		doSendMagicEffect(cid:getPosition(), CONST_ME_POFF)
		return false
	end
	
end