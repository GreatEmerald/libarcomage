-- MArcomage/MArcomagePool
--- The card pool for MArcomage cards
-- @copyright GreatEmerald, 2011, 2014

-- GEm: Requires keyword support
Card
{
    Name = "Absorption";
    Description = "Recruits: +4\nEnemy recruits: -4";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 4;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "card_261f.png", Coordinates = {x = 0, y = 0, w = 80, h = 60}}; -- GEm: ICC issues
    Keywords = "Destruction";
    PlayFunction = function ()
        AddRecruits(0, 4)
        RemoveRecruits(1, 4)
        return 1
    end;
    AIFunction = function ()
        return AIAddRecruits(4) + AIRemoveEnemyRecruits(4)
    end;
}

-- GEm: Requires keyword, black card support
Card
{
    Name = "Abyssal Scavenger";
    Description = "Returns 1/3 of cost of opponent's last card (max 4)";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "card_402.png", Coordinates = {x = 0, y = 0, w = 80, h = 60}};
    Keywords = "Demonic\nFar sight";
    PlayFunction = function ()
        AddBricks(0, math.floor( math.min(GetLastCard(1, "BrickCost")/3, 4)+.5 ) )
        AddGems(0, math.floor( math.min(GetLastCard(1, "GemCost")/3, 4)+.5 ) )
        AddRecruits(0, math.floor( math.min(GetLastCard(1, "RecruitCost")/3, 4)+.5 ) )
        return 1
    end;
    AIFunction = function ()
        Priority = AIAddBricks(math.floor( math.min(GetLastCard(1, "BrickCost")/3, 4)+.5 ) )
        --Priority = Priority + AIAddGems(math.floor( math.min(GetLastCard(1, "GemCost")/3, 4)+.5 ) )
        --Priority = Priority + AIAddRecruits(math.floor( math.min(GetLastCard(1, "RecruitCost")/3, 4)+.5 ) )
        return Priority
    end;
}

-- GEm: Abyssal viper: requires number entry support
-- GEm: Academy: requires keywords, production overrides
-- GEm: Academy of Destruction: requires summoning
-- GEm: Academy of Illusion: requires summoning

-- GEm: Requires keyword support, AI support for removing highest facility
Card
{
    Name = "Acnologia";
    Description = "Enemy tower: -35\nEnemy highest facility: -1";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 45;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "card_710.png", Coordinates = {x = 0, y = 0, w = 80, h = 60}};
    Keywords = "Destruction\nDragon";
    PlayFunction = function ()
        RemoveTower(1, 35)
        RemoveHighestFacility(1, 1)
        return 1
    end;
    AIFunction = function ()
        return AIRemoveEnemyTower(35)
    end;
}

-- GEm: Acolyte: requires cyan card support

-- GEm: Requires keyword support
Card
{
    Name = "Adamantine citadel";
    Description = "Wall: +30\nIf Wall = Max wall\nInstant construction victory\nelse\nBricks: +15";
    Frequency = 1;
    BrickCost = 30;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "card_719.png", Coordinates = {x = 0, y = 0, w = 80, h = 60}};
    Keywords = "Runic";
    PlayFunction = function ()
        AddWall(0, 30)
        if GetWall(0) == GetMaxWall() then
            SetTower(0, GetTowerVictory())
        else
            AddBricks(0, 15)
        end
        return 1
    end;
    AIFunction = function ()
        if GetWall(0) == GetMaxWall() then
            return 1.0
        end
        return math.max(AIAddWall(30)+AIAddBricks(15), 0.95)
    end;
}

-- GEm: Requires keyword support
Card
{
    Name = "Air elemental";
    Description = "Enemy tower: -9";
    Frequency = 2;
    BrickCost = 0;
    GemCost = 10;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "card_204.png", Coordinates = {x = 0, y = 0, w = 80, h = 60}};
    Keywords = "Unliving\nAria";
    PlayFunction = function ()
        RemoveTower(1, 9)
        return 1
    end;
    AIFunction = function ()
        return AIRemoveEnemyTower(9)
    end;
}

-- GEm: Requires keyword support
Card
{
    Name = "Alastor flame of heavens";
    Description = "Gems: +50\nMagic: +1";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 25;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "card_435f.png", Coordinates = {x = 0, y = 0, w = 80, h = 60}}; -- GEm: ICC issues
    Keywords = "Burning\nHoly\nBanish";
    PlayFunction = function ()
        AddGems(0, 50)
        AddMagic(0, 1)
        return 1
    end;
    AIFunction = function ()
        return math.min(AIAddGems(50)+AIAddMagic(1), 0.95)
    end;
}

-- GEm: Requires keyword, black card support
Card
{
    Name = "Alchemist";
    Description = "Bricks:= N\nGems:= N\nRecruits:= N\nN = #Stock / 3";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "card_664.png", Coordinates = {x = 0, y = 0, w = 80, h = 60}};
    Keywords = "Restoration";
    PlayFunction = function ()
        Stock = GetBricks(0)+GetGems(0)+GetRecruits(0)
        SetBricks(0, Stock/3)
        SetGems(0, Stock/3)
        SetRecruits(0, Stock/3)
        return 1
    end;
    AIFunction = function ()
        return 0
    end;
}

-- GEm: Requires keyword support
Card
{
    Name = "Alchemy";
    Description = "Bricks: +2\nRecruits: +2";
    Frequency = 2;
    BrickCost = 0;
    GemCost = 1;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "card_107f.png", Coordinates = {x = 0, y = 0, w = 80, h = 60}};
    Keywords = "Restoration\nDurable";
    PlayFunction = function ()
        AddBricks(0, 2)
        AddRecruits(0, 2)
        return 1
    end;
    AIFunction = function ()
        return AIAddBricks(2)+AIAddRecruits(2)
    end;
}

-- GEm: All-elemental attack: requires white card support
-- GEm: Alucard: requires cyan card, keyword count support
-- GEm: Amazon tribe: requires white card support

-- GEm: Requires keyword support, better AI code
Card
{
    Name = "Amazon warrior";
    Description = "If Enemy wall > 30\nEnemy wall: -10\nAlways:\nAttack: 7";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 6;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "card_651.png", Coordinates = {x = 0, y = 0, w = 80, h = 60}};
    Keywords = "Barbarian";
    PlayFunction = function ()
        if GetWall(1) > 30 then
            RemoveWall(1, 10)
        end
        Damage(1, 7)
        return 1
    end;
    AIFunction = function ()
        Priority = AIDamageEnemy(7)
        if GetWall(1) > 30 then Priority = Priority + AIRemoveEnemyWall(10) end
        return Priority
    end;
}

-- GEm: Ambassador: requires deck support
-- GEm: Ambush: requires modesetting support
-- GEm: Ancient Dragon: requires modesetting support
-- GEm: Ancient Power: requires keyword count support

-- GEm: Requires black card, keyword support
Card
{
    Name = "Ancient ruins";
    Description = "Bricks: +5\nGems: +2\nRecruits: +1";
    Frequency = 2;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "card_146f.png", Coordinates = {x = 0, y = 0, w = 80, h = 60}};
    Keywords = "Runic";
    PlayFunction = function ()
        AddBricks(0, 5)
        AddGems(0, 2)
        AddRecruits(0, 1)
        return 1
    end;
    AIFunction = function ()
        return AIAddBricks(5)+AIAddGems(2)+AIAddRecruits(1)
    end;
}

-- GEm: Ancient sage: requires keyword count support
-- GEm: Angel: requires keyword count support
-- GEm: Angel of Destruction: requires cyan card support

-- GEm: Requires black card support
Card
{
    Name = "Angry mob";
    Description = "Attack: #Facilities\nStock: -2";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "card_299.png", Coordinates = {x = 0, y = 0, w = 80, h = 60}};
    Keywords = "";
    PlayFunction = function ()
        Damage(1, GetQuarry(0)+GetMagic(0)+GetDungeon(0))
        RemoveBricks(0, 2)
        RemoveGems(0, 2)
        RemoveRecruits(0, 2)
        return 1
    end;
    AIFunction = function ()
        return AIDamageEnemy(GetQuarry(0)+GetMagic(0)+GetDungeon(0))+AIRemoveBricks(2)+AIRemoveGems(2)+AIRemoveRecruits(2)
    end;
}

-- GEm: Requires keyword support
Card
{
    Name = "Anomaly sphere";
    Description = "Negates the positive effect of opponent's last round on his tower, wall, facilities and stock";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 10;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "card_390f.png", Coordinates = {x = 0, y = 0, w = 80, h = 60}};
    Keywords = "Illusion";
    PlayFunction = function ()
        RemoveTower(1, GetLastRoundChanges(1, "Tower"))
        RemoveWall(1, GetLastRoundChanges(1, "Wall"))
        RemoveQuarry(1, GetLastRoundChanges(1, "Quarry"))
        RemoveMagic(1, GetLastRoundChanges(1, "Magic"))
        RemoveDungeon(1, GetLastRoundChanges(1, "Dungeon"))
        RemoveBricks(1, GetLastRoundChanges(1, "Bricks"))
        RemoveGems(1, GetLastRoundChanges(1, "Gems"))
        RemoveRecruits(1, GetLastRoundChanges(1, "Recruits"))
        return 1
    end;
    AIFunction = function ()
        Priority = AIRemoveEnemyTower(GetLastRoundChanges(1, "Tower"))
        Priority = Priority + AIRemoveEnemyWall(GetLastRoundChanges(1, "Wall"))
        Priority = Priority + AIRemoveEnemyQuarry(GetLastRoundChanges(1, "Quarry"))
        Priority = Priority + AIRemoveEnemyMagic(GetLastRoundChanges(1, "Magic"))
        Priority = Priority + AIRemoveEnemyDungeon(GetLastRoundChanges(1, "Dungeon"))
        Priority = Priority + AIRemoveEnemyBricks(GetLastRoundChanges(1, "Bricks"))
        Priority = Priority + AIRemoveEnemyGems(GetLastRoundChanges(1, "Gems"))
        Priority = Priority + AIRemoveEnemyRecruits(GetLastRoundChanges(1, "Recruits"))
        return math.min(Priority, 0.95)
    end;
}

-- GEm: Requires keyword, perhaps production override support
Card
{
    Name = "Dark pegasus";
    Description = "If Wall > Enemy wall\nEnemy tower: -8\nelse\nGems prod x2";
    Frequency = 2;
    BrickCost = 0;
    GemCost = 13;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "card_491.png", Coordinates = {x = 0, y = 0, w = 80, h = 60}};
    Keywords = "Swift\nAria";
    PlayFunction = function ()
        if GetWall(0) > GetWall(1) then
            RemoveTower(1, 8)
        else
            AddGems(0, GetMagic(0))
        end
        return 0
    end;
    AIFunction = function ()
        if GetWall(0) > GetWall(1) then
            return AIRemoveEnemyTower(8) end
        return AIAddGems(GetMagic(0))
    end;
}
