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
    Picture = {File = "card_261.png", Coordinates = {x = 0, y = 0, w = 80, h = 60}};
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

-- GEm: Requires keyword support
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
