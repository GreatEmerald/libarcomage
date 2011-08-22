-- CardPools
-- This is the index file that points to the different card pools a user can have
-- GreatEmerald, 2011

-- GE: Mods will have more folders. To activate them, add a line like these pointing to their CardPools.
--dofile('lua/Arcomage/CardPool.lua');
--dofile('lua/MArcomage/MArcomagePool.lua');

PoolInfo = { {Name = "Arcomage", Path = "lua/Arcomage/CardPool.lua"}, {Name = "MArcomage", Path = "lua/MArcomage/MArcomagePool.lua"} }
--PoolSize = #PoolInfo

-- GE: Below are global AI functions. If you change those, the AI in the whole game will change.

function AIAddFacility(Amount, Facilities, Resources, OtherResourcesA, OtherResourcesB)
    local Priority = Amount*0.25
    if Facilities >= 99 then return 0 end
    if Resources <= math.min(GetResourceVictory()*0.25, 15) then Priority = Priority+(0.15*Amount) end
    if Resources >= GetResourceVictory() then Priority = Priority-(0.15*Amount)
    elseif Resources >= GetResourceVictory()*0.75 and (OneResourceVictory or (OtherResourcesA >= GetResourceVictory() and OtherResourcesB >= GetResourceVictory())) then Priority = Priority+(0.15*Amount) end
    if Facilities >= 10 then Priority = Priority-(0.15*Amount) 
    else Priority = Priority+(0.1*Amount) end
    return math.min(Priority, 0.95)
end

function AIAddEnemyFacility(Amount, Facilities, Resources, OtherResourcesA, OtherResourcesB)
    return AIRemoveFacility(Amount, Facilities, Resources, OtherResourcesA, OtherResourcesB)
end

function AIRemoveFacility(Amount, Facilities, Resources, OtherResourcesA, OtherResourcesB)
    local Priority = Amount*(-0.25)
    if Facilities <= 1 then return 0 end
    if Resources <= math.min(GetResourceVictory()*0.25, 15) then Priority = Priority-(0.15*Amount) end
    if Resources >= GetResourceVictory() then Priority = Priority+(0.15*Amount)
    elseif Resources >= GetResourceVictory()*0.75 and (OneResourceVictory or (OtherResourcesA >= GetResourceVictory() and OtherResourcesB >= GetResourceVictory())) then Priority = Priority-(0.15*Amount) end
    if Facilities >= 10 then Priority = Priority+(0.15*Amount) 
    else Priority = Priority-(0.1*Amount) end
    return math.min(Priority, 0.95)
end

function AIRemoveEnemyFacility(Amount, Facilities, Resources, OtherResourcesA, OtherResourcesB)
    local Priority = Amount*0.25
    if Facilities <= 1 then return 0 end
    if Resources <= math.min(GetResourceVictory()*0.25, 15) then Priority = Priority+(0.15*Amount) end
    if Resources >= GetResourceVictory() then Priority = Priority-(0.15*Amount)
    elseif Resources >= GetResourceVictory()*0.75 and (OneResourceVictory or (OtherResourcesA >= GetResourceVictory() and OtherResourcesB >= GetResourceVictory())) then Priority = Priority+(0.15*Amount) end
    if Facility >= 10 then Priority = Priority-(0.15*Amount) 
    else Priority = Priority+(0.1*Amount) end
    return math.min(Priority, 0.95)
end

function AIAddQuarry(Amount)
    return AIAddFacility(Amount, GetQuarry(0), GetBricks(0), GetGems(0), GetRecruits(0))
end

function AIAddEnemyQuarry(Amount)
    return AIAddEnemyFacility(Amount, GetQuarry(1), GetBricks(1), GetGems(1), GetRecruits(1))
end

function AIRemoveQuarry(Amount)
    return AIRemoveFacility(Amount, GetQuarry(0), GetBricks(0), GetGems(0), GetRecruits(0))
end

function AIRemoveEnemyQuarry(Amount)
    return AIRemoveEnemyFacility(Amount, GetQuarry(1), GetBricks(1), GetGems(1), GetRecruits(1))
end

function AIAddMagic(Amount)
    return AIAddFacility(Amount, GetMagic(0), GetGems(0), GetRecruits(0), GetBricks(0))
end

function AIAddEnemyMagic(Amount)
    return AIAddEnemyFacility(Amount, GetMagic(1), GetGems(1), GetRecruits(1), GetBricks(1))
end

function AIRemoveMagic(Amount)
    return AIRemoveFacility(Amount, GetMagic(0), GetGems(0), GetRecruits(0), GetBricks(0))
end

function AIRemoveEnemyMagic(Amount)
    return AIRemoveEnemyFacility(Amount, GetMagic(1), GetGems(1), GetRecruits(1), GetBricks(1))
end

function AIAddDungeon(Amount)
    return AIAddFacility(Amount, GetDungeon(0), GetRecruits(0), GetGems(0), GetBricks(0))
end

function AIAddEnemyDungeon(Amount)
    return AIAddEnemyFacility(Amount, GetDungeon(1), GetRecruits(1), GetGems(1), GetBricks(1))
end

function AIRemoveDungeon(Amount)
    return AIRemoveFacility(Amount, GetDungeon(0), GetRecruits(0), GetGems(0), GetBricks(0))
end

function AIRemoveEnemyDungeon(Amount)
    return AIRemoveEnemyFacility(Amount, GetDungeon(1), GetRecruits(1), GetGems(1), GetBricks(1))
end

function AIAddResources(Amount, Resources, OtherResourcesA, OtherResourcesB)
    local Priority = Amount*0.01
    if Resources >= GetResourceVictory() then Priority = Priority-(0.01*Amount)
    elseif Resources >= GetResourceVictory()*0.75 and (OneResourceVictory or (OtherResourcesA >= GetResourceVictory() and OtherResourcesB >= GetResourceVictory())) then Priority = Priority+(0.01*Amount) end
    return math.min(Priority, 0.95)
end

function AIAddEnemyResources(Amount, Resources, OtherResourcesA, OtherResourcesB)
    return AIRemoveResources(Amount, Resources, OtherResourcesA, OtherResourcesB)
end

function AIRemoveResources(Amount, Resources, OtherResourcesA, OtherResourcesB)
    local Priority = (Amount-math.min(Resources, Amount))*(-0.01)
    if Resources >= GetResourceVictory() then Priority = Priority+(0.01*Amount)
    elseif Resources >= GetResourceVictory()*0.75 and (OneResourceVictory or (OtherResourcesA >= GetResourceVictory() and OtherResourcesB >= GetResourceVictory())) then Priority = Priority-(0.01*Amount) end
    return Priority
end

function AIRemoveEnemyResources(Amount, Resources, OtherResourcesA, OtherResourcesB)
    if Resources < Amount then Amount = Amount-Resources end
    return AIAddResources(Amount, Resources, OtherResourcesA, OtherResourcesB)
end

function AIAddBricks(Amount)
    return AIAddResources(Amount, GetBricks(0), GetRecruits(0), GetGems(0))
end

function AIAddEnemyBricks(Amount)
    return AIAddEnemyResources(Amount, GetBricks(1), GetRecruits(1), GetGems(1))
end

function AIRemoveBricks(Amount)
    return AIRemoveResources(Amount, GetBricks(0), GetRecruits(0), GetGems(0))
end

function AIRemoveEnemyBricks(Amount)
    return AIRemoveEnemyResources(Amount, GetBricks(1), GetGems(1), GetRecruits(1))
end

function AIAddGems(Amount)
    return AIAddResources(Amount, GetGems(0), GetBricks(0), GetRecruits(0))
end

function AIAddEnemyGems(Amount)
    return AIAddEnemyResources(Amount, GetGems(1), GetRecruits(1), GetBricks(1))
end

function AIRemoveGems(Amount)
    return AIRemoveResources(Amount, GetGems(0), GetRecruits(0), GetBricks(0))
end

function AIRemoveEnemyGems(Amount)
    return AIRemoveEnemyResources(Amount, GetGems(1), GetBricks(1), GetRecruits(1))
end

function AIAddRecruits(Amount)
    return AIAddResources(Amount, GetRecruits(0), GetBricks(0), GetGems(0))
end

function AIAddEnemyRecruits(Amount)
    return AIAddEnemyResources(Amount, GetRecruits(1), GetGems(1), GetBricks(1))
end

function AIRemoveRecruits(Amount)
    return AIRemoveResources(Amount, GetRecruits(0), GetBricks(0), GetGems(0))
end

function AIRemoveEnemyRecruits(Amount)
    return AIRemoveEnemyResources(Amount, GetRecruits(1), GetBricks(1), GetGems(1))
end

function AIAddWall(Amount)
    local Priority = Amount*0.01
    if GetWall(0) <= GetMaxWall()*0.25 then Priority = Priority+(Amount*0.01)
    elseif GetWall(0) >= GetMaxWall()*0.75 then Priority = Priority-(Amount*0.01) end
    return math.min(Priority, 0.95)
end

function AIAddEnemyWall(Amount)
    local Priority = Amount*(-0.01)
    if GetWall(1) <= GetMaxWall()*0.25 then Priority = Priority-(Amount*0.01)
    elseif GetWall(1) >= GetMaxWall()*0.75 then Priority = Priority+(Amount*0.01) end
    return math.max(Priority, -0.95)
end

function AIRemoveWall(Amount)
    local Priority = Amount*(-0.01)
    if GetWall(0) >= GetMaxWall()*0.75 or GetWall(0) < Amount then Priority = Priority+(Amount*0.01)
    elseif GetWall(0) <= GetMaxWall()*0.25 then Priority = Priority-(Amount*0.01) end
    return math.min(Priority, 0.95)
end

function AIRemoveEnemyWall(Amount)
    local Priority = Amount*0.01
    if GetWall(1) >= GetMaxWall()*0.75 or GetWall(1) < Amount then Priority = Priority-(Amount*0.01)
    elseif GetWall(1) <= GetMaxWall()*0.25 then Priority = Priority+(Amount*0.01) end
    return math.min(Priority, 0.95)
end

function AIAddTower(Amount)
    if GetTower(0) + Amount >= GetTowerVictory() then return 1 end
    local Priority = Amount*0.02
    if GetTower(0) <= GetTowerVictory()*0.25 or GetTower(0) >= GetTowerVictory()*0.75 then Priority = Priority+(Amount*0.02) end
    return math.min(Priority, 0.95)
end

function AIAddEnemyTower(Amount)
    if GetTower(1) + Amount >= GetTowerVictory() then return -1 end
    local Priority = Amount*(-0.02)
    if GetTower(1) <= GetTowerVictory()*0.25 or GetTower(1) >= GetTowerVictory()*0.75 then Priority = Priority-(Amount*0.02) end
    return math.max(Priority, -0.95)
end

function AIRemoveTower(Amount)
    if GetTower(0) - Amount < 0 then return -1 end
    local Priority = Amount*(-0.02)
    if GetTower(0) <= GetTowerVictory()*0.25 or GetTower(0) >= GetTowerVictory()*0.75 then Priority = Priority+(Amount*(-0.02)) end
    return math.max(Priority, -0.95)
end

function AIRemoveEnemyTower(Amount)
    if GetTower(1) - Amount <= 0 then return 1 end
    local Priority = Amount*0.02
    if GetTower(1) >= GetTowerVictory()*0.75 or GetTower(1) <= GetTowerVictory()*0.25 then Priority = Priority+(Amount*0.02) end
    return math.min(Priority, 0.95)
end

function AIDamageEnemy(Amount)
    return AIRemoveEnemyWall(math.min(Amount, GetWall(1))) + AIRemoveEnemyTower(math.max(Amount-GetWall(1), 0))
end

function AIDamage(Amount)
    return AIRemoveWall(math.min(Amount, GetWall(1))) + AIRemoveTower(math.max(Amount-GetWall(1), 0))
end
