
---------------------------By Zefz ---------------------------
function onUse(cid, item, fromPosition, itemEx, toPosition)

local slot = {
[5] = "SP",
[6] = "HP",
[7] = "MP",
[8] = "REFLECT",
[9] = "ABSORVER",
[10] = "BOMB FIRE",
[11] = "BOMB ENERGY",
[12] = "BOMB ICE",
[13] = "BOMB HOLY",
[14] = "BOMB DEATH",
[15] = "BOMB POISON",
[16] = "REGENERAR SP",
[17] = "REGENERAR HP",
[18] = "REGENERAR MP",
[19] = "MAGIC",
[20] = "DANO"
}

local dmg = {
	[1] = 19,
	[2] = 20,
	[3] = 21,
	[4] = 22,
	[5] = 23,
	[6] = 24,
	[7] = 25,
	[8] = 26,
	[9] = 27,
	[10] = 28
}

local mg = {
	[1] = 29,
	[2] = 30,
	[3] = 31,
	[4] = 32,
	[5] = 33,
	[6] = 34,
	[7] = 35,
	[8] = 36,
	[9] = 37,
	[10] = 38
}

local sets = {
	[1000] = "rookie",
	[3000] = "reinforced",
	[5000] = "noobie",
	[8000] = "leather",
	[10000] = "dragon",
	[12000] = "moon",
	[14000] = "soldier",
	[15000] = "weed",
	[16000] = "skull",
	[10] = "tiger",
	[11] = "plate",
	[12] = "crown",
	[13] = "brass",
	[14] = "noble",
	[15] = "silver",
	[16] = "nature",
	[17] = "mystic",
	[18] = "royal",
	[19] = "remains",
	[20] = "titan",
	[21] = "glorious",
	[22] = "ancient",
	[23] = "crystal",
	[24] = "lava",
	[25] = "haze",
	[26] = "royalty",
	[27] = "eyed",
	[28] = "reaper",
	[29] = "templar"
}


	if getItemAttribute(itemEx.uid, 'name') ~=nil and (string.find(getItemAttribute(itemEx.uid, 'name'),"helmet") or string.find(getItemAttribute(itemEx.uid, 'name'),"armor") or string.find(getItemAttribute(itemEx.uid, 'name'),"legs") or string.find(getItemAttribute(itemEx.uid, 'name'),"boots")) then
		local tmpItemDesc = getItemAttribute(itemEx.uid, 'description')
		local nomeUm1,nomeUm2,nomeDois1,nomeDois2,mark,valor,valor2,v1,v2,price
		local valores = {}
		local z = itemEx.uid
		local slotItem = -1

		if slot ~= nil then
		for i in string.gmatch(tmpItemDesc, "%S+") do
			table.insert(valores, i)
		end
		

		if string.find(valores[4],"]") then--nao tem o slot
						nomeUm1 = 0
						nomeUm2 = 0
						
						mark = 0
						valor = 0
					elseif string.find(valores[5],"]") then--nome do 1 slot nao é composto
						nomeUm1 = valores[4]
						nomeUm2 = 0
						
						mark = 0
						valor = tonumber(string.match(valores[3], '%d+'))
					else
						nomeUm1 = valores[4]
						nomeUm2 = valores[5]
						
						mark = 1
						valor = tonumber(string.match(valores[3], '%d+'))
		end



					if (mark == 0 and valores[9] == nil) or string.find(valores[9],"]") then--nao tem o slot
						nomeDois1 = 0
						nomeDois2 = 0
						
						valor2 = 0
					elseif mark == 0 and string.find(valores[10],"]") then--nome do 1 slot nao é composto
						nomeDois1 = valores[9]
						nomeDois2 = 0
						
						valor2 = tonumber(string.match(valores[8], '%d+'))
					elseif mark == 0 and string.find(valores[11],"]") then
						nomeDois1 = valores[9]
						nomeDois2 = valores[10]
						
						valor2 = tonumber(string.match(valores[9], '%d+'))
					elseif mark == 1 and string.find(valores[10],"]") then
						nomeDois1 = 0
						nomeDois2 = 0
						
						valor2 = tonumber(string.match(valores[8], '%d+'))
					elseif mark == 1 and string.find(valores[11],"]") then
						nomeDois1 = valores[10]
						nomeDois2 = 0
						
						valor2 = tonumber(string.match(valores[9], '%d+'))
					elseif mark == 1 and string.find(valores[12],"]") then
						nomeDois1 = valores[10]
						nomeDois2 = valores[11]
						
						valor2 = tonumber(string.match(valores[9], '%d+'))
		end

		for i, v in pairs(slot) do

					if nomeUm1 == "DANO" then
						for g, value in pairs(mg) do
							if g == valor then
								v1 = value
							end
						end

					elseif nomeUm1 == "MAGIC" then
						for h, value in pairs(dmg) do
							if h == valor then
								v1 = value
							end
						end
						
					else
						if nomeUm1 == v then
							v1 = i
						end 
					end
					if nomeDois1 == "DANO" then
						for g, value in pairs(mg) do
							if g == valor then
								v2 = value
							end
						end

					elseif nomeDois1 == "MAGIC" then
						for h, value in pairs(dmg) do
							if h == valor then
								v2 = value
							end
						end
						
					else
						if nomeDois1 == v then
							v2 = i
						end 
					end
					if v2 == nil then
						v2 = 0
					end
			end
			if v1 == nil and v2 == nil then
				v1 = 0
				v2 = 0
			end
			-- for s, value in pairs(sets) do
			-- 	if getItemAttribute(itemEx.uid, 'name') ~= nil and string.find(getItemAttribute(itemEx.uid, 'name'),value) then
			-- 		price = s
			-- 	end
			-- end

		if getPlayerSlotItem(cid, CONST_SLOT_HEAD).uid == itemEx.uid then
			slotItem = CONST_SLOT_HEAD
		elseif getPlayerSlotItem(cid, CONST_SLOT_ARMOR).uid == itemEx.uid then
			slotItem = CONST_SLOT_ARMOR
		elseif getPlayerSlotItem(cid, CONST_SLOT_LEGS).uid == itemEx.uid then
			slotItem = CONST_SLOT_LEGS
		elseif getPlayerSlotItem(cid, CONST_SLOT_FEET).uid == itemEx.uid then
			slotItem = CONST_SLOT_FEET
		end

		if slotItem >= 0 then
			local custo = 500
			setPlayerStorageValue(cid,VARIAVEL_SLOTAR_ITEM_SLOT, slotItem)
			setPlayerStorageValue(cid,VARIAVEL_SLOTAR_NAME, getItemAttribute(itemEx.uid, 'name'))
			setPlayerStorageValue(cid,VARIAVEL_SLOTAR_ARMOR, getItemAttribute(itemEx.uid, 'armor'))
			doPlayerSendCancel(cid, "$Slotar "..itemEx.itemid.." "..custo)
			doPlayerSendCancel(cid, "#OPENSLOTAR 1 "..v1.." "..v2.." "..itemEx.itemid.." "..custo)--mod aqui final
		else
			doPlayerSendTextMessage(cid, 25,"Você precisa estar com este item equipado!")
		end
	else
		doPlayerSendCancel(cid, "Item Invalido.")
	end
end
return true
end













			