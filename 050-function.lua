function doPlayerGiveItem(cid, itemid, amount, subType)
	local item = 0
	if(isItemStackable(itemid)) then
		item = doCreateItemEx(itemid, amount)
		if(doPlayerAddItemEx(cid, item, true) ~= RETURNVALUE_NOERROR) then
			return false
		end
	else
		for i = 1, amount do
			item = doCreateItemEx(itemid, subType)
			if(doPlayerAddItemEx(cid, item, true) ~= RETURNVALUE_NOERROR) then
				return false
			end
		end
	end

	return true
end

function doPlayerGiveItemContainer(cid, containerid, itemid, amount, subType)
	for i = 1, amount do
		local container = doCreateItemEx(containerid, 1)
		for x = 1, getContainerCapById(containerid) do
			doAddContainerItem(container, itemid, subType)
		end

		if(doPlayerAddItemEx(cid, container, true) ~= RETURNVALUE_NOERROR) then
			return false
		end
	end

	return true
end

function doPlayerTakeItem(cid, itemid, amount)
	return getPlayerItemCount(cid, itemid) >= amount and doPlayerRemoveItem(cid, itemid, amount)
end

function doPlayerBuyItem(cid, itemid, count, cost, charges)
	return doPlayerRemoveMoney(cid, cost) and doPlayerGiveItem(cid, itemid, count, charges)
end

function doPlayerBuyItemContainer(cid, containerid, itemid, count, cost, charges)
	return doPlayerRemoveMoney(cid, cost) and doPlayerGiveItemContainer(cid, containerid, itemid, count, charges)
end

function doPlayerSellItem(cid, itemid, count, cost)
	if(not doPlayerTakeItem(cid, itemid, count)) then
		return false
	end

	if(not doPlayerAddMoney(cid, cost)) then
		error('[doPlayerSellItem] Could not add money to: ' .. getPlayerName(cid) .. ' (' .. cost .. 'gp).')
	end

	return true
end

function doPlayerWithdrawMoney(cid, amount)
	if(not getBooleanFromString(getConfigInfo('bankSystem'))) then
		return false
	end

	local balance = getPlayerBalance(cid)
	if(amount > balance or not doPlayerAddMoney(cid, amount)) then
		return false
	end

	doPlayerSetBalance(cid, balance - amount)
	return true
end

function doPlayerDepositMoney(cid, amount)
	if(not getBooleanFromString(getConfigInfo('bankSystem'))) then
		return false
	end

	if(not doPlayerRemoveMoney(cid, amount)) then
		return false
	end

	doPlayerSetBalance(cid, getPlayerBalance(cid) + amount)
	return true
end

function doPlayerAddStamina(cid, minutes)
	return doPlayerSetStamina(cid, getPlayerStamina(cid) + minutes)
end

function isPremium(cid)
	return (isPlayer(cid) and (getPlayerPremiumDays(cid) > 0 or getBooleanFromString(getConfigValue('freePremium'))))
end

function getMonthDayEnding(day)
	if(day == "01" or day == "21" or day == "31") then
		return "st"
	elseif(day == "02" or day == "22") then
		return "nd"
	elseif(day == "03" or day == "23") then
		return "rd"
	end

	return "th"
end

function getMonthString(m)
	return os.date("%B", os.time{year = 1970, month = m, day = 1})
end

function getArticle(str)
	return str:find("[AaEeIiOoUuYy]") == 1 and "an" or "a"
end

function isNumeric(str)
	return tonumber(str) ~= nil
end

function doNumberFormat(i)
	local str, found = string.gsub(i, "(%d)(%d%d%d)$", "%1,%2", 1), 0
	repeat
		str, found = string.gsub(ret, "(%d)(%d%d%d),", "%1,%2,", 1)
	until found == 0
	return str
end

function doPlayerAddAddons(cid, addon)
	for i = 0, table.maxn(maleOutfits) do
		doPlayerAddOutfit(cid, maleOutfits[i], addon)
	end

	for i = 0, table.maxn(femaleOutfits) do
		doPlayerAddOutfit(cid, femaleOutfits[i], addon)
	end
end

function doPlayerWithdrawAllMoney(cid)
	return doPlayerWithdrawMoney(cid, getPlayerBalance(cid))
end

function doPlayerDepositAllMoney(cid)
	return doPlayerDepositMoney(cid, getPlayerMoney(cid))
end

function doPlayerTransferAllMoneyTo(cid, target)
	return doPlayerTransferMoneyTo(cid, target, getPlayerBalance(cid))
end

function playerExists(name)
	return getPlayerGUIDByName(name) ~= nil
end

function getTibiaTime()
	local minutes, hours = getWorldTime(), 0
	while (minutes > 60) do
		hours = hours + 1
		minutes = minutes - 60
	end

	return {hours = hours, minutes = minutes}
end

function doWriteLogFile(file, text)
	local f = io.open(file, "a+")
	if(not f) then
		return false
	end

	f:write("[" .. os.date("%d/%m/%Y %H:%M:%S") .. "] " .. text .. "\n")
	f:close()
	return true
end

function getExperienceForLevel(lv)
	lv = lv - 1
	return ((50 * lv * lv * lv) - (150 * lv * lv) + (400 * lv)) / 3
end

function doMutePlayer(cid, time)
	local condition = createConditionObject(CONDITION_MUTED)
	setConditionParam(condition, CONDITION_PARAM_TICKS, time * 1000)
	return doAddCondition(cid, condition)
end

function getPlayerGroupName(cid)
	return getGroupInfo(getPlayerGroupId(cid)).name
end

function getPlayerVocationName(cid)
	return getVocationInfo(getPlayerVocation(cid)).name
end

function getPromotedVocation(vid)
	return getVocationInfo(vid).promotedVocation
end

function doPlayerRemovePremiumDays(cid, days)
	return doPlayerAddPremiumDays(cid, -days)
end

function getPlayerMasterPos(cid)
	return getTownTemplePosition(getPlayerTown(cid))
end

function getHouseOwner(houseId)
	return getHouseInfo(houseId).owner
end

function getHouseName(houseId)
	return getHouseInfo(houseId).name
end

function getHouseEntry(houseId)
	return getHouseInfo(houseId).entry
end

function getHouseRent(houseId)
	return getHouseInfo(houseId).rent
end

function getHousePrice(houseId)
	return getHouseInfo(houseId).price
end

function getHouseTown(houseId)
	return getHouseInfo(houseId).town
end

function getHouseDoorsCount(houseId)
	return table.maxn(getHouseInfo(houseId).doors)
end

function getHouseBedsCount(houseId)
	return table.maxn(getHouseInfo(houseId).beds)
end

function getHouseTilesCount(houseId)
	return table.maxn(getHouseInfo(houseId).tiles)
end

function getItemNameById(itemid)
	return getItemDescriptionsById(itemid).name
end

function getItemPluralNameById(itemid)
	return getItemDescriptionsById(itemid).plural
end

function getItemArticleById(itemid)
	return getItemDescriptionsById(itemid).article
end

function getItemName(uid)
	return getItemDescriptions(uid).name
end

function getItemPluralName(uid)
	return getItemDescriptions(uid).plural
end

function getItemArticle(uid)
	return getItemDescriptions(uid).article
end

function getItemText(uid)
	return getItemDescriptions(uid).text
end

function getItemSpecialDescription(uid)
	return getItemDescriptions(uid).special
end

function getItemWriter(uid)
	return getItemDescriptions(uid).writer
end

function getItemDate(uid)
	return getItemDescriptions(uid).date
end

function getTilePzInfo(pos)
	return getTileInfo(pos).protection
end

function getTileZoneInfo(pos)
	local tmp = getTileInfo(pos)
	if(tmp.pvp) then
		return 2
	end

	if(tmp.nopvp) then
		return 1
	end

	return 0
end

function doShutdown()
	return doSetGameState(GAMESTATE_SHUTDOWN)
end

function doSummonCreature(name, pos, displayError)
	local displayError, cid = displayError or true, doCreateMonster(name, pos, displayError)
	if(not cid) then
		cid = doCreateNpc(name, pos, displayError)
	end

	return cid
end

function getOnlinePlayers()
	local tmp = getPlayersOnline()
	local players = {}
	for i, cid in ipairs(tmp) do
		table.insert(players, getCreatureName(cid))
	end

	return players
end

function getPlayerByName(name)
	local cid = getCreatureByName(name)
	return isPlayer(cid) and cid or nil
end

function isPlayer(cid)
	return isCreature(cid) and cid >= AUTOID_PLAYERS and cid < AUTOID_MONSTERS
end

function isPlayerGhost(cid)
	if(not isPlayer(cid)) then
		return false
	end

	return getCreatureCondition(cid, CONDITION_GAMEMASTER, GAMEMASTER_INVISIBLE) or getPlayerFlagValue(cid, PLAYERFLAG_CANNOTBESEEN)
end

function isMonster(cid)
	return isCreature(cid) and cid >= AUTOID_MONSTERS and cid < AUTOID_NPCS
end

function isNpc(cid)
	return isCreature(cid) and cid >= AUTOID_NPCS
end

function doPlayerSetExperienceRate(cid, value)
	return doPlayerSetRate(cid, SKILL__LEVEL, value)
end

function doPlayerSetMagicRate(cid, value)
	return doPlayerSetRate(cid, SKILL__MAGLEVEL, value)
end

function doPlayerAddLevel(cid, amount, round)
	local experience, level = 0, getPlayerLevel(cid)
	if(amount > 0) then
		experience = getExperienceForLevel(level + amount) - (round and getPlayerExperience(cid) or getExperienceForLevel(level))
	else
		experience = -((round and getPlayerExperience(cid) or getExperienceForLevel(level)) - getExperienceForLevel(level + amount))
	end

	return doPlayerAddExperience(cid, experience)
end

function doPlayerAddMagLevel(cid, amount)
	for i = 1, amount do
		doPlayerAddSpentMana(cid, (getPlayerRequiredMana(cid, getPlayerMagLevel(cid, true) + 1) - getPlayerSpentMana(cid)) / getConfigInfo('rateMagic'))
	end
	return true
end

function doPlayerAddSkill(cid, skill, amount, round)
	if(skill == SKILL__LEVEL) then
		return doPlayerAddLevel(cid, amount, round)
	elseif(skill == SKILL__MAGLEVEL) then
		return doPlayerAddMagLevel(cid, amount)
	end

	return doPlayerAddSkillTry(cid, skill, (getPlayerRequiredSkillTries(cid, skill, getPlayerSkillLevel(cid, skill) + 1) - getPlayerSkillTries(cid, skill)) / getConfigInfo('rateSkill'))
end

function getPartyLeader(cid)
	local party = getPartyMembers(cid)
	if(type(party) ~= 'table') then
		return 0
	end

	return party[1]
end

function isInParty(cid)
	return type(getPartyMembers(cid)) == 'table'
end

function isPrivateChannel(channelId)
	return channelId >= CHANNEL_PRIVATE
end

function doPlayerResetIdleTime(cid)
	return doPlayerSetIdleTime(cid, 0)
end

function doBroadcastMessage(text, class)
	local class = class or MESSAGE_STATUS_WARNING
	if(type(class) == 'string') then
		local className = MESSAGE_TYPES[class]
		if(className == nil) then
			return false
		end

		class = className
	elseif(class < MESSAGE_FIRST or class > MESSAGE_LAST) then
		return false
	end

	local players = getPlayersOnline()
	for _, pid in ipairs(players) do
		doPlayerSendTextMessage(pid, class, text)
	end

	print("> Broadcasted message: \"" .. text .. "\".")
	return true
end

function doPlayerBroadcastMessage(cid, text, class, checkFlag, ghost)
	local checkFlag, ghost, class = checkFlag or true, ghost or false, class or TALKTYPE_BROADCAST
	if(checkFlag and not getPlayerFlagValue(cid, PLAYERFLAG_CANBROADCAST)) then
		return false
	end

	if(type(class) == 'string') then
		local className = TALKTYPE_TYPES[class]
		if(className == nil) then
			return false
		end

		class = className
	elseif(class < TALKTYPE_FIRST or class > TALKTYPE_LAST) then
		return false
	end

	local players = getPlayersOnline()
	for _, pid in ipairs(players) do
		doCreatureSay(cid, text, class, ghost, pid)
	end

	print("> " .. getCreatureName(cid) .. " broadcasted message: \"" .. text .. "\".")
	return true
end

function getBooleanFromString(input)
	local tmp = type(input)
	if(tmp == 'boolean') then
		return input
	end

	if(tmp == 'number') then
		return input > 0
	end

	local str = string.lower(tostring(input))
	return (str == "yes" or str == "true" or (tonumber(str) ~= nil and tonumber(str) > 0))
end

function doCopyItem(item, attributes)
	local attributes = ((type(attributes) == 'table') and attributes or { "aid" })

	local ret = doCreateItemEx(item.itemid, item.type)
	for _, key in ipairs(attributes) do
		local value = getItemAttribute(item.uid, key)
		if(value ~= nil) then
			doItemSetAttribute(ret, key, value)
		end
	end

	if(isContainer(item.uid)) then
		for i = (getContainerSize(item.uid) - 1), 0, -1 do
			local tmp = getContainerItem(item.uid, i)
			if(tmp.itemid > 0) then
				doAddContainerItemEx(ret, doCopyItem(tmp, true).uid)
			end
		end
	end

	return getThing(ret)
end

function doRemoveThing(uid)
	if(isCreature(uid)) then
		return doRemoveCreature(uid)
	end

	return doRemoveItem(uid)
end

function setAttackFormula(combat, type, minl, maxl, minm, maxm, min, max)
	local min, max = min or 0, max or 0
	return setCombatFormula(combat, type, -1, 0, -1, 0, minl, maxl, minm, maxm, -min, -max)
end

function setHealingFormula(combat, type, minl, maxl, minm, maxm, min, max)
	local min, max = min or 0, max or 0
	return setCombatFormula(combat, type, 1, 0, 1, 0, minl, maxl, minm, maxm, min, max)
end

function doChangeTypeItem(uid, subtype)
	local thing = getThing(uid)
	if(thing.itemid < 100) then
		return false
	end

	local subtype = subtype or 1
	return doTransformItem(thing.uid, thing.itemid, subtype)
end

function doSetItemText(uid, text, writer, date)
	local thing = getThing(uid)
	if(thing.itemid < 100) then
		return false
	end

	doItemSetAttribute(uid, "text", text)
	if(writer ~= nil) then
		doItemSetAttribute(uid, "writer", tostring(writer))
		if(date ~= nil) then
			doItemSetAttribute(uid, "date", tonumber(date))
		end
	end

	return true
end

function getFluidSourceType(itemid)
	local item = getItemInfo(itemid)
	return item and item.fluidSource or false
end

function getDepotId(uid)
	return getItemAttribute(uid, "depotid") or false
end

function getItemDescriptions(uid)
	local thing = getThing(uid)
	if(thing.itemid < 100) then
		return false
	end

	local item = getItemInfo(thing.itemid)
	return {
		name = getItemAttribute(uid, "name") or item.name,
		plural = getItemAttribute(uid, "pluralname") or item.plural,
		article = getItemAttribute(uid, "article") or item.article,
		special = getItemAttribute(uid, "description") or "",
		text = getItemAttribute(uid, "text") or "",
		writer = getItemAttribute(uid, "writer") or "",
		date = getItemAttribute(uid, "date") or 0
	}
end

function getItemWeightById(itemid, count, precision)
	local item, count, precision = getItemInfo(itemid), count or 1, precision or false
	if(not item) then
		return false
	end

	if(count > 100) then
		-- print a warning, as its impossible to have more than 100 stackable items without "cheating" the count
		print('[Warning] getItemWeightById', 'Calculating weight for more than 100 items!')
	end

	local weight = item.weight * count
	--[[if(precision) then
		return weight
	end

	local t = string.explode(tostring(weight), ".")
	if(table.maxn(t) == 2) then
		return tonumber(t[1] .. "." .. string.sub(t[2], 1, 2))
	end]]--

	return weight
end

function getItemWeaponType(uid)
	local thing = getThing(uid)
	if(thing.itemid < 100) then
		return false
	end

	return getItemInfo(thing.itemid).weaponType
end

function getItemRWInfo(uid)
	local thing = getThing(uid)
	if(thing.itemid < 100) then
		return false
	end

	local item, flags = getItemInfo(thing.itemid), 0
	if(item.readable) then
		flags = 1
	end

	if(item.writable) then
		flags = flags + 2
	end

	return flags
end

function getItemLevelDoor(itemid)
	local item = getItemInfo(itemid)
	return item and item.levelDoor or false
end

function isItemStackable(itemid)
	local item = getItemInfo(itemid)
	return item and item.stackable or false
end

function isItemRune(itemid)
	local item = getItemInfo(itemid)
	return item and item.type == ITEM_TYPE_RUNE or false
end

function isItemDoor(itemid)
	local item = getItemInfo(itemid)
	return item and item.type == ITEM_TYPE_DOOR or false
end

function isItemContainer(itemid)
	local item = getItemInfo(itemid)
	return item and item.group == ITEM_GROUP_CONTAINER or false
end

function isItemFluidContainer(itemid)
	local item = getItemInfo(itemid)
	return item and item.group == ITEM_GROUP_FLUID or false
end

function isItemMovable(itemid)
	local item = getItemInfo(itemid)
	return item and item.movable or false
end

function isCorpse(uid)
	local thing = getThing(uid)
	if(thing.itemid < 100) then
		return false
	end

	local item = getItemInfo(thing.itemid)
	return item and item.corpseType ~= 0 or false
end

function getContainerCapById(itemid)
	local item = getItemInfo(itemid)
	if(not item or item.group ~= 2) then
		return false
	end

	return item.maxItems
end

function getMonsterAttackSpells(name)
	local monster = getMonsterInfo(name)
	return monster and monster.attacks or false
end

function getMonsterHealingSpells(name)
	local monster = getMonsterInfo(name)
	return monster and monster.defenses or false
end

function getMonsterLootList(name)
	local monster = getMonsterInfo(name)
	return monster and monster.loot or false
end

function getMonsterSummonList(name)
	local monster = getMonsterInfo(name)
	return monster and monster.summons or false
end

function choose(...)
	local arg = {...}
	return arg[math.random(1, table.maxn(arg))]
end 


---------------------------By Zefz ---------------------------


-------------------------------Achar ID de todos os Slots do inventario (Testando 20)-------------------------------
function GetSlotsId(cid)
	local i=0
	for i=0, 20, 1 do
		local slot = getPlayerSlotItem(cid, i).itemid
		--print(i..": "..slot)
		i = i+i
	end
end

-------------------------------Mostrar o Dano do set no inventario (Quando Desequipado) e atualiza o dano do inventario -------------------------------
function OnDeEquipSet(cid,item)
	local um = 1
	local min, max = getPlayerStorageValue(cid, VARIAVEL_ATK_MIN), getPlayerStorageValue(cid, VARIAVEL_ATK_MAX)
	doPlayerSendCancel(cid, "blockAtividades".." "..um)
	ValorSlotNegativo(cid,item)
end

-------------------------------Ao Equipar Helmet mostra a raridade no inventario e soma os danos do set + arma-------------------------------
function OnEquipHelmet(cid,item,slot)
	local slots = getPlayerSlotItem(cid, slot )
	if slots.itemid ~= item.itemid then
    	return true
	end
	if getItemAttribute(item.uid, 'name') then
		if string.match(getItemAttribute(item.uid, 'name'),"melhorado") then
			doPlayerSendCancel(cid, "@HM")
		elseif string.match(getItemAttribute(item.uid, 'name'),"perfeito") then
			doPlayerSendCancel(cid, "#HP")
		elseif string.match(getItemAttribute(item.uid, 'name'),"raro") then
			doPlayerSendCancel(cid, "$HR")
		elseif string.match(getItemAttribute(item.uid, 'name'),"lendario") then
			doPlayerSendCancel(cid, "%HL")
		end
	end
	ValorSlot(cid,item)
end

-------------------------------Ao Equipar Armor usar essa funcao sempre e soma os danos do set + arma-------------------------------
function OnEquipArmor(cid,item,slot)
	local slots = getPlayerSlotItem(cid, slot )
	if slots.itemid ~= item.itemid then
    	return true
	end
	if getItemAttribute(item.uid, 'name') then
		if string.match(getItemAttribute(item.uid, 'name'),"melhorado") then
			doPlayerSendCancel(cid, "@@ArmorMelhorado")
		elseif string.match(getItemAttribute(item.uid, 'name'),"perfeito") then
			doPlayerSendCancel(cid, "##ArmorPerfeito")
		elseif string.match(getItemAttribute(item.uid, 'name'),"raro") then
			doPlayerSendCancel(cid, "$$ArmorRaro")
		elseif string.match(getItemAttribute(item.uid, 'name'),"lendario") then
			doPlayerSendCancel(cid, "%%ArmorLendario")
		end
	end
	ValorSlot(cid,item)
end

-------------------------------Ao Equipar Legs usar essa funcao sempre e soma os danos do set + arma-------------------------------
function OnEquipLegs(cid,item,slot)
	local slots = getPlayerSlotItem(cid, slot )
	if slots.itemid ~= item.itemid then
    	return true
	end
	if getItemAttribute(item.uid, 'name') then
		if string.match(getItemAttribute(item.uid, 'name'),"melhorado") then
			doPlayerSendCancel(cid, "@@@MelhoradoLegs")
		elseif string.match(getItemAttribute(item.uid, 'name'),"perfeito") then
			doPlayerSendCancel(cid, "###PerfeitoLegs")
		elseif string.match(getItemAttribute(item.uid, 'name'),"raro") then
			doPlayerSendCancel(cid, "$$$RaroLegs")
		elseif string.match(getItemAttribute(item.uid, 'name'),"lendario") then
			doPlayerSendCancel(cid, "%%%LendarioLegs")
		end
	end
	ValorSlot(cid,item)
end

-------------------------------Ao Equipar Boots usar essa funcao sempre e soma os danos do set + arma-------------------------------
function OnEquipBoots(cid,item,slot)
	local slots = getPlayerSlotItem(cid, slot )
	if slots.itemid ~= item.itemid then
    	return true
	end
	if getItemAttribute(item.uid, 'name') then
		if string.match(getItemAttribute(item.uid, 'name'),"melhorado") then
			doPlayerSendCancel(cid, "!@#$BootsM")
		elseif string.match(getItemAttribute(item.uid, 'name'),"perfeito") then
			doPlayerSendCancel(cid, "%$#@PBoots")
		elseif string.match(getItemAttribute(item.uid, 'name'),"raro") then
			doPlayerSendCancel(cid, "$#RaroBootsRaro")
		elseif string.match(getItemAttribute(item.uid, 'name'),"lendario") then
			doPlayerSendCancel(cid, "%!LenBoots")
		end
	end
	ValorSlot(cid,item)
end

-------------------------------Ao Equipar Arma usar essas funcoes sempre e soma os danos da arma-------------------------------
function OnEquipArma(cid,item,attackmin,attackmax,slot)
	local slots = getPlayerSlotItem(cid, slot )
	if slots.itemid ~= item.itemid then
    	return true
	end
	if getItemAttribute(item.uid, 'name') then
		if string.match(getItemAttribute(item.uid, 'name'),"melhorado") then
			doPlayerSendCancel(cid, "&GunMelhorado")
		elseif string.match(getItemAttribute(item.uid, 'name'),"perfeito") then
			doPlayerSendCancel(cid, "&!!GunPerfeito")
		elseif string.match(getItemAttribute(item.uid, 'name'),"raro") then
			doPlayerSendCancel(cid, "&@@GunRaro")
		elseif string.match(getItemAttribute(item.uid, 'name'),"lendario") then
			doPlayerSendCancel(cid, "&##GunLendario")
		end
	end
	attackmin = attackmin*1000
	attackmax = attackmax*1000
	setPlayerStorageValue(cid,VARIAVEL_ATK_MIN, attackmin)
	setPlayerStorageValue(cid,VARIAVEL_ATK_MAX, attackmax)
	setPlayerStorageValue(cid,VARIAVEL_MIN, attackmin)
	setPlayerStorageValue(cid,VARIAVEL_MAX, attackmax)
	ValorSlotAtk(cid, item)

end
-------------------------------REMOVE O BUG DE SOMAR +1 VEZ COM O BONUS DA LEGS-------------------------------
function BonusBugLegs(cid)
	local valores = {}
	local setfull = {7}
	local variavelMin, variavelMax = getPlayerStorageValue(cid,VARIAVEL_MIN), getPlayerStorageValue(cid,VARIAVEL_MAX)--dano real com o bonus de dano
	local min, max = getPlayerStorageValue(cid,VARIAVEL_ATK_MIN), getPlayerStorageValue(cid,VARIAVEL_ATK_MAX)--dano fixo da arma para fazer a porcentagem em cima disso
	local vmin, vmax,valor2 = 0, 0
	local check = 0
	for i, value in pairs(setfull) do

		if getPlayerSlotItem(cid, value).itemid ~= 0 then

			local tmpItem = getPlayerSlotItem(cid, value).uid
				if getItemAttribute(tmpItem, 'description') ~= nil then
					local tmpItemDesc = getItemAttribute(tmpItem, 'description')

					for i in string.gmatch(tmpItemDesc, "%S+") do
								table.insert(valores, i)
					end

					if string.find(valores[4],"]") then--nao tem o slot
						nomeUm1 = 0
						nomeUm2 = 0
						slot = 0
						mark = 0
					elseif string.find(valores[5],"]") then--nome do 1 slot nao é composto
						nomeUm1 = valores[4]
						nomeUm2 = 0
						slot = 1
						mark = 0
					else
						nomeUm1 = valores[4]
						nomeUm2 = valores[5]
						slot = 1
						mark = 1
					end



					if (mark == 0 and valores[9] == nil) or string.find(valores[9],"]") then--nao tem o slot
						nomeDois1 = 0
						nomeDois2 = 0
						slot = slot
						valor2 = tonumber(string.match(valores[8], '%d+'))
					elseif mark == 0 and string.find(valores[10],"]") then--nome do 1 slot nao é composto
						nomeDois1 = valores[9]
						nomeDois2 = 0
						slot = slot+1
						valor2 = tonumber(string.match(valores[8], '%d+'))
					elseif mark == 0 and string.find(valores[11],"]") then
						nomeDois1 = valores[9]
						nomeDois2 = valores[10]
						slot = slot
						valor2 = tonumber(string.match(valores[8], '%d+'))
					elseif mark == 1 and string.find(valores[10],"]") then
						nomeDois1 = 0
						nomeDois2 = 0
						slot = slot
						valor2 = tonumber(string.match(valores[9], '%d+'))
					elseif mark == 1 and string.find(valores[11],"]") then
						nomeDois1 = valores[10]
						nomeDois2 = 0
						slot = slot+1
						valor2 = tonumber(string.match(valores[9], '%d+'))
					elseif mark == 1 and string.find(valores[12],"]") then
						nomeDois1 = valores[10]
						nomeDois2 = valores[11]
						slot = slot+1
						valor2 = tonumber(string.match(valores[9], '%d+'))
					end


					if  string.find(valores[4],"DANO") then
						local valor = tonumber(string.match(valores[3], '%d+'))
							vmin = variavelMin-((valor/100)*min)
							vmax = variavelMax-((valor/100)*max)
							setPlayerStorageValue(cid,VARIAVEL_MIN, vmin)
							setPlayerStorageValue(cid,VARIAVEL_MAX, vmax)
					end
					if  string.find(nomeDois1,"DANO") then

							vmin = variavelMin-((valor2/100)*min)
							vmax = variavelMax-((valor2/100)*max)
							setPlayerStorageValue(cid,VARIAVEL_MIN, vmin)
							setPlayerStorageValue(cid,VARIAVEL_MAX, vmax)
					end
					for k in pairs (valores) do
					    valores[k] = nil
					end
				end
				local um = 1
		vmin = (vmin/1000)
		vmax = (vmax/1000)
		doPlayerSendCancel(cid, "blockAtividades".." "..um)
		doPlayerSendCancel(cid, "**Damage".." "..vmin.." "..vmax)
		end

		
	end
		
end
------------------------------------------------------------------------------------------------------------------------------------
function BonusBugBoots(cid)
	local valores = {}
	local setfull = {8}
	local variavelMin, variavelMax = getPlayerStorageValue(cid,VARIAVEL_MIN), getPlayerStorageValue(cid,VARIAVEL_MAX)
	local min, max = getPlayerStorageValue(cid,VARIAVEL_ATK_MIN), getPlayerStorageValue(cid,VARIAVEL_ATK_MAX)
	local vmin, vmax,valor2 = 0, 0
	local check = 0
	for i, value in pairs(setfull) do

		if getPlayerSlotItem(cid, value).itemid ~= 0 then

			local tmpItem = getPlayerSlotItem(cid, value).uid
				if getItemAttribute(tmpItem, 'description') ~= nil then
					local tmpItemDesc = getItemAttribute(tmpItem, 'description')

					for i in string.gmatch(tmpItemDesc, "%S+") do
								table.insert(valores, i)
					end

					if string.find(valores[4],"]") then--nao tem o slot
						nomeUm1 = 0
						nomeUm2 = 0
						slot = 0
						mark = 0
					elseif string.find(valores[5],"]") then--nome do 1 slot nao é composto
						nomeUm1 = valores[4]
						nomeUm2 = 0
						slot = 1
						mark = 0
					else
						nomeUm1 = valores[4]
						nomeUm2 = valores[5]
						slot = 1
						mark = 1
					end



					if (mark == 0 and valores[9] == nil) or (valores[9] ~=nil and string.find(valores[9],"]")) then--nao tem o slot
						nomeDois1 = 0
						nomeDois2 = 0
						slot = slot
						valor2 = tonumber(string.match(valores[8], '%d+'))
					elseif mark == 0 and (valores[10] ~= nil and string.find(valores[10],"]")) then--nome do 1 slot nao é composto
						nomeDois1 = valores[9]
						nomeDois2 = 0
						slot = slot+1
						valor2 = tonumber(string.match(valores[8], '%d+'))
					elseif mark == 0 and (valores[11] ~= nil and string.find(valores[11],"]")) then
						nomeDois1 = valores[9]
						nomeDois2 = valores[10]
						slot = slot
						valor2 = tonumber(string.match(valores[8], '%d+'))
					elseif mark == 1 and (valores[10] ~= nil and string.find(valores[10],"]")) then
						nomeDois1 = 0
						nomeDois2 = 0
						slot = slot
						valor2 = tonumber(string.match(valores[9], '%d+'))
					elseif mark == 1 and (valores[11] ~= nil and string.find(valores[11],"]")) then
						nomeDois1 = valores[10]
						nomeDois2 = 0
						slot = slot+1
						valor2 = tonumber(string.match(valores[9], '%d+'))
					elseif mark == 1 and (valores[12] ~= nil and string.find(valores[12],"]")) then
						nomeDois1 = valores[10]
						nomeDois2 = valores[11]
						slot = slot+1
						valor2 = tonumber(string.match(valores[9], '%d+'))
					end


					if  (valores[4] ~= nil and string.find(valores[4],"DANO")) then
						local valor = tonumber(string.match(valores[3], '%d+'))
							vmin = variavelMin-((valor/100)*min)
							vmax = variavelMax-((valor/100)*max)
							setPlayerStorageValue(cid,VARIAVEL_MIN, vmin)
							setPlayerStorageValue(cid,VARIAVEL_MAX, vmax)
					end
					if  (nomeDois1 ~= nil and string.find(nomeDois1,"DANO")) then

							vmin = vmin-((valor2/100)*min)
							vmax = vmax-((valor2/100)*max)
							setPlayerStorageValue(cid,VARIAVEL_MIN, vmin)
							setPlayerStorageValue(cid,VARIAVEL_MAX, vmax)
					end
					for k in pairs (valores) do
					    valores[k] = nil
					end
				end
				local um = 1
		vmin = (vmin/1000)
		vmax = (vmax/1000)
		doPlayerSendCancel(cid, "blockAtividades".." "..um)
		doPlayerSendCancel(cid, "**Damage".." "..vmin.." "..vmax)
		end

		
	end
		
end

-------------------------------AE EQUIPAR A ARMA MOSTRA O DANO NO INV JUNTO COM O BONUS DO SET INTEIRO-------------------------------
function ValorSlotAtk(cid,item)
	local valores = {}
	local setfull = {1, 4, 7, 8}
	local variavelMin, variavelMax = getPlayerStorageValue(cid,VARIAVEL_MIN), getPlayerStorageValue(cid,VARIAVEL_MAX)
	local min, max = getPlayerStorageValue(cid,VARIAVEL_ATK_MIN), getPlayerStorageValue(cid,VARIAVEL_ATK_MAX)
	local vmin, vmax,valor2
	local nomeDois1,nomeDois2
	for i, value in pairs(setfull) do
		if getPlayerSlotItem(cid, value).itemid ~= 0 then

			local tmpItem = getPlayerSlotItem(cid, value).uid
				if getItemAttribute(tmpItem, 'description') ~= nil then
					local tmpItemDesc = getItemAttribute(tmpItem, 'description')

					for i in string.gmatch(tmpItemDesc, "%S+") do
								table.insert(valores, i)
								--print(i)
					end

					if (valores[4] ~= nil and string.find(valores[4],"]")) then--nao tem o slot
						nomeUm1 = 0
						nomeUm2 = 0
						slot = 0
						mark = 0
					elseif (valores[5] ~= nil and string.find(valores[5],"]")) then--nome do 1 slot nao é composto
						nomeUm1 = valores[4]
						nomeUm2 = 0
						slot = 1
						mark = 0
						valor = tonumber(string.match(valores[3], '%d+'))
					else
						nomeUm1 = valores[4]
						nomeUm2 = valores[5]
						slot = 1
						mark = 1
						valor = tonumber(string.match(valores[3], '%d+'))
					end



					if (mark == 0 and valores[9] == nil) or (valores[9] ~=nil and string.find(valores[9],"]")) then--nao tem o slot
						nomeDois1 = 0
						nomeDois2 = 0
						slot = slot
						valor2 = tonumber(string.match(valores[8], '%d+'))
					elseif mark == 0 and (valores[10] ~= nil and string.find(valores[10],"]")) then--nome do 1 slot nao é composto
						nomeDois1 = valores[9]
						nomeDois2 = 0
						slot = slot+1
						valor2 = tonumber(string.match(valores[8], '%d+'))
					elseif mark == 0 and (valores[11] ~= nil and string.find(valores[11],"]")) then
						nomeDois1 = valores[9]
						nomeDois2 = valores[10]
						slot = slot
						valor2 = tonumber(string.match(valores[8], '%d+'))
					elseif mark == 1 and (valores[10] ~= nil and string.find(valores[10],"]")) then
						nomeDois1 = 0
						nomeDois2 = 0
						slot = slot
						valor2 = tonumber(string.match(valores[9], '%d+'))
					elseif mark == 1 and (valores[11] ~= nil and string.find(valores[11],"]")) then
						nomeDois1 = valores[10]
						nomeDois2 = 0
						slot = slot+1
						valor2 = tonumber(string.match(valores[9], '%d+'))
					elseif mark == 1 and (valores[12] ~= nil and string.find(valores[12],"]")) then
						nomeDois1 = valores[10]
						nomeDois2 = valores[11]
						slot = slot+1
						valor2 = tonumber(string.match(valores[9], '%d+'))
					end

					if (nomeUm1 ~= nil and string.find(nomeUm1,"DANO")) then
						--print(nomeUm1)
						if variavelMin < min then
							vmin = 0
							vmax = 0
						else
							local variavelMin, variavelMax = getPlayerStorageValue(cid,VARIAVEL_MIN), getPlayerStorageValue(cid,VARIAVEL_MAX)
							local min, max = getPlayerStorageValue(cid,VARIAVEL_ATK_MIN), getPlayerStorageValue(cid,VARIAVEL_ATK_MAX)
							vmin = variavelMin+(min*(valor/100))
							vmax = variavelMax+(max*(valor/100))
							setPlayerStorageValue(cid,VARIAVEL_MIN, vmin)
							setPlayerStorageValue(cid,VARIAVEL_MAX, vmax)
						end
					end

					
					--print(vmin)
					--print(vmax)
					--print("-----------------------")
					if (nomeDois1 ~= nil and string.find(nomeDois1,"DANO")) then
						--print(nomeDois1)
						local variavelMin, variavelMax = getPlayerStorageValue(cid,VARIAVEL_MIN), getPlayerStorageValue(cid,VARIAVEL_MAX)
						local min, max = getPlayerStorageValue(cid,VARIAVEL_ATK_MIN), getPlayerStorageValue(cid,VARIAVEL_ATK_MAX)
						if variavelMin < min then
							vmin = 0
							vmax = 0
						else
							vmin = variavelMin+(min*(valor2/100))
							vmax = variavelMax+(max*(valor2/100))
							setPlayerStorageValue(cid,VARIAVEL_MIN, vmin)
							setPlayerStorageValue(cid,VARIAVEL_MAX, vmax)
						end
					end
					--print(vmin)
					--print(vmax)
					for k in pairs (valores) do
					    valores[k] = nil
					end
				end
		end
	end
	if vmin == nil then
		
		local um = 1
		min = (min/1000)
		max = (max/1000)
		doPlayerSendCancel(cid, "blockAtividades".." "..um)
		doPlayerSendCancel(cid, "**Damage".." "..min.." "..max)
	else
		local um = 1
		vmin = (vmin/1000)
		vmax = (vmax/1000)
		doPlayerSendCancel(cid, "blockAtividades".." "..um)
		doPlayerSendCancel(cid, "**Damage".." "..vmin.." "..vmax)
	end
end

-------------------------------QUANDO EQUIPA A ARMA SETA NA STORAGE OS VALORES DE ATTACK MIN E MAX E A VARIAVEL MIN E MAX-------------------------------
function onDeEquipArma(cid,item,attackmin,attackmax)
	local um = 1
	local variavelMin, variavelMax = getPlayerStorageValue(cid,VARIAVEL_MIN), getPlayerStorageValue(cid,VARIAVEL_MAX)
	local min, max = getPlayerStorageValue(cid,VARIAVEL_ATK_MIN), getPlayerStorageValue(cid,VARIAVEL_ATK_MAX)
	local vmin, vmax
	vmin = 0
	vmax = 0
	setPlayerStorageValue(cid,VARIAVEL_ATK_MIN, vmin)
	setPlayerStorageValue(cid,VARIAVEL_ATK_MAX, vmax)
	setPlayerStorageValue(cid,VARIAVEL_MIN, vmin)
	setPlayerStorageValue(cid,VARIAVEL_MAX, vmax)
	
	
		vmin = (vmin/1000)
		vmax = (vmax/1000)

		doPlayerSendCancel(cid, "blockAtividades".." "..um)
		doPlayerSendCancel(cid, "**Damage".." "..vmin.." "..vmax)
end


-------------------------------Pega o atk da arma por storage global e soma com todos os bonus dos itens do set-------------------------------
function ValorSlotNegativo(cid,item)
	local valores = {}

	local variavelMin, variavelMax = getPlayerStorageValue(cid,VARIAVEL_MIN), getPlayerStorageValue(cid,VARIAVEL_MAX)
	local min, max = getPlayerStorageValue(cid,VARIAVEL_ATK_MIN), getPlayerStorageValue(cid,VARIAVEL_ATK_MAX)
	local vmin, vmax

				if getItemAttribute(item.uid, 'description') ~= nil then
					local tmpItemDesc = getItemAttribute(item.uid, 'description')
					
					for i in string.gmatch(tmpItemDesc, "%S+") do
						table.insert(valores, i)
					end

					if string.find(valores[4],"]") then--nao tem o slot
						nomeUm1 = 0
						nomeUm2 = 0
						slot = 0
						mark = 0
					elseif string.find(valores[5],"]") then--nome do 1 slot nao é composto
						nomeUm1 = valores[4]
						nomeUm2 = 0
						slot = 1
						mark = 0
						valor = tonumber(string.match(valores[3], '%d+'))
					else
						nomeUm1 = valores[4]
						nomeUm2 = valores[5]
						slot = 1
						mark = 1
						valor = tonumber(string.match(valores[3], '%d+'))
					end



					if (mark == 0 and valores[9] == nil) or string.find(valores[9],"]") then--nao tem o slot
						nomeDois1 = 0
						nomeDois2 = 0
						slot = slot
						valor2 = tonumber(string.match(valores[8], '%d+'))
					elseif mark == 0 and string.find(valores[10],"]") then--nome do 1 slot nao é composto
						nomeDois1 = valores[9]
						nomeDois2 = 0
						slot = slot+1
						valor2 = tonumber(string.match(valores[8], '%d+'))
					elseif mark == 0 and string.find(valores[11],"]") then
						nomeDois1 = valores[9]
						nomeDois2 = valores[10]
						slot = slot
						valor2 = tonumber(string.match(valores[8], '%d+'))
					elseif mark == 1 and string.find(valores[10],"]") then
						nomeDois1 = 0
						nomeDois2 = 0
						slot = slot
						valor2 = tonumber(string.match(valores[9], '%d+'))
					elseif mark == 1 and string.find(valores[11],"]") then
						nomeDois1 = valores[10]
						nomeDois2 = 0
						slot = slot+1
						valor2 = tonumber(string.match(valores[9], '%d+'))
					elseif mark == 1 and string.find(valores[12],"]") then
						nomeDois1 = valores[10]
						nomeDois2 = valores[11]
						slot = slot+1
						valor2 = tonumber(string.match(valores[9], '%d+'))
					end

					if string.find(nomeUm1,"SP") then
						removeItemSlot(cid,item)
						local sp = getPlayerStorageValue(cid,VARIAVEL_SP)
						setPlayerStorageValue(cid,VARIAVEL_SP,(sp-valor))
					end

					if string.find(nomeUm1,"HP") then
						removeItemSlot(cid,item)
						local hp = getPlayerStorageValue(cid,VARIAVEL_HP)
						setPlayerStorageValue(cid,VARIAVEL_HP,(hp-valor))
					end

					if string.find(nomeUm1,"MP") then
						removeItemSlot(cid,item)
						local mp = getPlayerStorageValue(cid,VARIAVEL_MP)
						setPlayerStorageValue(cid,VARIAVEL_MP,(mp-valor))
					end

					if string.find(nomeUm1,"REFLECT") then
						removeItemSlot(cid,item)
						local reflect = getPlayerStorageValue(cid,VARIAVEL_ATK_REFLECT)
						setPlayerStorageValue(cid,VARIAVEL_ATK_REFLECT,(reflect-valor))
						print(getPlayerStorageValue(cid,VARIAVEL_ATK_REFLECT))
					end

					if string.find(nomeUm1,"ABSORB") then
						removeItemSlot(cid,item)
						local ABSORB = getPlayerStorageValue(cid,VARIAVEL_ATK_ABSORB)
						setPlayerStorageValue(cid,VARIAVEL_ATK_ABSORB, (ABSORB-valor))
						--(tonumber(string.match(valores[3], '%d+')
					end

					if string.find(nomeUm1,"BOMB") then
						removeItemSlot(cid,item)
						if string.find(nomeUm2,"FIRE") then
							local bomb = getPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_FIRE)
							setPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_FIRE,(bomb-valor))
						elseif string.find(nomeUm2,"ENERGY") then
							local bomb = getPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_ENERGY)
							setPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_ENERGY,(bomb-valor))
						elseif string.find(nomeUm2,"ICE") then
							local bomb = getPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_ICE)
							setPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_ICE,(bomb-valor))
						elseif string.find(nomeUm2,"HOLY") then
							local bomb = getPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_HOLY)
							setPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_HOLY,(bomb-valor))
						elseif string.find(nomeUm2,"DEATH") then
							local bomb = getPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_DEATH)
							setPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_DEATH,(bomb-valor))
						elseif string.find(nomeUm2,"POISON") then
							local bomb = getPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_POISON)
							setPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_POISON,(bomb-valor))
						end
					end
					
					if string.find(nomeUm1,"REGENERAR") then
						removeItemSlot(cid,item)
						if string.find(nomeUm2,"SP") then
							local regsp = getPlayerStorageValue(cid,VARIAVEL_REG_SP)
							setPlayerStorageValue(cid,VARIAVEL_REG_SP,(regsp-valor))
						elseif string.find(nomeUm2,"HP") then
							local reghp = getPlayerStorageValue(cid,VARIAVEL_REG_HP)
							setPlayerStorageValue(cid,VARIAVEL_REG_HP,(reghp-valor))
						elseif string.find(nomeUm2,"MP") then
							local regmp = getPlayerStorageValue(cid,VARIAVEL_REG_MP)
							setPlayerStorageValue(cid,VARIAVEL_REG_MP,(regmp-valor))
						end
					end
					
					if string.find(nomeUm1,"DANO") then
						if variavelMin < min then
							vmin = variavelMin-((valor/100)*min)
							vmax = variavelMax-((valor/100)*max)
							setPlayerStorageValue(cid,VARIAVEL_MIN, vmin)
							setPlayerStorageValue(cid,VARIAVEL_MAX, vmax)
						else
							vmin = variavelMin-((valor/100)*min)
							vmax = variavelMax-((valor/100)*max)
							setPlayerStorageValue(cid,VARIAVEL_MIN, vmin)
							setPlayerStorageValue(cid,VARIAVEL_MAX, vmax)
						end
					end

					if string.find(nomeUm1,"MAGIC") then
						removeItemSlot(cid,item)
						local mg = getPlayerStorageValue(cid,VARIAVEL_ATK_MAGICO)
						setPlayerStorageValue(cid,VARIAVEL_ATK_MAGICO,(mg-valor))
					end

					------------------------------------------------------------------------------------------------------------------2 SLOT / EQUIPANDO
					if string.find(nomeDois1,"SP") then
						removeItemSlot(cid,item)
						local sp = getPlayerStorageValue(cid,VARIAVEL_SP)
						setPlayerStorageValue(cid,VARIAVEL_SP,(sp-valor2))

					elseif string.find(nomeDois1,"HP") then
						removeItemSlot(cid,item)
						local hp = getPlayerStorageValuecid,(VARIAVEL_HP)
						setPlayerStorageValue(cid,VARIAVEL_HP,(hp-valor2))

					elseif string.find(nomeDois1,"MP") then
						removeItemSlot(cid,item)
						local mp = getPlayerStorageValue(cid,VARIAVEL_MP)
						setPlayerStorageValue(cid,VARIAVEL_MP,(mp-valor2))

					elseif string.find(nomeDois1,"REFLECT") then
						removeItemSlot(cid,item)
						local reflect = getPlayerStorageValue(cid,VARIAVEL_ATK_REFLECT)
						setPlayerStorageValue(cid,VARIAVEL_ATK_REFLECT,(reflect-valor2))
						print(getPlayerStorageValue(cid,VARIAVEL_ATK_REFLECT))

					elseif string.find(nomeDois1,"ABSORB") then
						removeItemSlot(cid,item)
						local ABSORB = getPlayerStorageValue(cid,VARIAVEL_ATK_ABSORB)
						setPlayerStorageValue(cid,VARIAVEL_ATK_ABSORB,(ABSORB-valor2))

					elseif string.find(nomeDois1,"BOMB") then
						if string.find(nomeDois2,"FIRE") then
							removeItemSlot(cid,item)
							local bomb = getPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_FIRE)
							setPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_FIRE,(bomb-valor2))

						elseif string.find(nomeDois2,"ENERGY") then
							removeItemSlot(cid,item)
							local bomb = getPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_ENERGY)
							setPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_ENERGY,(bomb-valor2))

						elseif string.find(nomeDois2,"ICE") then
							removeItemSlot(cid,item)
							local bomb = getPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_ICE)
							setPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_ICE,(bomb-valor2))

						elseif string.find(nomeDois2,"HOLY") then
							removeItemSlot(cid,item)
							local bomb = getPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_HOLY)
							setPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_HOLY,(bomb-valor2))

						elseif string.find(nomeDois2,"DEATH") then
							removeItemSlot(cid,item)
							local bomb = getPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_DEATH)
							setPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_DEATH,(bomb-valor2))

						elseif string.find(nomeDois2,"POISON") then
							removeItemSlot(cid,item)
							local bomb = getPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_POISON)
							setPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_POISON,(bomb-valor2))
						end
					elseif  string.find(nomeDois1,"REGENERAR") then
						if string.find(nomeDois2,"SP") then
							removeItemSlot(cid,item)
							local regsp = getPlayerStorageValue(cid,VARIAVEL_REG_SP)
							setPlayerStorageValue(cid,VARIAVEL_REG_SP,(regsp-valor2))

						elseif string.find(nomeDois2,"HP") then
							removeItemSlot(cid,item)
							local reghp = getPlayerStorageValue(cid,VARIAVEL_REG_HP)
							setPlayerStorageValue(cid,VARIAVEL_REG_HP,(reghp-valor2))

						elseif string.find(nomeDois2,"MP") then
							removeItemSlot(cid,item)
							local regmp = getPlayerStorageValue(cid,VARIAVEL_REG_MP)
							setPlayerStorageValue(cid,VARIAVEL_REG_MP,(regmp-valor2))
						end
					elseif  string.find(nomeDois1,"DANO") then
						removeItemSlot(cid,item)
						--print(variavelMin)
						--print(min)
						if variavelMin < min then
							vmin = 0
							vmax = 0
							setPlayerStorageValue(cid,VARIAVEL_MIN, vmin)
							setPlayerStorageValue(cid,VARIAVEL_MAX, vmax)
						else
							vmin = getPlayerStorageValue(cid,VARIAVEL_MIN)-((valor2/100)*min)
							vmax = getPlayerStorageValue(cid,VARIAVEL_MAX)-((valor2/100)*max)
							setPlayerStorageValue(cid,VARIAVEL_MIN, vmin)
							setPlayerStorageValue(cid,VARIAVEL_MAX, vmax)
						end
					elseif string.find(nomeDois1,"MAGIC") then
						removeItemSlot(cid,item)
						local mg = getPlayerStorageValue(cid,VARIAVEL_ATK_MAGICO)
						setPlayerStorageValue(cid,VARIAVEL_ATK_MAGICO,(mg-valor2))
					end
					for k in pairs (valores) do
					    valores[k] = nil
					end
				end
			if vmin == nil then
					vmin = variavelMin
					vmax = variavelMax
					local um = 1
					vmin = (vmin/1000)
					vmax = (vmax/1000)
					doPlayerSendCancel(cid, "blockAtividades".." "..um)
					doPlayerSendCancel(cid, "**Damage".." "..vmin.." "..vmax)
				else
	local um = 1
		vmin = (vmin/1000)
		vmax = (vmax/1000)
		doPlayerSendCancel(cid, "blockAtividades".." "..um)
		doPlayerSendCancel(cid, "**Damage".." "..vmin.." "..vmax)
end
end

-------------------------------Pega o atk da arma por storage global e soma com todos os bonus dos itens do set-------------------------------
function ValorSlot(cid,item)
	local setfull = {1, 4, 7, 8}
	local valores = {}
	local NomeBonus = {}
	local variavelMin, variavelMax = getPlayerStorageValue(cid,VARIAVEL_MIN), getPlayerStorageValue(cid,VARIAVEL_MAX)
	local min, max = getPlayerStorageValue(cid,VARIAVEL_ATK_MIN), getPlayerStorageValue(cid,VARIAVEL_ATK_MAX)
	local vmin, vmax
	local nomeUm1, nomeUm2, nomeDois1, nomeDois2
	local slot,mark,valor2
			
				if getItemAttribute(item.uid, 'description') ~= nil then
					local tmpItemDesc = getItemAttribute(item.uid, 'description')
					
					for i in string.gmatch(tmpItemDesc, "%S+") do
						table.insert(valores, i)
						--print("testando: "..i)
					end
					--print(valores[8])-- é o valor
					--print(valores[9])--primeiro nome
					--print(valores[10])--segundo nome

					if string.find(valores[4],"]") then--nao tem o slot
						nomeUm1 = 0
						nomeUm2 = 0
						slot = 0
						mark = 0
					elseif string.find(valores[5],"]") then--nome do 1 slot nao é composto
						nomeUm1 = valores[4]
						nomeUm2 = 0
						slot = 1
						mark = 0
						valor = tonumber(string.match(valores[3], '%d+'))
					else
						nomeUm1 = valores[4]
						nomeUm2 = valores[5]
						slot = 1
						mark = 1
						valor = tonumber(string.match(valores[3], '%d+'))
					end



					if (mark == 0 and valores[9] == nil) or string.find(valores[9],"]") then--nao tem o slot
						nomeDois1 = 0
						nomeDois2 = 0
						slot = slot
						valor2 = tonumber(string.match(valores[8], '%d+'))
					elseif mark == 0 and string.find(valores[10],"]") then--nome do 1 slot nao é composto
						nomeDois1 = valores[9]
						nomeDois2 = 0
						slot = slot+1
						valor2 = tonumber(string.match(valores[8], '%d+'))
					elseif mark == 0 and string.find(valores[11],"]") then
						nomeDois1 = valores[9]
						nomeDois2 = valores[10]
						slot = slot
						valor2 = tonumber(string.match(valores[8], '%d+'))
					elseif mark == 1 and string.find(valores[10],"]") then
						nomeDois1 = 0
						nomeDois2 = 0
						slot = slot
						valor2 = tonumber(string.match(valores[9], '%d+'))
					elseif mark == 1 and string.find(valores[11],"]") then
						nomeDois1 = valores[10]
						nomeDois2 = 0
						slot = slot+1
						valor2 = tonumber(string.match(valores[9], '%d+'))
					elseif mark == 1 and string.find(valores[12],"]") then
						nomeDois1 = valores[10]
						nomeDois2 = valores[11]
						slot = slot+1
						valor2 = tonumber(string.match(valores[9], '%d+'))
					end

					if valor == nil then
						valor=0
					end

					if valor2 == nil then
						valor2=0
					end
					

					--print("nomeUm1: "..nomeUm1.." nomeUm2: "..nomeUm2.." valor: "..valor)
					--print("nomeDois1: "..nomeDois1.." nomeDois2: "..nomeDois2.." Valor2: "..valor2)

					-- local testando = tonumber(string.match(valores[3], '%d+'))
					-- print("testando: "..testando)

					if string.find(nomeUm1,"SP") then
						local sp = getPlayerStorageValue(cid,VARIAVEL_SP)
						setPlayerStorageValue(cid,VARIAVEL_SP,(valor+sp))

					elseif string.find(nomeUm1,"HP") then
						local hp = getPlayerStorageValue(cid,VARIAVEL_HP)
						setPlayerStorageValue(cid,VARIAVEL_HP,(valor+hp))

					elseif string.find(nomeUm1,"MP") then
						local mp = getPlayerStorageValue(cid,VARIAVEL_MP)
						setPlayerStorageValue(cid,VARIAVEL_MP,(valor+mp))

					elseif string.find(nomeUm1,"REFLECT") then
						local reflect = getPlayerStorageValue(cid,VARIAVEL_ATK_REFLECT)
						setPlayerStorageValue(cid,VARIAVEL_ATK_REFLECT,(valor+reflect))

					elseif string.find(nomeUm1,"ABSORB") then
						local ABSORB = getPlayerStorageValue(cid,VARIAVEL_ATK_ABSORB)
						setPlayerStorageValue(cid,VARIAVEL_ATK_ABSORB,(valor+ABSORB))

					elseif string.find(nomeUm1,"BOMB") then
						if string.find(nomeUm2,"FIRE") then
							local bomb = getPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_FIRE)
							setPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_FIRE,(valor+bomb))

						elseif string.find(nomeUm2,"ENERGY") then
							local bomb = getPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_ENERGY)
							setPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_ENERGY,(valor+bomb))

						elseif string.find(nomeUm2,"ICE") then
							local bomb = getPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_ICE)
							setPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_ICE,(valor+bomb))

						elseif string.find(nomeUm2,"HOLY") then
							local bomb = getPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_HOLY)
							setPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_HOLY,(valor+bomb))

						elseif string.find(nomeUm2,"DEATH") then
							local bomb = getPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_DEATH)
							setPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_DEATH,(valor+bomb))

						elseif string.find(nomeUm2,"POISON") then
							local bomb = getPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_POISON)
							setPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_POISON,(valor+bomb))

						end
					elseif  string.find(nomeUm1,"REGENERAR") then
						if string.find(nomeUm2,"SP") then
							local regsp = getPlayerStorageValue(cid,VARIAVEL_REG_SP)

							setPlayerStorageValue(cid,VARIAVEL_REG_SP,(valor+regsp))

						elseif string.find(nomeUm2,"HP") then
							local reghp = getPlayerStorageValue(cid,VARIAVEL_REG_HP)
							setPlayerStorageValue(cid,VARIAVEL_REG_HP,(valor+reghp))

						elseif string.find(nomeUm2,"MP") then
							local regmp = getPlayerStorageValue(cid,VARIAVEL_REG_MP)
							setPlayerStorageValue(cid,VARIAVEL_REG_MP,(valor+regmp))
						end
					elseif  string.find(nomeUm1,"DANO") then
						if variavelMin < min then
							--print("---BEGIN---")
							--print(vmin)
							--print(vmax)
							--print("------")
							vmin = 0
							vmax = 0
							setPlayerStorageValue(cid,VARIAVEL_MIN, vmin)
							setPlayerStorageValue(cid,VARIAVEL_MAX, vmax)
						else
							vmin = variavelMin+(min*(valor/100))
							vmax = variavelMax+(max*(valor/100))
							setPlayerStorageValue(cid,VARIAVEL_MIN, vmin)
							setPlayerStorageValue(cid,VARIAVEL_MAX, vmax)
						end
					elseif string.find(nomeUm1,"MAGIC") then
						local mg = getPlayerStorageValue(cid,VARIAVEL_ATK_MAGICO)
						setPlayerStorageValue(cid,VARIAVEL_ATK_MAGICO,(valor+mg))
					end
------------------------------------------------------------------------------------------------------------------2 SLOT / EQUIPANDO
					if string.find(nomeDois1,"SP") then
						local sp = getPlayerStorageValue(cid,VARIAVEL_SP)
						setPlayerStorageValue(cid,VARIAVEL_SP,(valor2+sp))

					elseif string.find(nomeDois1,"HP") then
						local hp = getPlayerStorageValuecid,(VARIAVEL_HP)
						setPlayerStorageValue(cid,VARIAVEL_HP,(valor2+hp))

					elseif string.find(nomeDois1,"MP") then
						local mp = getPlayerStorageValue(cid,VARIAVEL_MP)
						setPlayerStorageValue(cid,VARIAVEL_MP,(valor2+mp))

					elseif string.find(nomeDois1,"REFLECT") then
						local reflect = getPlayerStorageValue(cid,VARIAVEL_ATK_REFLECT)
						setPlayerStorageValue(cid,VARIAVEL_ATK_REFLECT,(valor2+reflect))

					elseif string.find(nomeDois1,"ABSORB") then
						local ABSORB = getPlayerStorageValue(cid,VARIAVEL_ATK_ABSORB)
						setPlayerStorageValue(cid,VARIAVEL_ATK_ABSORB,(valor2+ABSORB))

					elseif string.find(nomeDois1,"BOMB") then
						if string.find(nomeDois2,"FIRE") then
							local bomb = getPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_FIRE)
							setPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_FIRE,(valor2+bomb))

						elseif string.find(nomeDois2,"ENERGY") then
							local bomb = getPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_ENERGY)
							setPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_ENERGY,(valor2+bomb))

						elseif string.find(nomeDois2,"ICE") then
							local bomb = getPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_ICE)
							setPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_ICE,(valor2+bomb))

						elseif string.find(nomeDois2,"HOLY") then
							local bomb = getPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_HOLY)
							setPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_HOLY,(valor2+bomb))

						elseif string.find(nomeDois2,"DEATH") then
							local bomb = getPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_DEATH)
							setPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_DEATH,(valor2+bomb))

						elseif string.find(nomeDois2,"POISON") then
							local bomb = getPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_POISON)
							setPlayerStorageValue(cid,VARIAVEL_ATK_BOMB_POISON,(valor2+bomb))

						end
					elseif  string.find(nomeDois1,"REGENERAR") then
						if string.find(nomeDois2,2,"SP") then
							local regsp = getPlayerStorageValue(cid,VARIAVEL_REG_SP)
							setPlayerStorageValue(cid,VARIAVEL_REG_SP,(valor2+regsp))

						elseif string.find(nomeDois2,"HP") then
							local reghp = getPlayerStorageValue(cid,VARIAVEL_REG_HP)
							setPlayerStorageValue(cid,VARIAVEL_REG_HP,(valor2+reghp))

						elseif string.find(nomeDois2,"MP") then
							local regmp = getPlayerStorageValue(cid,VARIAVEL_REG_MP)
							setPlayerStorageValue(cid,VARIAVEL_REG_MP,(valor2+regmp))
						end
					elseif  string.find(nomeDois1,"DANO") then
						if variavelMin < min then
							vmin = 0
							vmax = 0
							vmin = variavelMin+(min*(valor2/100))
							vmax = variavelMax+(max*(valor2/100))
							setPlayerStorageValue(cid,VARIAVEL_MIN, vmin)
							setPlayerStorageValue(cid,VARIAVEL_MAX, vmax)
						else

							if vmin == nil then
								vmin = min
								vmax = max
							end
							vmin = getPlayerStorageValue(cid,VARIAVEL_MIN)+(min*(valor2/100))
							vmax = getPlayerStorageValue(cid,VARIAVEL_MAX)+(max*(valor2/100))
							setPlayerStorageValue(cid,VARIAVEL_MIN, vmin)
							setPlayerStorageValue(cid,VARIAVEL_MAX, vmax)
						end
					elseif string.find(nomeDois1,"MAGIC") then
						local mg = getPlayerStorageValue(cid,VARIAVEL_ATK_MAGICO)
						setPlayerStorageValue(cid,VARIAVEL_ATK_MAGICO,(valor2+mg))
					end
					for k in pairs (valores) do
					    valores[k] = nil
					end
				end
				--print(getItemAttribute(item.uid, 'name'))
				getItemSlot(cid,item,slot,nomeUm1,nomeUm2,nomeDois1,nomeDois2,valor, valor2)
				if vmin == nil then

					vmin = variavelMin/1000
					vmax = variavelMax/1000
					local um = 1
					doPlayerSendCancel(cid, "blockAtividades".." "..um)
					doPlayerSendCancel(cid, "**Damage".." "..vmin.." "..vmax)
				else
					
					local um = 1
					vmin = (vmin/1000)
					vmax = (vmax/1000)
					
					doPlayerSendCancel(cid, "blockAtividades".." "..um)
					doPlayerSendCancel(cid, "**Damage".." "..vmin.." "..vmax)
				end
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------
function getItemSlot(cid,item,slot,nomeUm1,nomeUm2,nomeDois1,nomeDois2,valor,valor2)--for the client?for all?

local getSlot1,getSlot2 = 0,0
--print(nomeUm1)
--print(nomeDois1)
--print(getItemAttribute(item.uid, 'name'))

if getItemAttribute(item.uid, 'name') then
	if string.find(getItemAttribute(item.uid, 'name'),"helmet") then
		while slot > 0 do
				if string.find(nomeUm1,"SP") and slot == 1 then
					getSlot1 = 5
				elseif string.find(nomeUm1,"HP") and slot == 1 then
					getSlot1 = 6
				elseif string.find(nomeUm1,"MP") and slot == 1 then
					getSlot1 = 7
				elseif string.find(nomeUm1,"REFLECT") and slot == 1 then
					getSlot1 = 8
				elseif string.find(nomeUm1,"ABSORB") and slot == 1 then
					getSlot1 = 9
				elseif string.find(nomeUm1,"BOMB") and slot == 1 then
					if string.find(nomeUm2,"FIRE") and slot == 1 then
					getSlot1 = 10
					elseif string.find(nomeUm2,"ENERGY") and slot == 1 then
					getSlot1 = 11
					elseif string.find(nomeUm2,"ICE") and slot == 1 then
					getSlot1 = 12
					elseif string.find(nomeUm2,"HOLY") and slot == 1 then 
					getSlot1 = 13
					elseif string.find(nomeUm2,"DEATH") and slot == 1 then
					getSlot1 = 14
					elseif string.find(nomeUm2,"POISON") and slot == 1 then
					getSlot1 = 15
					end
				elseif string.find(nomeUm1,"REGENERAR") and slot == 1 then
					if string.find(nomeUm2,"SP") and slot == 1 then
					getSlot1 = 16
					elseif string.find(nomeUm2,"HP") and slot == 1 then
					getSlot1 = 17
					elseif string.find(nomeUm2,"MP") and slot == 1 then
					getSlot1 = 18
					end
				elseif string.find(nomeUm1,"MAGIC") and slot == 1 then
					getSlot1 = 19
				elseif string.find(nomeUm1,"DANO") and slot == 1 then
					getSlot1 = 29
				end
				--------------------------------------------------SLOT 2
				if string.find(nomeDois1,"SP") and slot == 2 then
					getSlot2 = 5
				elseif string.find(nomeDois1,"HP") and slot == 2 then
					getSlot2 = 6
				elseif string.find(nomeDois1,"MP") and slot == 2 then
					getSlot2 = 7
				elseif string.find(nomeDois1,"REFLECT") and slot == 2 then
					getSlot2 = 8
				elseif string.find(nomeDois1,"ABSORB") and slot == 2 then
					getSlot2 = 9
				elseif string.find(nomeDois1,"BOMB") and slot == 2 then
					if string.find(nomeDois2,"FIRE") and slot == 2 then
					getSlot2 = 10
					elseif string.find(nomeDois2,"ENERGY") and slot == 2 then
					getSlot2 = 11
					elseif string.find(nomeDois2,"ICE") and slot == 2 then
					getSlot2 = 12
					elseif string.find(nomeDois2,"HOLY") and slot == 2 then
					getSlot2 = 13
					elseif string.find(nomeDois2,"DEATH") and slot == 2 then
					getSlot2 = 14
					elseif string.find(nomeDois2,"POISON") and slot == 2 then
					getSlot2 = 15
					end
				elseif string.find(nomeDois1,"REGENERAR") and slot == 2 then
					if string.find(nomeDois2,"SP") and slot == 2 then
					getSlot2 = 16
					elseif string.find(nomeDois2,"HP") and slot == 2 then
					getSlot2 = 17
					elseif string.find(nomeDois2,"MP") and slot == 2 then
					getSlot2 = 18
					end
				elseif string.find(nomeDois1,"MAGIC") and slot == 2 then
					getSlot2 = 19
				elseif string.find(nomeDois1,"DANO") and slot == 2 then
					getSlot2 = 29
				end
			slot = slot-1
		end
		if getSlot2 ~= 0 then
			--print("!HelmetSlots "..getSlot1.." "..getSlot2)
			doPlayerSendCancel(cid, "!HelmetSlots "..getSlot1.." "..getSlot2)
		else
			doPlayerSendCancel(cid, "!HelmetSlots "..getSlot1)
		end
	end
	-----------------------------------ARMOR-----------------------------------
	
		if string.find(getItemAttribute(item.uid, 'name'),"armor") then
			while slot > 0 do
				if string.find(nomeUm1,"SP") and slot == 1 then
					getSlot1 = 5
				elseif string.find(nomeUm1,"HP") and slot == 1 then
					getSlot1 = 6
				elseif string.find(nomeUm1,"MP") and slot == 1 then
					getSlot1 = 7
				elseif string.find(nomeUm1,"REFLECT") and slot == 1 then
					getSlot1 = 8
				elseif string.find(nomeUm1,"ABSORB") and slot == 1 then
					getSlot1 = 9
				elseif string.find(nomeUm1,"BOMB") and slot == 1 then
					if string.find(nomeUm2,"FIRE") and slot == 1 then
					getSlot1 = 10
					elseif string.find(nomeUm2,"ENERGY") and slot == 1 then
					getSlot1 = 11
					elseif string.find(nomeUm2,"ICE") and slot == 1 then
					getSlot1 = 12
					elseif string.find(nomeUm2,"HOLY") and slot == 1 then
					getSlot1 = 13
					elseif string.find(nomeUm2,"DEATH") and slot == 1 then
					getSlot1 = 14
					elseif string.find(nomeUm2,"POISON") and slot == 1 then
					getSlot1 = 15
					end
				elseif string.find(nomeUm1,"REGENERAR") and slot == 1 then
					if string.find(nomeUm2,"SP") and slot == 1 then
					getSlot1 = 16
					elseif string.find(nomeUm2,"HP") and slot == 1 then
					getSlot1 = 17
					elseif string.find(nomeUm2,"MP") and slot == 1 then
					getSlot1 = 18
					end
				elseif string.find(nomeUm1,"MAGIC") and slot == 1 then
					getSlot1 = 19
				elseif string.find(nomeUm1,"DANO") and slot == 1 then
					getSlot1 = 29
				end
				--------------------------------------------------SLOT 2
				if string.find(nomeDois1,"SP") and slot == 2 then
					getSlot2 = 5
				elseif string.find(nomeDois1,"HP") and slot == 2 then
					getSlot2 = 6
				elseif string.find(nomeDois1,"MP") and slot == 2 then
					getSlot2 = 7
				elseif string.find(nomeDois1,"REFLECT") and slot == 2 then
					getSlot2 = 8
				elseif string.find(nomeDois1,"ABSORB") and slot == 2 then
					getSlot2 = 9
				elseif string.find(nomeDois1,"BOMB") and slot == 2 then
					if string.find(nomeDois2,"FIRE") and slot == 2 then
					getSlot2 = 10
					elseif string.find(nomeDois2,"ENERGY") and slot == 2 then
					getSlot2 = 11
					elseif string.find(nomeDois2,"ICE") and slot == 2 then
					getSlot2 = 12
					elseif string.find(nomeDois2,"HOLY") and slot == 2 then
					getSlot2 = 13
					elseif string.find(nomeDois2,"DEATH") and slot == 2 then
					getSlot2 = 14
					elseif string.find(nomeDois2,"POISON") and slot == 2 then
					getSlot2 = 15
					end
				elseif string.find(nomeDois1,"REGENERAR") and slot == 2 then
					if string.find(nomeDois2,"SP") and slot == 2 then
					getSlot2 = 16
					elseif string.find(nomeDois2,"HP") and slot == 2 then
					getSlot2 = 17
					elseif string.find(nomeDois2,"MP") and slot == 2 then
					getSlot2 = 18
					end
				elseif string.find(nomeDois1,"MAGIC") and slot == 2 then
					getSlot2 = 19
				elseif string.find(nomeDois1,"DANO") and slot == 2 then
					getSlot2 = 29
				end
			slot = slot-1
		end
		if getSlot2 ~= 0 then
			--print("!HelmetSlots "..getSlot1.." "..getSlot2)
			doPlayerSendCancel(cid, "@ArmorSlots "..getSlot1.." "..getSlot2)
		else
			doPlayerSendCancel(cid, "@ArmorSlots "..getSlot1)
		end
	end

---------------------------------LEGS---------------------------------
	if string.find(getItemAttribute(item.uid, 'name'),"legs") then
		while slot > 0 do
				if string.find(nomeUm1,"SP") and slot == 1 then
					getSlot1 = 5
				elseif string.find(nomeUm1,"HP") and slot == 1 then
					getSlot1 = 6
				elseif string.find(nomeUm1,"MP") and slot == 1 then
					getSlot1 = 7
				elseif string.find(nomeUm1,"REFLECT") and slot == 1 then
					getSlot1 = 8
				elseif string.find(nomeUm1,"ABSORB") and slot == 1 then
					getSlot1 = 9
				elseif string.find(nomeUm1,"BOMB") and slot == 1 then
					if string.find(nomeUm2,"FIRE") and slot == 1 then
					getSlot1 = 10
					elseif string.find(nomeUm2,"ENERGY") and slot == 1 then
					getSlot1 = 11
					elseif string.find(nomeUm2,"ICE") and slot == 1 then
					getSlot1 = 12
					elseif string.find(nomeUm2,"HOLY") and slot == 1 then
					getSlot1 = 13
					elseif string.find(nomeUm2,"DEATH") and slot == 1 then
					getSlot1 = 14
					elseif string.find(nomeUm2,"POISON") and slot == 1 then
					getSlot1 = 15
					end
				elseif string.find(nomeUm1,"REGENERAR") and slot == 1 then
					if string.find(nomeUm2,"SP") and slot == 1 then
					getSlot1 = 16
					elseif string.find(nomeUm2,"HP") and slot == 1 then
					getSlot1 = 17
					elseif string.find(nomeUm2,"MP") and slot == 1 then
					getSlot1 = 18
					end
				elseif string.find(nomeUm1,"MAGIC") and slot == 1 then
					getSlot1 = 19
				elseif string.find(nomeUm1,"DANO") and slot == 1 then
					getSlot1 = 29
				end
				--------------------------------------------------SLOT 2
				if string.find(nomeDois1,"SP") and slot == 2 then
					getSlot2 = 5
				elseif string.find(nomeDois1,"HP") and slot == 2 then
					getSlot2 = 6
				elseif string.find(nomeDois1,"MP") and slot == 2 then
					getSlot2 = 7
				elseif string.find(nomeDois1,"REFLECT") and slot == 2 then
					getSlot2 = 8
				elseif string.find(nomeDois1,"ABSORB") and slot == 2 then
					getSlot2 = 9
				elseif string.find(nomeDois1,"BOMB") and slot == 2 then
					if string.find(nomeDois2,"FIRE") and slot == 2 then
					getSlot2 = 10
					elseif string.find(nomeDois2,"ENERGY") and slot == 2 then
					getSlot2 = 11
					elseif string.find(nomeDois2,"ICE") and slot == 2 then
					getSlot2 = 12
					elseif string.find(nomeDois2,"HOLY") and slot == 2 then
					getSlot2 = 13
					elseif string.find(nomeDois2,"DEATH") and slot == 2 then
					getSlot2 = 14
					elseif string.find(nomeDois2,"POISON") and slot == 2 then
					getSlot2 = 15
					end
				elseif string.find(nomeDois1,"REGENERAR") and slot == 2 then
					if string.find(nomeDois2,"SP") and slot == 2 then
					getSlot2 = 16
					elseif string.find(nomeDois2,"HP") and slot == 2 then
					getSlot2 = 17
					elseif string.find(nomeDois2,"MP") and slot == 2 then
					getSlot2 = 18
					end
				elseif string.find(nomeDois1,"MAGIC") and slot == 2 then
					getSlot2 = 19
				elseif string.find(nomeDois1,"DANO") and slot == 2 then
					getSlot2 = 29
				end
			slot = slot-1
		end
		if getSlot2 ~= 0 then
			--print("!HelmetSlots "..getSlot1.." "..getSlot2)
			--print("1: "..getSlot1.."\n2: "..getSlot2)
			doPlayerSendCancel(cid, "#LegsSlots "..getSlot1.." "..getSlot2)
		else
			--print("1: "..getSlot1)
			doPlayerSendCancel(cid, "#LegsSlots "..getSlot1)
		end				
	end


-----------------------------BOOTS-----------------------------
	if string.find(getItemAttribute(item.uid, 'name'),"boots") then
		while slot > 0 do
				if string.find(nomeUm1,"SP") and slot == 1 then
					getSlot1 = 5
				elseif string.find(nomeUm1,"HP") and slot == 1 then
					getSlot1 = 6
				elseif string.find(nomeUm1,"MP") and slot == 1 then
					getSlot1 = 7
				elseif string.find(nomeUm1,"REFLECT") and slot == 1 then
					getSlot1 = 8
				elseif string.find(nomeUm1,"ABSORB") and slot == 1 then
					getSlot1 = 9
				elseif string.find(nomeUm1,"BOMB") and slot == 1 then
					if string.find(nomeUm2,"FIRE") and slot == 1 then
					getSlot1 = 10
					elseif string.find(nomeUm2,"ENERGY") and slot == 1 then
					getSlot1 = 11
					elseif string.find(nomeUm2,"ICE") and slot == 1 then
					getSlot1 = 12
					elseif string.find(nomeUm2,"HOLY") and slot == 1 then
					getSlot1 = 13
					elseif string.find(nomeUm2,"DEATH") and slot == 1 then
					getSlot1 = 14
					elseif string.find(nomeUm2,"POISON") and slot == 1 then
					getSlot1 = 15
					end
				elseif string.find(nomeUm1,"REGENERAR") and slot == 1 then
					if string.find(nomeUm2,"SP") and slot == 1 then
					getSlot1 = 16
					elseif string.find(nomeUm2,"HP") and slot == 1 then
					getSlot1 = 17
					elseif string.find(nomeUm2,"MP") and slot == 1 then
					getSlot1 = 18
					end
				elseif string.find(nomeUm1,"MAGIC") and slot == 1 then
					getSlot1 = 19
				elseif string.find(nomeUm1,"DANO") and slot == 1 then
					getSlot1 = 29
				end
				--------------------------------------------------SLOT 2
				if string.find(nomeDois1,"SP") and slot == 2 then
					getSlot2 = 5
				elseif string.find(nomeDois1,"HP") and slot == 2 then
					getSlot2 = 6
				elseif string.find(nomeDois1,"MP") and slot == 2 then
					getSlot2 = 7
				elseif string.find(nomeDois1,"REFLECT") and slot == 2 then
					getSlot2 = 8
				elseif string.find(nomeDois1,"ABSORB") and slot == 2 then
					getSlot2 = 9
				elseif string.find(nomeDois1,"BOMB") and slot == 2 then
					if string.find(nomeDois2,"FIRE") and slot == 2 then
					getSlot2 = 10
					elseif string.find(nomeDois2,"ENERGY") and slot == 2 then
					getSlot2 = 11
					elseif string.find(nomeDois2,"ICE") and slot == 2 then
					getSlot2 = 12
					elseif string.find(nomeDois2,"HOLY") and slot == 2 then
					getSlot2 = 13
					elseif string.find(nomeDois2,"DEATH") and slot == 2 then
					getSlot2 = 14
					elseif string.find(nomeDois2,"POISON") and slot == 2 then
					getSlot2 = 15
					end
				elseif string.find(nomeDois1,"REGENERAR") and slot == 2 then
					if string.find(nomeDois2,"SP") and slot == 2 then
					getSlot2 = 16
					elseif string.find(nomeDois2,"HP") and slot == 2 then
					getSlot2 = 17
					elseif string.find(nomeDois2,"MP") and slot == 2 then
					getSlot2 = 18
					end
				elseif string.find(nomeDois1,"MAGIC") and slot == 2 then
					getSlot2 = 19
				elseif string.find(nomeDois1,"DANO") and slot == 2 then
					getSlot2 = 29
				end
			slot = slot-1
		end
		if getSlot2 ~= 0 then
			--print("!HelmetSlots "..getSlot1.." "..getSlot2)
			doPlayerSendCancel(cid, "$BootsSlots "..getSlot1.." "..getSlot2)
		else
			doPlayerSendCancel(cid, "$BootsSlots "..getSlot1)
		end
	end
end
end


---------------------------------------------------------------------------------------------------------------------------------------

function removeItemSlot(cid,item)
	if string.find(getItemAttribute(item.uid, 'name'),"helmet") then
		return doPlayerSendCancel(cid, "!HelmetSlots 0 0")			
	end

	if string.find(getItemAttribute(item.uid, 'name'),"armor") then
		return doPlayerSendCancel(cid, "!@ArmorSlots 0 0")		
	end

	if string.find(getItemAttribute(item.uid, 'name'),"legs") then
		return doPlayerSendCancel(cid, "#LegsSlots 0 0")		
	end

	if string.find(getItemAttribute(item.uid, 'name'),"boots") then
		return doPlayerSendCancel(cid, "$BootsSlots 0 0")			
	end		
end

-------------------------------Cria o item usando outras 2 funcoes-------------------------------
function DarBonus(tmpItem, slots)--esse slots é a qtd de bonus que irá ter
	local desc = ""
	if getItemAttribute(tmpItem, 'description') ~= nil then
		if string.len(getItemAttribute(tmpItem, 'description')) >= 2 then
			desc = getItemAttribute(tmpItem, 'description')..'\n'
		end
	end

	if slots == 1 then
		local bonusNome = NomeBonus(tmpItem)
		doItemSetAttribute(tmpItem, 'description', desc..'Slot: [ '..ValorBonusSlot(tmpItem)..'% '..bonusNome..' ]')
	elseif slots == 2 then
		local bonusNome = NomeBonus(tmpItem)
		local bonusNome2 = NomeBonus(tmpItem)
		doItemSetAttribute(tmpItem, 'description', desc..'Slot: [ '..ValorBonusSlot(tmpItem)..'% '..bonusNome..' ]\nSlot: [ '..ValorBonusSlot(tmpItem)..'% '..bonusNome2..' ]')
	end
end

-------------------------------Cria um Valor para o Bonus-------------------------------
function ValorBonusSlot(tmpItem)
	local listaPerfeito = {
	   [59] = 5,
	   [30] = 6,
	   [10] = 7,
	   [1] = 8
	}
	local listaMelhorado = {
	   [81] = 5,
	   [18] = 8,
	   [1] = 10
	}
	local listaRaro = {
	   [76] = 8,
	   [18] = 10,
	   [5] = 12,
	   [1] = 15
	}
	local listaLendario = {
	   [51] = 10,
	   [38] = 12,
	   [10] = 15,
	   [1] = 20
	}
	--Valor de i = [] e value = valor do []
	if string.match(getItemAttribute(tmpItem, 'name'),"perfeito") then
		local x = math.random( 1, 100 )
		for i, value in pairs(listaPerfeito) do
	  	 x = x - i
		   	if x <= 0 then
		      	return value
		   	end
		end
	end
	if string.match(getItemAttribute(tmpItem, 'name'),"melhorado") then
		local x = math.random( 1, 100 )
		for i, value in pairs(listaMelhorado) do
	  	 x = x - i
		   	if x <= 0 then
		      	return value
		   	end
		end
	end
	if string.match(getItemAttribute(tmpItem, 'name'),"raro") then
		local x = math.random( 1, 100 )
		for i, value in pairs(listaRaro) do
	  	 x = x - i
		   	if x <= 0 then
		      	return value
		   	end
		end
	end
	if string.match(getItemAttribute(tmpItem, 'name'),"lendario") then
		local x = math.random( 1, 100 )
		for i, value in pairs(listaLendario) do
	  	 x = x - i
		   	if x <= 0 then
		      	return value
		   	end
		end
	end
end

-------------------------------Cria um Valor para o Bonus-------------------------------
function ValorBonus(tmpItem)
	local listaPerfeito = {
	   [50] = 0,
	   [35] = 0,
	   [95] = 1,
	   [5] = 2
	}
	local listaMelhorado = {
	   [76] = 2,
	   [18] = 3,
	   [6] = 4
	}
	local listaRaro = {
	   [76] = 3,
	   [18] = 4,
	   [5] = 5,
	   [1] = 6
	}
	local listaLendario = {
	   [51] = 7,
	   [30] = 8,
	   [15] = 9,
	   [4] = 10
	}
	print("alguem me chamou!")
	--Valor de i = [] e value = valor do []
	if string.match(getItemAttribute(tmpItem, 'name'),"perfeito") then
		local x = math.random( 1, 100 )
		for i, value in pairs(listaPerfeito) do
	  	 x = x - i
		   	if x <= 0 then
		      	return value
		   	end
		end
	end
	if string.match(getItemAttribute(tmpItem, 'name'),"melhorado") then
		local x = math.random( 1, 100 )
		for i, value in pairs(listaMelhorado) do
	  	 x = x - i
		   	if x <= 0 then
		      	return value
		   	end
		end
	end
	if string.match(getItemAttribute(tmpItem, 'name'),"raro") then
		local x = math.random( 1, 100 )
		for i, value in pairs(listaRaro) do
	  	 x = x - i
		   	if x <= 0 then
		      	return value
		   	end
		end
	end
	if string.match(getItemAttribute(tmpItem, 'name'),"lendario") then
		local x = math.random( 1, 100 )
		for i, value in pairs(listaLendario) do
	  	 x = x - i
		   	if x <= 0 then
		      	return value
		   	end
		end
	end
end

-------------------------------Retorna a qtd de Slots-------------------------------
function QtdSlots(tmpItem)
	local qtdBonusPerfeito = {
		[50] = 0,
		[40] = 1,
		[10] = 2
	}
	local qtdBonusMelhorado = {
		[10] = 0,
		[80] = 1,
		[10] = 2
	}
	local qtdBonusRaro = {
		[70] = 1,
		[30] = 2
	}
	local qtdBonusLendario = {
		[100] = 2
	}
	if string.match(getItemAttribute(tmpItem, 'name'),"perfeito") then
		--INICIO QTD DE SLOTS
		local y = math.random( 1, 100 )
		for i, value in pairs(qtdBonusPerfeito) do
	  	 y = y - i
		   	if y <= 0 then
		      	return value
		   	end
		end
	elseif string.match(getItemAttribute(tmpItem, 'name'),"melhorado") then
		--INICIO QTD DE SLOTS
		local y = math.random( 1, 100 )
		for i, value in pairs(qtdBonusMelhorado) do
	  	 y = y - i
		   	if y <= 0 then
		      	return value
		   	end
		end
	elseif string.match(getItemAttribute(tmpItem, 'name'),"raro") then
		--INICIO QTD DE SLOTS
		local y = math.random( 1, 100 )
		for i, value in pairs(qtdBonusRaro) do
	  	 y = y - i
		   	if y <= 0 then
		      	return value
		   	end
		end
	elseif string.match(getItemAttribute(tmpItem, 'name'),"lendario") then
		--INICIO QTD DE SLOTS
		local y = math.random( 1, 100 )
		for i, value in pairs(qtdBonusLendario) do
	  	 y = y - i
		   	if y <= 0 then
		      	return value
		   	end
		end
	else
		return 0
	end
end



-------------------------------DA O NOME DO BONUS-------------------------------
function NomeBonus(tmpItem)
	local listaPerfeito = {
	   [13] = "SP",
	   [12] = "HP",
	   [11] = "MP",
	   [10] = "REFLECT",
	   [9] = "ABSORB",
	   [8] = "BOMB FIRE",
	   [7] = "BOMB ENERGY",
	   [6] = "BOMB ICE",
	   [5] = "BOMB HOLY",
	   [4] = "BOMB DEATH",
	   [3] = "BOMB POISON",
	   [2] = "MAGIC",
	   [1] = "DANO"
	}
	-- local listaPerfeito = {
	--    [16] = "SP",
	--    [15] = "HP",
	--    [14] = "MP",
	--    [13] = "REFLECT",
	--    [12] = "ABSORB",
	--    [11] = "BOMB FIRE",
	--    [10] = "BOMB ENERGY",
	--    [9] = "BOMB ICE",
	--    [8] = "BOMB HOLY",
	--    [7] = "BOMB DEATH",
	--    [6] = "BOMB POISON",
	--    [5] = "REGENERAR SP",
	--    [4] = "REGENERAR HP",
	--    [3] = "REGENERAR MP",
	--    [2] = "MAGIC",
	--    [1] = "DANO"
	-- }
	
	local x = math.random( 1, 100 )
	for i, value in pairs(listaPerfeito) do
	x = x - i
		if x <= 0 then
			return value
		end
	end
end
------------------------------- DA RANDOMICAMENTE UM VALOR PARA ADD NA WEAPON OU ARMOR, ESTA SENDO USADO NO itemstats -------------------------------
function GiveValorRarity(tmpItem)
	local valores = {}
	local raridade = {
		[1] = {"perfeito", 1, 2},
		[2] = {"melhorado", 2, 3},
		[3] = {"raro", 3, 5},
		[4] = {"lendario", 8, 10}
	}
	local raridade_weapon = {
		[1] = {"perfeito", 1, 5},
		[2] = {"melhorado", 5, 10},
		[3] = {"raro", 10, 15},
		[4] = {"lendario", 15, 20}
	}
	
	
	if getItemAttribute(tmpItem, 'weaponType') ~= nil and getItemAttribute(tmpItem, 'armor') >= 1 then
		for _, value in ipairs(raridade) do
			local x = value[1]
			if string.match(getItemAttribute(tmpItem, 'name'), x) then
				local normal_armor = getItemAttribute(tmpItem, 'armor')
				local new_armor = normal_armor + math.random(value[2], value[3])
				doItemSetAttribute(tmpItem, 'armor', new_armor)
				return true
			end
		end
	else
		if getItemAttribute(tmpItem, 'description') ~= nil then
			for _, value in ipairs(raridade_weapon) do
				local x = value[1]
				if string.match(getItemAttribute(tmpItem, 'name'), x) then
					local tmpItemDesc = getItemAttribute(tmpItem, 'description')
					for i in string.gmatch(tmpItemDesc, "%S+") do
						table.insert(valores, i)
					end
					if string.find(valores[2],"]") then
						local min, max = string.match(valores[2], '(%d+)-(%d+)')
						doItemSetAttribute(tmpItem, 'description', 'Dano: [ '..tonumber(min)+math.random(value[2], value[3])..'-'..tonumber(max)+math.random(value[2], value[3])..' ].')
						return true
					end
				end
			end
		end
	end
end
------------------------------- DA RANDOMICAMENTE UM VALOR A SER ADD COMO BONUS Ultrapassado NAO ESTA sendo utilizado -------------------------------
function RandomWhithProbb(min, max)
	local num = math.random(1,100)
	local chance
	local min, max = min, max
	if num >= 50 then -- ruim 50-100 51%
		chance = 1
	elseif num >= 10 and num < 50 then -- comum 10-50 40%
		chance = 2
	elseif num >= 2 and num < 10 then -- medio 2-10 8% 
		chance = 3
	elseif num >= 1 and num < 2 then-- otimo  1 -3 1%
		chance = 4
	end

	local qtd = 1+(max-min)

	if qtd == 2 then
		if chance <= 3 then
			return min
		elseif chance <= 4 then
			return max
		end
	elseif qtd == 3 then
		if chance >=1 and chance <= 2 then
			return min
		elseif chance == 3 then
			return min+1
		elseif chance == 4 then
			return max
		end
	end
end
-----------------------------------RANDOM RARIDADE-----------------------------------
function RandomRarity(tmpItem)
	local raridade = {
		[55] = "",
		[25] = "melhorado",
		[12] = "perfeito",
		[6] = "raro",
		[2] = "lendario"
	}

	local y = math.random( 1, 100 )

	for i, value in pairs(raridade) do
	  	y = y - i
			if y <= 0 then
				--print(value)
				--print(getItemAttribute(tmpItem, 'name'))
				if i == 55 then
					return true
				else
		      		doItemSetAttribute(tmpItem, 'name', value.." "..getItemAttribute(tmpItem, 'name'))
		      		return true
		      	end
		   	end
	end
end




-----------------------------------ATKS BONUS DAMAGE-----------------------------------

function ATK_BOMB_FIRE(cid, armaType, variavelMin, variavelMax)

	if getPlayerStorageValue(cid, VARIAVEL_ATK_BOMB_FIRE) ~= nil and getPlayerStorageValue(cid, VARIAVEL_ATK_BOMB_FIRE) > 1 then
		local fire = getPlayerStorageValue(cid, VARIAVEL_ATK_BOMB_FIRE)
		--print("fire "..fire)
		hit = (math.random(((fire/100)*(variavelMin/1000)),((fire/100)*(variavelMax/1000))) + getPlayerSkillLevel(cid, armaType) / 3)
			--print(hit)
	        return doTargetCombatHealth(cid, target, COMBAT_FIREDAMAGE, -hit, -hit, CONST_ME_FIREATTACK)
	end
end

function ATK_BOMB_ENERGY(cid, armaType, variavelMin, variavelMax)

	if getPlayerStorageValue(cid, VARIAVEL_ATK_BOMB_ENERGY) ~= nil and getPlayerStorageValue(cid, VARIAVEL_ATK_BOMB_ENERGY) > 1 then
		local energy = getPlayerStorageValue(cid, VARIAVEL_ATK_BOMB_ENERGY)
		--print("energy "..energy)
		hit = (math.random(((energy/100)*(variavelMin/1000)),((energy/100)*(variavelMax/1000))) + getPlayerSkillLevel(cid, armaType) / 3)
			--print(hit)
	        return doTargetCombatHealth(cid, target, COMBAT_ENERGYDAMAGE, -hit, -hit, CONST_ME_ENERGYHIT)
	end
end


function ATK_BOMB_ICE(cid, armaType, variavelMin, variavelMax)

	if getPlayerStorageValue(cid, VARIAVEL_ATK_BOMB_ICE) ~= nil and getPlayerStorageValue(cid, VARIAVEL_ATK_BOMB_ICE) > 1 then
		local ice = getPlayerStorageValue(cid, VARIAVEL_ATK_BOMB_ICE)
		--print("ice "..ice)
		hit = (math.random(((ice/100)*(variavelMin/1000)),((ice/100)*(variavelMax/1000))) + getPlayerSkillLevel(cid, armaType) / 3)
			--print(hit)
	        return doTargetCombatHealth(cid, target, COMBAT_ICEDAMAGE, -hit, -hit, CONST_ME_ICEATTACK)
	end
end

function ATK_BOMB_HOLY(cid, armaType, variavelMin, variavelMax)

	if getPlayerStorageValue(cid, VARIAVEL_ATK_BOMB_HOLY) ~= nil and getPlayerStorageValue(cid, VARIAVEL_ATK_BOMB_HOLY) > 1 then
		local holy = getPlayerStorageValue(cid, VARIAVEL_ATK_BOMB_HOLY)
		--print("holy "..holy)
		hit = (math.random(((holy/100)*(variavelMin/1000)),((holy/100)*(variavelMax/1000))) + getPlayerSkillLevel(cid, armaType) / 3)
			--print(hit)
	        return doTargetCombatHealth(cid, target, COMBAT_HOLYDAMAGE, -hit, -hit, CONST_ME_HOLYDAMAGE)
	end
end

function ATK_BOMB_DEATH(cid, armaType, variavelMin, variavelMax)

	if getPlayerStorageValue(cid, VARIAVEL_ATK_BOMB_DEATH) ~= nil and getPlayerStorageValue(cid, VARIAVEL_ATK_BOMB_DEATH) > 1 then
		local death = getPlayerStorageValue(cid, VARIAVEL_ATK_BOMB_DEATH)
		--print("death "..death)
		hit = (math.random(((death/100)*(variavelMin/1000)),((death/100)*(variavelMax/1000))) + getPlayerSkillLevel(cid, armaType) / 3)
			--print(hit)
	        return doTargetCombatHealth(cid, target, COMBAT_DEATHDAMAGE, -hit, -hit, CONST_ME_MORTAREA)
	end
end

function ATK_BOMB_POISON(cid, armaType, variavelMin, variavelMax)

	if getPlayerStorageValue(cid, VARIAVEL_ATK_BOMB_POISON) ~= nil and getPlayerStorageValue(cid, VARIAVEL_ATK_BOMB_POISON) > 1 then
		local poison = getPlayerStorageValue(cid, VARIAVEL_ATK_BOMB_POISON)
		--print("poison "..poison)
		hit = (math.random(((poison/100)*(variavelMin/1000)),((poison/100)*(variavelMax/1000))) + getPlayerSkillLevel(cid, armaType) / 3)
			--print(hit)
	        return doTargetCombatHealth(cid, target, COMBAT_POISONDAMAGE, -hit, -hit, CONST_ME_POISONAREA)
	end
end

---------------------------- Get weapon attack ------------------------------

function GetWeaponAttack(tmpItem)
	--ver se é weapon
	if getItemAttribute(tmpItem, 'weaponType') ~= nil then
		--get desc
		local desc = getItemAttribute(tmpItem, 'description')
		for i in string.gmatch(desc, "%S+") do
			print(i)
			table.insert(valores, i)
		end
		--split attack min and max
		--return min,max
		return true
	end
end


-------------------------------Fim Function.lua-------------------------------
