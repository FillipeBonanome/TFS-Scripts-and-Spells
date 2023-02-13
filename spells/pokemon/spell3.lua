function onCastSpell(cid, var)

	if doCastPokemonSpell(cid, 3) then
		return false
	else
		doSendMagicEffect(cid:getPosition(), CONST_ME_POFF)
		return false
	end
	
end