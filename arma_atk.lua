--local condition = createConditionObject(CONDITION_POISON)
--setConditionParam(condition, CONDITION_PARAM_DELAYED, 1)
--addDamageCondition(condition, 10, 2000, -1)
--setCombatCondition(combat, condition)

local armaType = SKILL_PISTOLA


function onUseWeapon(cid, var)
local variavelMin, variavelMax = getPlayerStorageValue(cid,VARIAVEL_MIN), getPlayerStorageValue(cid,VARIAVEL_MAX)
local left = getPlayerSlotItem(cid, CONST_SLOT_LEFT)
	if left.itemid and WEAPON_LIST[left.itemid] then
		ammo = getPlayerSlotItem(cid, CONST_SLOT_AMMO)
		if WEAPON_LIST[left.itemid]["ammo"] == ammo.itemid then -- troque pelo id da bala
			doPlayerRemoveItem(cid,municao, 0)--REMOVER A BALA 1
			target = getCreatureTarget(cid)
			if (target <= 0) then
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_DEFAULT, "Selecione um target.")
				return false
			end
			--hit = (math.random(variavelMin,variavelMax) + getPlayerSkillLevel(cid, armaType) / 3)
			hit = (math.random(variavelMin/1000,variavelMax/1000) + getPlayerSkillLevel(cid, armaType) / 3)
	        doTargetCombatHealth(cid, target, COMBAT_PHYSICALDAMAGE, -hit, -hit, CONST_ME_DRAWBLOOD)
	        doSendDistanceShoot(getCreaturePos(cid), getCreaturePos(target), CONST_ANI_BOLT)
	        ATK_BOMB_FIRE(cid, armaType, variavelMin, variavelMax)
	        ATK_BOMB_ENERGY(cid, armaType, variavelMin, variavelMax)
	        ATK_BOMB_ICE(cid, armaType, variavelMin, variavelMax)
	        ATK_BOMB_HOLY(cid, armaType, variavelMin, variavelMax)
	        ATK_BOMB_DEATH(cid, armaType, variavelMin, variavelMax)
	        ATK_BOMB_POISON(cid, armaType, variavelMin, variavelMax)
	        --print("---")

	        return true
		end
		doPlayerSendCancel(cid, "Você não possui balas.")
		return false
		else
		return false
	end
end