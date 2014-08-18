-- A Touhou-themed pool for Arcomage
-- Copyright © GreatEmerald, 2014

Card 
{
    Name = "Moonlight Ray";
    Description = "+1 tower, +1 wall,\n-1 enemy tower,\n-1 enemy wall";
    Frequency = 3;
    BrickCost = 4;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "eosd-11.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
      AddWall(0, 1)
      AddTower(0, 1)
      RemoveTower(1, 1)
      RemoveWall(1, 1)
      return 1
    end;
    AIFunction = function ()
      return AIAddTower(1)+AIAddWall(1)+AIRemoveEnemyTower(1)+AIRemoveEnemyWall(1)
    end;
}

Card 
{
    Name = "Night Bird";
    Description = "+2 recruits, -2 enemy recruits";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 2;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "eosd-12.png", Coordinates = {x = 0, y = 0, w = 342, h = 202}};
    Keywords = "";
    PlayFunction = function ()
      AddRecruits(0, 2)
      RemoveRecruits(1, 2)
      return 1
    end;
    AIFunction = function ()
      return math.min(AIAddRecruits(2)+AIRemoveEnemyRecruits(2), 0.95)
    end;
}

Card 
{
    Name = "Demarcation";
    Description = "+3 wall, -3 enemy wall";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 4;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "eosd-13.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
      AddWall(0, 3);
      RemoveWall(1, 3);
      return 1
    end;
    AIFunction = function ()
      return math.min(AIAddWall(3)+AIRemoveEnemyWall(3), 0.95)
    end;
}

Card 
{
    Name = "Icicle Fall";
    Description = "3 damage, -1 gem";
    Frequency = 3;
    BrickCost = 1;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "icicle.png", Coordinates = {x = 0, y = 0, w = 264, h = 156}};
    Keywords = "";
    PlayFunction = function ()
      RemoveGems(0, 1)
      Damage(1, 4)
      return 1
    end;
    AIFunction = function ()
      return AIRemoveGems(1)+AIDamageEnemy(4)
    end;
}

Card 
{
    Name = "Hailstorm";
    Description = "6 damage, -2 gems";
    Frequency = 3;
    BrickCost = 3;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "eosd-22.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
      RemoveGems(0, 2)
      Damage(1, 6)
      return 1
    end;
    AIFunction = function ()
      return AIRemoveGems(2)+AIDamageEnemy(6)
    end;
}

Card 
{
    Name = "Perfect Freeze";
    Description = "Enemy loses 5 recruits, you gain them as gems";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 5;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "eosd-23.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
      local Frogs = math.min(GetRecruits(1), 5)
      RemoveRecruits(1, Frogs)
      AddGems(0, Frogs)
      return 1
    end;
    AIFunction = function ()
      local Frogs = math.min(GetRecruits(1), 5)
      return math.min(AIRemoveEnemyRecruits(Frogs)+AIAddGems(Frogs), 0.95)
    end;
}

Card 
{
    Name = "Diamond Blizzard";
    Description = "5 damage, +1 tower";
    Frequency = 3;
    BrickCost = 4;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "eosd-24.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
      Damage(1, 5)
      AddTower(0, 1)
      return 1
    end;
    AIFunction = function ()
      return AIDamageEnemy(5)+AIAddTower(1)
    end;
}

Card 
{
    Name = "Gorgeous Flower";
    Description = "+1 dungeon";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 5;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "eosd-31.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
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
    Name = "Selaginella 9";
    Description = "+2 dungeon";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 12;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "eosd-32.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
      AddDungeon(0, 2)
      return 1
    end;
    AIFunction = function ()
      return AIAddDungeon(2)
    end;
}

Card 
{
    Name = "Colourful Rainbow";
    Description = "+5 of each resource";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 3;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "eosd-33.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
      AddBricks(0, 5)
      AddGems(0, 5)
      AddRecruits(0, 5)
      return 1
    end;
    AIFunction = function ()
      return math.min(AIAddBricks(5)+AIAddGems(5)+AIAddRecruits(5), 0.95)
    end;
}

Card 
{
    Name = "Imaginary Vine";
    Description = "5 damage to enemy tower, enemy gains +5 wall";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 2;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "eosd-34.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
      RemoveTower(1, 5)
      AddWall(1, 5)
      return 1
    end;
    AIFunction = function ()
      return math.min(AIRemoveEnemyTower(5)+AIAddEnemyWall(5), 0.95)
    end;
}

Card 
{
    Name = "Colourful Rain";
    Description = "+5 gems to you or enemy";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "eosd-35.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
      if math.random() > 0.5 then
        AddGems(0, 5)
      else
        AddGems(1, 5)
      end
      return 1
    end;
    AIFunction = function ()
      return 0
    end;
}

Card 
{
    Name = "Colour Light Dance";
    Description = "+10 gems";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 2;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "eosd-36.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
      AddGems(0, 10)
      return 1
    end;
    AIFunction = function ()
      return math.min(AIAddGems(10), 0.95)
    end;
}

Card 
{
    Name = "Colour Typhoon";
    Description = "5 damage, +5 gems";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 4;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "eosd-37.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
      Damage(1, 5)
      AddGems(0, 5)
      return 1
    end;
    AIFunction = function ()
      return AIDamageEnemy(5)+AIAddGems(5)
    end;
}

Card 
{
    Name = "Agni Shine";
    Description = "3 damage, +3 tower";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 4;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "eosd-401.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
      Damage(1, 3)
      AddTower(0, 3)
      return 1
    end;
    AIFunction = function ()
      return AIDamageEnemy(3)+AIAddTower(3)
    end;
}

Card 
{
    Name = "Princess Undine";
    Description = "+5 wall, +1 tower";
    Frequency = 3;
    BrickCost = 5;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "eosd-402.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
      AddWall(0, 5)
      AddTower(0, 1)
      return 1
    end;
    AIFunction = function ()
      return AIAddWall(5)+AIAddTower(1)
    end;
}

Card 
{
    Name = "Sylphae Horn";
    Description = "3 damage, +3 recruits";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 4;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "eosd-403.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
      Damage(1, 3)
      AddRecruits(0, 3)
      return 1
    end;
    AIFunction = function ()
      return AIDamageEnemy(3)+AIAddRecruits(3)
    end;
}

Card 
{
    Name = "Rage Trilithon";
    Description = "3 damage, +3 wall";
    Frequency = 3;
    BrickCost = 4;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "eosd-404.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
      Damage(1, 3)
      AddWall(0, 3)
      return 1
    end;
    AIFunction = function ()
      return AIDamageEnemy(3)+AIAddWall(3)
    end;
}

Card 
{
    Name = "Metal Fatigue";
    Description = "6 damage to enemy tower, you lose 3 wall";
    Frequency = 3;
    BrickCost = 6;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "eosd-405.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
      RemoveTower(1, 6)
      RemoveWall(0, 3)
      return 1
    end;
    AIFunction = function ()
      return AIRemoveEnemyTower(6)+AIRemoveWall(3)
    end;
}

Card 
{
    Name = "Agni Shine HL"; -- Agni Shine High Level
    Description = "6 damage, +6 tower";
    Frequency = 2;
    BrickCost = 0;
    GemCost = 12;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "eosd-406.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
      Damage(1, 6)
      AddTower(0, 6)
      return 1
    end;
    AIFunction = function ()
      return AIDamageEnemy(6)+AIAddTower(6)
    end;
}

Card 
{
    Name = "Sylphae Horn HL"; -- Sylphae Horn High Level
    Description = "6 damage, +6 recruits";
    Frequency = 2;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 11;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "eosd-407.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
      Damage(1, 6)
      AddRecruits(0, 6)
      return 1
    end;
    AIFunction = function ()
      return AIDamageEnemy(6)+AIAddRecruits(6)
    end;
}

Card 
{
    Name = "Rage Trilithon HL"; -- Rage Trilithon High Level
    Description = "6 damage, +6 wall";
    Frequency = 2;
    BrickCost = 11;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "eosd-408.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
      Damage(1, 6)
      AddWall(0, 6)
      return 1
    end;
    AIFunction = function ()
      return AIDamageEnemy(6)+AIAddWall(6)
    end;
}

Card 
{
    Name = "Agni Radiance";
    Description = "6 damage to enemy wall, 6 damage";
    Frequency = 2;
    BrickCost = 0;
    GemCost = 14;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "eosd-409.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
      RemoveWall(1, 6)
      Damage(1, 6)
      return 1
    end;
    AIFunction = function ()
      return AIRemoveEnemyWall(6)+AIDamageEnemy(6)
    end;
}

Card 
{
    Name = "Bury In Lake";
    Description = "+10 wall, +2 tower";
    Frequency = 2;
    BrickCost = 14;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "eosd-410.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
      AddWall(0, 10)
      AddTower(0, 2)
      return 1
    end;
    AIFunction = function ()
      return AIAddWall(10)+AIAddTower(2)
    end;
}

Card 
{
    Name = "Green Storm";
    Description = "9 damage, take 3 damage";
    Frequency = 2;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 6;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "eosd-411.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
      Damage(1, 9)
      Damage(0, 3)
      return 1
    end;
    AIFunction = function ()
      return AIDamageEnemy(9)+AIDamage(3)
    end;
}

Card 
{
    Name = "Trilithon Shake";
    Description = "6 damage to enemy tower, +1 quarry";
    Frequency = 2;
    BrickCost = 12;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "eosd-412.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
      RemoveTower(1, 6)
      AddQuarry(0, 1)
      return 1
    end;
    AIFunction = function ()
      return AIRemoveEnemyTower(6)+AIAddQuarry(6)
    end;
}

Card 
{
    Name = "Silver Dragon";
    Description = "6 damage to enemy tower, +3 wall";
    Frequency = 2;
    BrickCost = 8;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "eosd-413.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
      RemoveTower(1, 6)
      AddWall(0, 3)
      return 1
    end;
    AIFunction = function ()
      return AIRemoveEnemyTower(6)+AIAddWall(3)
    end;
}

Card 
{
    Name = "Lava Cromlech";
    Description = "6 damage, +3 tower, +3 wall";
    Frequency = 2;
    BrickCost = 0;
    GemCost = 11;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "eosd-414.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
      Damage(1, 6)
      AddTower(0, 3)
      AddWall(0, 3)
      return 1
    end;
    AIFunction = function ()
      return AIDamageEnemy(6)+AIAddTower(3)+AIAddWall(3)
    end;
}

Card 
{
    Name = "Forest Blaze";
    Description = "3 damage, enemy loses 3 recruits";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 4;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "eosd-415.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
      Damage(1, 3)
      RemoveRecruits(1, 3)
      return 1
    end;
    AIFunction = function ()
      return AIDamageEnemy(3)+AIRemoveEnemyRecruits(3)
    end;
}

Card 
{
    Name = "Water Elf";
    Description = "+3 tower, +3 recruits";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 4;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "eosd-416.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
      AddTower(0, 3)
      AddRecruits(0, 3)
      return 1
    end;
    AIFunction = function ()
      return AIAddTower(3)+AIAddRecruits(3)
    end;
}

Card 
{
    Name = "Mercury Poison";
    Description = "6 damage to enemy tower, -1 enemy dungeon";
    Frequency = 2;
    BrickCost = 11;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "eosd-417.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
      RemoveTower(1, 6)
      RemoveDungeon(1, 1)
      return 1
    end;
    AIFunction = function ()
      return AIRemoveEnemyTower(6)+AIRemoveEnemyDungeon(1)
    end;
}

Card 
{
    Name = "Emerald Megalith";
    Description = "+6 tower, +6 wall";
    Frequency = 2;
    BrickCost = 13;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "eosd-418.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
      AddTower(0, 6)
      AddWall(0, 6)
      return 1
    end;
    AIFunction = function ()
      return AIAddTower(6)+AIAddWall(6)
    end;
}

Card 
{
    Name = "Misdirection";
    Description = "If enemy tower < enemy wall, 6 damage to enemy tower\nElse 6 damage";
    Frequency = 2;
    BrickCost = 0;
    GemCost = 10;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "eosd-51.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
      if GetTower(1) < GetWall(1) then
        RemoveTower(1, 6)
      else
        Damage(1, 6)
      end
      return 1
    end;
    AIFunction = function ()
      if GetTower(1) < GetWall(1) then return AIRemoveEnemyTower(6) end
      return AIDamageEnemy(6)
    end;
}

Card 
{
    Name = "Illusion Misdirection"; --Illusional Misdirection
    Description = "If enemy tower > enemy wall, 6 damage to enemy tower\nElse 6 damage";
    Frequency = 2;
    BrickCost = 0;
    GemCost = 10;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "eosd-52.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
      if GetTower(1) > GetWall(1) then
        RemoveTower(1, 6)
      else
        Damage(1, 6)
      end
      return 1
    end;
    AIFunction = function ()
      if GetTower(1) > GetWall(1) then return AIRemoveEnemyTower(6) end
      return AIDamageEnemy(6)
    end;
}

Card 
{
    Name = "Clock Corpse";
    Description = "+5 tower, play again";
    Frequency = 2;
    BrickCost = 0;
    GemCost = 8;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "eosd-53.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
      AddTower(0, 5)
      return 0
    end;
    AIFunction = function ()
      return AIAddTower(5)
    end;
}

Card 
{
    Name = "Luna Clock";
    Description = "+1 magic, play again";
    Frequency = 2;
    BrickCost = 0;
    GemCost = 8;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "eosd-54.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
      AddMagic(0, 1)
      return 0
    end;
    AIFunction = function ()
      return AIAddMagic(1)
    end;
}

Card 
{
    Name = "Marionette";
    Description = "50% chance to do 10 damage, play again";
    Frequency = 2;
    BrickCost = 0;
    GemCost = 4;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "eosd-55.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
      if math.random() > 0.5 then
        Damage(1, 10)
      end
      return 0
    end;
    AIFunction = function ()
      return AIDamageEnemy(10)/2
    end;
}

Card 
{
    Name = "Jack the Ludo Bile";
    Description = "+10 wall, play again";
    Frequency = 2;
    BrickCost = 0;
    GemCost = 13;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "eosd-56.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
      AddWall(0, 10)
      return 0
    end;
    AIFunction = function ()
      return AIAddWall(10)
    end;
}

Card 
{
    Name = "The World";
    Description = "Get wall opposite your tower height% up to 20\nPlay again";
    Frequency = 2;
    BrickCost = 11;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "eosd-57.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
      local TowerRatio = GetTower(0)/GetTowerVictory()
      AddWall(0, (1-TowerRatio)*20)
      return 0
    end;
    AIFunction = function ()
      local TowerRatio = GetTower(0)/GetTowerVictory()
      return math.min(AIAddWall((1-TowerRatio)*20), 0.95)
    end;
}

Card 
{
    Name = "Killing Doll";
    Description = "10 damage or +10 tower, play again";
    Frequency = 2;
    BrickCost = 0;
    GemCost = 11;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "eosd-58.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
      if math.random() > 0.5 then
        Damage(1, 10)
      else
        AddTower(0, 10)
      end
      return 0
    end;
    AIFunction = function ()
      return AIDamageEnemy(10)/2 + AIAddTower(10)/2
    end;
}
