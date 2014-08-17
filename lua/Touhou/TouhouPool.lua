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
    Picture = {File = "eosd-21.png", Coordinates = {x = 0, y = 0, w = 384, h = 226}};
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
