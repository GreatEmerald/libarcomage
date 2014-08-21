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

Card
{
    Name = "Eternal Meek";
    Description = "If tower < 10, +10 tower, else +10 wall";
    Frequency = 2;
    BrickCost = 0;
    GemCost = 9;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "eosd-601.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
        if GetTower(0) < 10 then
            AddTower(0, 10)
        else
            AddWall(0, 10)
        end
        return 1
    end;
    AIFunction = function ()
        if GetTower(0) < 10 then return AIAddTower(10) end
        return math.min(AIAddWall(10), 0.95)
    end;
}

Card
{
    Name = "Star of David";
    Description = "+2 Magic, lose 3 gems";
    Frequency = 2;
    BrickCost = 0;
    GemCost = 4;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "eosd-602.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
        AddMagic(0, 2)
        RemoveGems(0, 3)
        return 1
    end;
    AIFunction = function ()
        return math.min(AIAddMagic(2)+AIRemoveGems(3), 0.95)
    end;
}

Card
{
    Name = "Scarlet Netherworld";
    Description = "+1 dungeon, enemy loses 10 recruits";
    Frequency = 2;
    BrickCost = 0;
    GemCost = 9;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "eosd-603.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
        AddDungeon(0, 1)
        RemoveRecruits(1, 10)
        return 1
    end;
    AIFunction = function ()
        return math.min(AIAddDungeon(1)+AIRemoveEnemyRecruits(10), 0.95)
    end;
}

Card
{
    Name = "Curse of Vlad Tepes";
    Description = "-6 enemy tower, -6 enemy recruits, cannot discard";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 9;
    RecruitCost = 0;
    Cursed = true;
    Colour = "Blue";
    Picture = {File = "eosd-604.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
        RemoveTower(1, 6)
        RemoveRecruits(1, 6)
        return 1
    end;
    AIFunction = function ()
        return AIRemoveEnemyTower(6)+AIRemoveEnemyRecruits(6)
    end;
}

Card
{
    Name = "Scarlet Shoot";
    Description = "15 damage to enemy tower, -1 enemy quarry";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 19;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "eosd-605.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
        RemoveQuarry(1, 1)
        RemoveTower(1, 15)
        return 1
    end;
    AIFunction = function ()
        return AIRemoveEnemyTower(15)+AIRemoveEnemyQuarry(1)
    end;
}

Card
{
    Name = "Red Magic";
    Description = "10 damage, +10 tower, +1 magic";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 21;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "eosd-605.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
        Damage(1, 10)
        AddTower(0, 10)
        AddMagic(0, 1)
        return 1
    end;
    AIFunction = function ()
        return AIDamageEnemy(10)+AIAddTower(10)+AIAddMagic(1)
    end;
}

Card
{
    Name = "Young Demon Lord";
    Description = "+1 dungeon and 10 recruits, enemy loses 1 dungeon";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 12;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "eosd-607.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
        RemoveDungeon(1, 1)
        AddRecruits(0, 10)
        AddDungeon(0, 1)
        return 1
    end;
    AIFunction = function ()
        return math.min(AIRemoveEnemyDungeon(1)+AIAddRecruits(10)+AIAddDungeon(1), 0.95)
    end;
}

Card
{
    Name = "Thousand Needles"; --Mountain of a Thousand Needles
    Description = "+20 wall, +1 quarry";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 22;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "eosd-608.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
        AddWall(0, 20)
        AddQuarry(0, 1)
        return 1
    end;
    AIFunction = function ()
        return math.min(AIAddWall(20)+AIAddQuarry(1), 0.95)
    end;
}

Card
{
    Name = "Vampire Illusion";
    Description = "+10 wall, enemy loses 10 recruits and 1 dungeon";
    Frequency = 1;
    BrickCost = 20;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "eosd-609.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
        AddWall(0, 10)
        RemoveDungeon(1, 1)
        RemoveRecruits(1, 10)
        return 1
    end;
    AIFunction = function ()
        return math.min(AIAddWall(10)+AIRemoveEnemyDungeon(1)+AIRemoveEnemyRecruits(10), 0.95)
    end;
}

Card
{
    Name = "Scarlet Meister";
    Description = "10 damage, +1 facilities";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 18;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "eosd-610.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
        Damage(1, 10)
        AddDungeon(0, 1)
        AddMagic(0, 1)
        AddQuarry(0, 1)
        return 1
    end;
    AIFunction = function ()
        return AIDamageEnemy(10)+AIAddDungeon(1)+AIAddMagic(1)+AIAddQuarry(1)
    end;
}

Card
{
    Name = "Scarlet Gensokyo";
    Description = "+10 wall, +2 magic, 10 damage to enemy tower";
    Frequency = 1;
    BrickCost = 23;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "eosd-611.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
        AddWall(0, 10)
        AddMagic(0, 2)
        RemoveTower(1, 10)
        return 1
    end;
    AIFunction = function ()
        return AIAddWall(10)+AIRemoveEnemyTower(10)+AIAddMagic(2)
    end;
}

Card
{
    Name = "Silent Selene";
    Description = "+20 wall";
    Frequency = 1;
    BrickCost = 18;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "eosd-701.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
        AddWall(0, 20)
        return 1
    end;
    AIFunction = function ()
        return math.min(AIAddWall(20), 0.95)
    end;
}

Card
{
    Name = "Royal Flare";
    Description = "+1 Magic, +10 tower, -10 enemy tower";
    Frequency = 1;
    BrickCost = 23;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "eosd-702.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
        AddTower(0, 10)
        AddMagic(0, 1)
        RemoveTower(1, 10)
        return 1
    end;
    AIFunction = function ()
        return AIAddTower(10)+AIRemoveEnemyTower(10)+AIAddMagic(1)
    end;
}

Card
{
    Name = "Philosopher's Stone";
    Description = "9 damage, +9 of each resource";
    Frequency = 1;
    BrickCost = 18;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "eosd-703.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
        Damage(1, 9)
        AddBricks(0, 9)
        AddGems(0, 9)
        AddRecruits(0, 9)
        return 1
    end;
    AIFunction = function ()
        return AIDamageEnemy(9)+AIAddBricks(9)+AIAddGems(9)+AIAddRecruits(9)
    end;
}

Card
{
    Name = "Cranberry Trap";
    Description = "If dungeon > 4, 50 damage, else 15 damage";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 18;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "eosd-704.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
        if GetDungeon(0) > 4 then
            Damage(1, 50)
        else
            Damage(1, 15)
        end
        return 1
    end;
    AIFunction = function ()
        if GetDungeon(0) > 4 then return AIDamageEnemy(50) end
        return AIDamageEnemy(15)
    end;
}

Card
{
    Name = "Laevateinn";
    Description = "If wall > enemy tower, -30 enemy tower, else wall";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 25;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "eosd-705.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
        if GetWall(0) > GetTower(1) then
            RemoveTower(1, 30)
        else
            RemoveWall(1, 30)
        end
        return 1
    end;
    AIFunction = function ()
        if GetWall(0) > GetTower(1) then return AIRemoveEnemyTower(30) end
        return math.min(AIRemoveEnemyWall(30), 0.95)
    end;
}

Card
{
    Name = "Four of a Kind";
    Description = "Both castles = highest tower or wall";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 9;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "eosd-706.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
        local Clone = math.max(GetTower(0), GetTower(1), GetWall(0), GetWall(1))
        SetWall(0, Clone)
        SetWall(1, Clone)
        SetTower(0, Clone)
        SetTower(1, Clone)
        return 1
    end;
    AIFunction = function ()
        local Clone = math.max(GetTower(0), GetTower(1), GetWall(0), GetWall(1))
        return math.min(AIAddTower(Clone-GetTower(0))+AIAddWall(Clone-GetWall(0))+AIAddEnemyTower(Clone-GetTower(1))+AIAddEnemyWall(Clone-GetWall(1)), 0.95)
    end;
}

Card
{
    Name = "Kagome, Kagome";
    Description = "Switch facilities with the enemy";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 9;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "eosd-707.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
        local Illuminati = GetQuarry(0)
        local MajecticTwelve = GetMagic(0)
        local Templars = GetDungeon(0)
        SetQuarry(0, GetQuarry(1))
        SetQuarry(1, Illuminati)
        SetMagic(0, GetMagic(1))
        SetMagic(1, MajecticTwelve)
        SetDungeon(0, GetDungeon(1))
        SetDungeon(1, Templars)
        return 1
    end;
    AIFunction = function ()
        local Result = 0
        if GetQuarry(0) > GetQuarry(1) then
            Result = Result + AIRemoveQuarry(GetQuarry(0)-GetQuarry(1)) + AIAddEnemyQuarry(GetQuarry(0)-GetQuarry(1))
        else
            Result = Result + AIRemoveEnemyQuarry(GetQuarry(1)-GetQuarry(0)) + AIAddQuarry(GetQuarry(1)-GetQuarry(0))
        end
        if GetMagic(0) > GetMagic(1) then
            Result = Result + AIRemoveMagic(GetMagic(0)-GetMagic(1)) + AIAddEnemyMagic(GetMagic(0)-GetMagic(1))
        else
            Result = Result + AIRemoveEnemyMagic(GetMagic(1)-GetMagic(0)) + AIAddMagic(GetMagic(1)-GetMagic(0))
        end
        if GetDungeon(0) > GetDungeon(1) then
            Result = Result + AIRemoveDungeon(GetDungeon(0)-GetDungeon(1)) + AIAddEnemyDungeon(GetDungeon(0)-GetDungeon(1))
        else
            Result = Result + AIRemoveEnemyDungeon(GetDungeon(1)-GetDungeon(0)) + AIAddDungeon(GetDungeon(1)-GetDungeon(0))
        end
        return math.min(Result, 0.95)
    end;
}

Card
{
    Name = "Maze of Love";
    Description = "+20 tower";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 21;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "eosd-708.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
        AddTower(0, 20)
        return 1
    end;
    AIFunction = function ()
        return AIAddTower(20)
    end;
}

Card
{
    Name = "Starbow Break";
    Description = "Random resource +20";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 10;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "eosd-709.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
        local Luck = math.random(3)
        if Luck == 1 then
            AddBricks(0, 20)
        elseif Luck == 2 then
            AddGems(0, 20)
        else
            AddRecruits(0, 20)
        end
        return 1
    end;
    AIFunction = function ()
        return math.min(AIAddGems(20)/3 + AIAddBricks(20)/3 + AIAddRecruits(20)/3, 0.95)
    end;
}

Card
{
    Name = "Catadioptric";
    Description = "Tower +4*magic, enemy tower +2*magic";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 6;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "eosd-710.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
        AddTower(0, 4*GetMagic(0))
        AddTower(1, 2*GetMagic(0))
        return 1
    end;
    AIFunction = function ()
        return AIAddTower(4*GetMagic(0)) + AIAddEnemyTower(2*GetMagic(0))
    end;
}

Card
{
    Name = "Counter Clock"; --Clock that Ticks Away the Past
    Description = "If wall > half max wall, #wall damage, else +10 tower";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 15;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "eosd-711.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
        if GetWall(0) > GetMaxWall(0)/2 then
            Damage(1, GetWall(0))
        else
            AddTower(0, 10)
        end
        return 1
    end;
    AIFunction = function ()
        if GetWall(0) > GetMaxWall(0)/2 then return AIDamageEnemy(GetWall(0)) end
        return AIAddTower(10)
    end;
}

Card
{
    Name = "Will There Be None?"; --And Then Will There Be None?
    Description = "+10 of all resources, +10 castle or nothing";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 19;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "eosd-712.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
        local Luck = math.random(3)
        if Luck == 1 then
            AddBricks(0, 10)
            AddGems(0, 10)
            AddRecruits(0, 10)
        elseif Luck == 2 then
            AddTower(0, 10)
            AddWall(0, 10)
        end
        return 1
    end;
    AIFunction = function ()
        return (AIAddGems(10)+AIAddBricks(10)+AIAddRecruits(10))/3 + (AIAddTower(10)+AIAddWall(10))/3
    end;
}

Card
{
    Name = "Ripples of 495 Years";
    Description = "+15 tower, enemy loses 5 of each resource";
    Frequency = 1;
    BrickCost = 21;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "eosd-713.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
    Keywords = "";
    PlayFunction = function ()
        AddTower(0, 15)
        RemoveBricks(1, 5)
        RemoveGems(1, 5)
        RemoveRecruits(1, 5)
        return 1
    end;
    AIFunction = function ()
        return AIAddTower(15)+AIRemoveEnemyRecruits(5)+AIRemoveEnemyBricks(5)+AIRemoveEnemyGems(5)
    end;
}
