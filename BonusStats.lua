function onStatsChange(cid, attacker, type, combat, value)
	if isPlayer(cid) == true and (isCreature(attacker) or isPlayer(attacker)) then

        local playerPos = getCreaturePosition(cid)
        local attackerPos = getCreaturePosition(attacker)
        
		if getPlayerStorageValue(cid,VARIAVEL_ATK_REFLECT) >= 1 then  --- REFLECT
			local reflectPercent = getPlayerStorageValue(cid,VARIAVEL_ATK_REFLECT)
            --print("reflectPercent: "..reflectPercent)
			--dmg = math.ceil(-value*((100-reflectPercent)/100))
            dmg = math.ceil(-value)
            if (dmg < 0) then
                doCreatureAddHealth(cid, dmg)
                doSendAnimatedText(playerPos, -dmg, COLOR_RED)
                doSendMagicEffect(playerPos, 0)
            else
                doSendMagicEffect(playerPos, 3)
            end

            dmg = math.ceil(-(value+(value*(reflectPercent/100))))
            if (dmg < 0) then
                doCreatureAddHealth(attacker, dmg)
                doSendAnimatedText(attackerPos, -dmg, COLOR_RED)
                doSendDistanceShoot(playerPos, attackerPos, CONST_ANI_SMALLHOLY)
                doPlayerSendTextMessage(cid, 27, "You deal "..dmg.." damage to a "..getCreatureName(attacker))
            end
        end

        if getPlayerStorageValue(cid,VARIAVEL_ATK_ABSORB) >= 1 then  --- REFLECT
            local ABSORBPercent = getPlayerStorageValue(cid,VARIAVEL_ATK_ABSORB)
            --print("ABSORBPercent: "..ABSORBPercent)
            ab = math.ceil(-value-(valor*(ABSORBPercent/100)))
            if (ab < 0) then
                doCreatureAddHealth(cid, ab)
                doSendAnimatedText(playerPos, ab, COLOR_BROWN)
                doSendMagicEffect(playerPos, 0)
                doPlayerSendTextMessage(cid, 27, "You absolved "..ab.." damage to a "..getCreatureName(attacker))
            else
                doSendMagicEffect(playerPos, 3)
            end
        end

        if getPlayerStorageValue(cid,VARIAVEL_HP) >= 1 then  --- HP
            local hpPercent = getPlayerStorageValue(cid,VARIAVEL_HP)
            --print("hpPercent: "..hpPercent)
            local y = math.random( 1, 100 )

            if y <= hpPercent then
                --local life = getCreatureMaxHealth(cid)
                --heal = math.ceil(life*(perc/100))
                local x = math.random( 10, 50 )
                doCreatureAddHealth(cid, x)
                doSendAnimatedText(playerPos, x, COLOR_GREEN)
                doSendMagicEffect(playerPos, 0)
                doPlayerSendTextMessage(cid, 27, "You healed "..x.." health.")
                doPlayerSendCancel(cid, "oi")
            end
        end

        if getPlayerStorageValue(cid,VARIAVEL_MP) >= 1 then --- MP
            local mpPercent = getPlayerStorageValue(cid,VARIAVEL_MP)
            --print("mpPercent: "..mpPercent)
            local y = math.random( 1, 100 )

            if y <= mpPercent then
                --local mana = getCreatureMaxHealth(cid)
                --heal = math.ceil(mana*(perc/100))
                local x = math.random( 10, 50 )
                doCreatureAddMana(cid, x)
                doSendAnimatedText(playerPos, x, COLOR_BLUE)
                doSendMagicEffect(playerPos, 0)
                doPlayerSendTextMessage(cid, 27, "You healed "..x.." mana.")
            end
        end

        if getPlayerStorageValue(cid,VARIAVEL_SP) >= 1 then  --- SP
            local spPercent = getPlayerStorageValue(cid,VARIAVEL_SP)
            --print("spPercent: "..spPercent)
            local y = math.random( 1, 100 )

            if y <= spPercent then
                --local sp = getCreatureMaxHealth(cid)
                local x = math.random( 1, 10 )
                doPlayerAddSoul(cid, x)
                doSendAnimatedText(playerPos, x, COLOR_YELLOW)
                doSendMagicEffect(playerPos, 0)
                doPlayerSendTextMessage(cid, 27, "You gained "..x.." sp.")
            end
        end
	end

	return true
end