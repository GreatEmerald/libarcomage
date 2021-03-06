-- MArcomage/MArcomagePool
--- The card pool for MArcomage cards
-- @copyright GreatEmerald, 2011, 2014

-- GEm: Requires keyword support
Card
{
    Name = "Absorption";
    Description = "Recruits: +4\nEnemy recruits: -4";
    Frequency = 13;
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

-- GEm: Requires keyword support
Card
{
    Name = "Abyssal Scavenger";
    Description = "Returns 1/3 of cost of opponent's last card (max 4)";
    Frequency = 13;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Black";
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
    Frequency = 6;
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

-- GEm: Requires keyword support
Card
{
    Name = "Alchemist";
    Description = "Bricks:= N\nGems:= N\nRecruits:= N\nN = #Stock / 3";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Black";
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
    Frequency = 6;
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

-- GEm: Requires keyword support
Card
{
    Name = "All-elemental attack";
    Description = "Attack: #Stock\nStock: = 0";
    Frequency = 1;
    BrickCost = 18;
    GemCost = 18;
    RecruitCost = 18;
    Cursed = false;
    Colour = "White";
    Picture = {File = "card_285.png", Coordinates = {x = 0, y = 0, w = 80, h = 60}};
    Keywords = "Destruction\nNature";
    PlayFunction = function ()
        Damage(1, GetBricks(0)+GetGems(0)+GetRecruits(0))
        SetBricks(0, 0)
        SetGems(0, 0)
        SetRecruits(0, 0)
        return 1
    end;
    AIFunction = function ()
        return AIDamageEnemy(GetBricks(0)+GetGems(0)+GetRecruits(0))
    end;
}

-- GEm: Alucard: requires cyan card, keyword count support
-- GEm: Amazon tribe: requires keyword count support

-- GEm: Requires keyword support, better AI code
Card
{
    Name = "Amazon warrior";
    Description = "If Enemy wall > 30\nEnemy wall: -10\nAlways:\nAttack: 7";
    Frequency = 13;
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

-- GEm: Requires keyword support
Card
{
    Name = "Ancient ruins";
    Description = "Bricks: +5\nGems: +2\nRecruits: +1";
    Frequency = 13;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Black";
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

Card
{
    Name = "Angry mob";
    Description = "Attack: #Facilities\nStock: -2";
    Frequency = 13;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Black";
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
    Frequency = 6;
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

-- GEm: Requires keyword support
Card
{
    Name = "Apocalyptic rain";
    Description = "Attack: N * M / 3\nN = #Bricks\nM = #Magic\nBricks: = 0";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 34;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "card_229f.png", Coordinates = {x = 0, y = 0, w = 80, h = 60}};
    Keywords = "Destruction\nNature";
    PlayFunction = function ()
        Damage(1, GetBricks(0)*GetMagic(0)/3)
        SetBricks(0, 0)
        return 1
    end;
    AIFunction = function ()
        return AIDamageEnemy(GetBricks(0)*GetMagic(0)/3)+AIRemoveBricks(GetBricks(0))
    end;
}

-- GEm: Apostate: requires summoning
-- GEm: Apprentice: requires cyan cards
-- GEm: Arcane Bolt: requires keywords
-- GEm: Arcane tome: requires summoning

-- GEm: Requires keyword support
Card
{
    Name = "Archangel";
    Description = "Tower: +15\nWall: +15\nStock: +15";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 40;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "card_125f.png", Coordinates = {x = 0, y = 0, w = 80, h = 60}};
    Keywords = "Restoration\nFar sight";
    PlayFunction = function ()
        AddTower(0, 15)
        AddWall(0, 15)
        AddBricks(0, 15)
        AddGems(0, 15)
        AddRecruits(0, 15)
        return 1
    end;
    AIFunction = function ()
        return AIAddTower(15)+AIAddWall(15)+AIAddBricks(15)+AIAddGems(15)+AIAddRecruits(15)
    end;
}

-- GEm: Requires keyword support
Card
{
    Name = "Archer";
    Description = "Enemy tower: -3";
    Frequency = 13;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 2;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "card_95f.png", Coordinates = {x = 0, y = 0, w = 80, h = 60}};
    Keywords = "Soldier";
    PlayFunction = function ()
        RemoveTower(1, 3)
        return 1
    end;
    AIFunction = function ()
        return AIRemoveEnemyTower(3)
    end;
}

-- GEm: Architect: requires magenta card support

-- GEm: Requires keyword support
Card
{
    Name = "Architect academy";
    Description = "Tower: +15\nQuarry: +1";
    Frequency = 1;
    BrickCost = 30;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "card_235.png", Coordinates = {x = 0, y = 0, w = 80, h = 60}};
    Keywords = "Durable";
    PlayFunction = function ()
        AddTower(0, 15)
        AddQuarry(0, 1)
        return 1
    end;
    AIFunction = function ()
        return AIAddTower(15)+AIAddQuarry(1)
    end;
}

-- GEm: Architectural improvement: requires summoning
-- GEm: Archmage: requires summoning
-- GEm: Army of darkness: requires keyword counts
-- GEm: Arthoria the Saber: requires summoning

-- GEm: Requires keyword support
Card
{
    Name = "Assassins";
    Description = "Enemy tower: -5\nEnemy stock: -2";
    Frequency = 6;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 7;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "card_244.png", Coordinates = {x = 0, y = 0, w = 80, h = 60}};
    Keywords = "Brigand";
    PlayFunction = function ()
        RemoveTower(1, 5)
        RemoveBricks(1, 2)
        RemoveGems(1, 2)
        RemoveRecruits(1, 2)
        return 1
    end;
    AIFunction = function ()
        return AIRemoveEnemyTower(5)+AIRemoveEnemyBricks(2)+AIRemoveEnemyGems(2)+AIRemoveEnemyRecruits(2)
    end;
}

-- GEm: Atlantis: requires summoning
-- GEm: Auxilia: requires mass discarding and card selection
-- GEm: Avatar of vengeance: requires card selection
-- GEm: Avenger: requires cyan card support
-- GEm: Avenging angel: requires cyan card support
-- GEm: Azure unicorn: requires cyan card support

-- GEm: Requires keyword support
Card
{
    Name = "Bahamut";
    Description = "Enemy wall: -80\nAttack: 150";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 75;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "card_637.png", Coordinates = {x = 0, y = 0, w = 80, h = 60}};
    Keywords = "Dragon\nLegend";
    PlayFunction = function ()
        RemoveWall(1, 80)
        Damage(1, 150)
        return 1
    end;
    AIFunction = function ()
        return AIRemoveEnemyWall(80)+AIDamageEnemy(150 + math.min(GetWall(1), 80))
    end;
}

-- GEm: Baku: requires summoning
-- GEm: Ballistae: requires keyword counts, yellow card support
-- GEm: Balrog: requires summoning, cyan card support
-- GEm: Bank: requires yellow card support
-- GEm: Banshee: requires keyword count, cyan card support
-- GEm: Barbz's hideout: requires rarity count
-- GEm: Barbz's pupil: requires summoning

-- GEm: Requires keyword support
Card
{
    Name = "Baron's keep";
    Description = "Tower: +3\nWall: +7";
    Frequency = 13;
    BrickCost = 10;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "card_289f.png", Coordinates = {x = 0, y = 0, w = 80, h = 60}};
    Keywords = "Far sight";
    PlayFunction = function ()
        AddTower(0, 3)
        AddWall(0, 7)
        return 1
    end;
    AIFunction = function ()
        return AIAddTower(3)+AIAddWall(7)
    end;
}

Card
{
    Name = "Basic wall";
    Description = "If Wall = 0\nWall: +10\nelse\nWall: +3";
    Frequency = 13;
    BrickCost = 1;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "card_1.png", Coordinates = {x = 0, y = 0, w = 80, h = 60}};
    Keywords = "";
    PlayFunction = function ()
        if GetWall(0) <= 0 then
            AddWall(0, 10)
        else
            AddWall(0, 3)
        end
        return 1
    end;
    AIFunction = function ()
        if GetWall(0) <= 0 then return AIAddWall(10) end
        return AIAddWall(3)
    end;
}

-- GEm: Requires keyword support
Card
{
    Name = "Basilisk";
    Description = "Attack: 20\nWall: +10\nQuarry: +1\nEnemy wall: +10\nEnemy quarry: +1";
    Frequency = 6;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 10;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "card_142f.png", Coordinates = {x = 0, y = 0, w = 80, h = 60}};
    Keywords = "Beast";
    PlayFunction = function ()
        Damage(1, 20)
        AddWall(0, 10)
        AddQuarry(0, 1)
        AddWall(1, 10)
        AddQuarry(1, 1)
        return 1
    end;
    AIFunction = function ()
        return AIDamageEnemy(20)+AIAddWall(10)+AIAddQuarry(1)+AIAddEnemyWall(10)+AIAddEnemyQuarry(1)
    end;
}

-- GEm: Requires keyword support
Card
{
    Name = "Battering ram";
    Description = "Enemy wall: -10";
    Frequency = 13;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 5;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "card_54.png", Coordinates = {x = 0, y = 0, w = 80, h = 60}};
    Keywords = "Siege";
    PlayFunction = function ()
        RemoveWall(1, 10)
        return 1
    end;
    AIFunction = function ()
        return AIRemoveEnemyWall(10)
    end;
}

-- GEm: Battle rager: requires keyword counting
-- GEm: Battlements: requires keyword counting
-- GEm: Beast farm: requires summoning

-- GEm: Requires keyword support
Card
{
    Name = "Beast mistress";
    Description = "Attack: 12";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 5;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "card_69.png", Coordinates = {x = 0, y = 0, w = 80, h = 60}};
    Keywords = "Beast\nFrenzy";
    PlayFunction = function ()
        Damage(1, 12)
        return 1
    end;
    AIFunction = function ()
        return AIDamageEnemy(12)
    end;
}

-- GEm: Beastmaster: requires summoning
-- GEm: Benediction: requires keyword counts

-- GEm: Requires keyword support
Card
{
    Name = "Black dragon";
    Description = "Attack: 60\nEnemy recruits: -15";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 43;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "card_127f.png", Coordinates = {x = 0, y = 0, w = 80, h = 60}};
    Keywords = "Dragon";
    PlayFunction = function ()
        Damage(1, 60)
        RemoveRecruits(1, 15)
        return 1
    end;
    AIFunction = function ()
        return AIDamageEnemy(60)+AIRemoveEnemyRecruits(15)
    end;
}

-- GEm: Black market: requires summoning
-- GEm: Black unicorn: requires rarity counts

Card
{
    Name = "Blacksmith";
    Description = "Dungeon: +1";
    Frequency = 6;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 10;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "card_12f.png", Coordinates = {x = 0, y = 0, w = 80, h = 60}};
    Keywords = "";
    PlayFunction = function ()
        AddDungeon(0, 1)
        return 1
    end;
    AIFunction = function ()
        return AIAddDungeon(1)
    end;
}

Card
{
    Name = "Blind guardian";
    Description = "Tower: +12";
    Frequency = 6;
    BrickCost = 4;
    GemCost = 4;
    RecruitCost = 4;
    Cursed = false;
    Colour = "White";
    Picture = {File = "card_231f.png", Coordinates = {x = 0, y = 0, w = 80, h = 60}};
    Keywords = "";
    PlayFunction = function ()
        AddTower(0, 12)
        return 1
    end;
    AIFunction = function ()
        return AIAddTower(12)
    end;
}

-- GEm: Requires keyword support
Card
{
    Name = "Blizzard";
    Description = "Enemy stock: -20";
    Frequency = 6;
    BrickCost = 0;
    GemCost = 32;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "card_241.png", Coordinates = {x = 0, y = 0, w = 80, h = 60}};
    Keywords = "Nature\nAria";
    PlayFunction = function ()
        RemoveBricks(1, 20)
        RemoveGems(1, 20)
        RemoveRecruits(1, 20)
        return 1
    end;
    AIFunction = function ()
        return math.min(AIRemoveEnemyBricks(20)+AIRemoveEnemyGems(20)+AIRemoveEnemyRecruits(20), 0.95)
    end;
}

-- GEm: Requires keyword support
Card
{
    Name = "Blood sacrifice";
    Description = "Magic: -1\nGems: +25";
    Frequency = 6;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 5;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "card_43f.png", Coordinates = {x = 0, y = 0, w = 80, h = 60}};
    Keywords = "Demonic";
    PlayFunction = function ()
        RemoveMagic(0, 1)
        AddGems(0, 25)
        return 1
    end;
    AIFunction = function ()
        return math.min(AIRemoveMagic(1)+AIAddGems(25), 0.95)
    end;
}

-- GEm: Requires keyword support
Card
{
    Name = "Bloody moon";
    Description = "Enemy dungeon: -1";
    Frequency = 6;
    BrickCost = 0;
    GemCost = 12;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "card_29f.png", Coordinates = {x = 0, y = 0, w = 80, h = 60}};
    Keywords = "Destruction";
    PlayFunction = function ()
        RemoveDungeon(1, 1)
        return 1
    end;
    AIFunction = function ()
        return AIRemoveEnemyDungeon(1)
    end;
}

-- GEm: Bone dragon: requires cyan card support
-- GEm: Book of eternity: requires discarding, white card support
-- GEm: Book of life: requires summoning

Card
{
    Name = "Book of magic";
    Description = "Magic: +1";
    Frequency = 6;
    BrickCost = 0;
    GemCost = 12;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "card_34f.png", Coordinates = {x = 0, y = 0, w = 80, h = 60}};
    Keywords = "";
    PlayFunction = function ()
        AddMagic(0, 1)
        return 1
    end;
    AIFunction = function ()
        return AIAddMagic(1)
    end;
}

Card
{
    Name = "Border fortress";
    Description = "Tower: +25\nWall: +50";
    Frequency = 6;
    BrickCost = 45;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "card_276f.png", Coordinates = {x = 0, y = 0, w = 80, h = 60}};
    Keywords = "";
    PlayFunction = function ()
        AddTower(0, 25)
        AddWall(0, 50)
        return 1
    end;
    AIFunction = function ()
        return AIAddTower(25)+AIAddWall(50)
    end;
}

-- GEm: Bounty hunter: requires discarding support
-- GEm: Breeze: requires "new" attribute support

-- GEm: Requires keyword support
Card
{
    Name = "Bronze golem";
    Description = "Enemy wall: -6";
    Frequency = 13;
    BrickCost = 4;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "card_256f.png", Coordinates = {x = 0, y = 0, w = 80, h = 60}};
    Keywords = "Unliving\nBanish";
    PlayFunction = function ()
        RemoveWall(1, 6)
        return 1
    end;
    AIFunction = function ()
        return AIRemoveEnemyWall(6)
    end;
}

-- GEm: Requires keyword support
Card
{
    Name = "Burglar";
    Description = "Attack: 2\nStock: +2\nEnemy stock: -2";
    Frequency = 13;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 8;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "card_260.png", Coordinates = {x = 0, y = 0, w = 80, h = 60}};
    Keywords = "Brigand";
    PlayFunction = function ()
        Damage(1, 2)
        AddBricks(0, 2)
        AddGems(0, 2)
        AddRecruits(0, 2)
        RemoveBricks(1, 2)
        RemoveGems(1, 2)
        RemoveRecruits(1, 2)
        return 1
    end;
    AIFunction = function ()
        return AIDamageEnemy(2)+AIAddBricks(2)+AIAddGems(2)+AIAddRecruits(2)+AIRemoveEnemyBricks(2)+AIRemoveEnemyGems(2)+AIRemoveEnemyRecruits(2)
    end;
}

-- GEm: Byakko: requires production changes, keyword support
