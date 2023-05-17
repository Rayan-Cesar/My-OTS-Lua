function onLogout(cid)
    if isPlayer(cid) then
        setPlayerStorageValue(cid, VARIAVEL_REG_HP, 0)
        setPlayerStorageValue(cid, VARIAVEL_REG_SP, 0)
        setPlayerStorageValue(cid, VARIAVEL_REG_MP, 0)
        setPlayerStorageValue(cid, VARIAVEL_SP, 0)
        setPlayerStorageValue(cid, VARIAVEL_HP, 0)
        setPlayerStorageValue(cid, VARIAVEL_MP, 0)
        setPlayerStorageValue(cid, VARIAVEL_ATK_BOMB_FIRE, 0)
        setPlayerStorageValue(cid, VARIAVEL_ATK_BOMB_ENERGY, 0)
        setPlayerStorageValue(cid, VARIAVEL_ATK_BOMB_ICE, 0)
        setPlayerStorageValue(cid, VARIAVEL_ATK_BOMB_HOLY, 0)
        setPlayerStorageValue(cid, VARIAVEL_ATK_BOMB_DEATH, 0)
        setPlayerStorageValue(cid, VARIAVEL_ATK_BOMB_POISON, 0)
        setPlayerStorageValue(cid, VARIAVEL_ATK_MAGICO, 0)
        setPlayerStorageValue(cid, VARIAVEL_ATK_REFLECT, 0)
        setPlayerStorageValue(cid, VARIAVEL_ABSORB, 0)
    end
	return true
end