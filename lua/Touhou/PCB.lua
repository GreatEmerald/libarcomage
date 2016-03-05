-- A Touhou Perfect Cherry Blossom theme pool for Arcomage
-- Copyright © GreatEmerald, 2015, 2016

-- Ratio is 22:13!
Card
{
    Name = "Frost Columns";
    Description = "+3 to lowest wall";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Black";
    Picture = {File = "pcb-1.png", Coordinates = {x = 0, y = 0, w = 614, h = 362}};
    Keywords = "";
    PlayFunction = function ()
        if GetWall(1) < GetWall(0) then
            AddWall(1, 3)
        else
            AddWall(0, 3)
        end
        return 1
    end;
    AIFunction = function ()
        if GetWall(1) < GetWall(0) then
            return AIAddEnemyWall(3)
        else
            return AIAddWall(3)
        end
    end;
}

Card
{
    Name = "Frost Columns L";
    Description = "+6 to lowest wall";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Black";
    Picture = {File = "pcb-2.jpg", Coordinates = {x = 0, y = 0, w = 702, h = 414}};
    Keywords = "";
    PlayFunction = function ()
        if GetWall(1) < GetWall(0) then
            AddWall(1, 6)
        else
            AddWall(0, 6)
        end
        return 1
    end;
    AIFunction = function ()
        if GetWall(1) < GetWall(0) then
            return AIAddEnemyWall(6)
        else
            return AIAddWall(6)
        end
    end;
}

Card
{
    Name = "Lingering Cold E";
    Description = "1 damage, +1 gem";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 1;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "pcb-3.jpg", Coordinates = {x = 0, y = 0, w = 720, h = 479}};
    Keywords = "";
    PlayFunction = function ()
        Damage(1, 1)
        AddGems(0, 1)
        return 1
    end;
    AIFunction = function ()
        return AIDamageEnemy(1)+AIAddGems(1)
    end;
}

Card
{
    Name = "Lingering Cold";
    Description = "2 damage, +2 gems";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 2;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "pcb-4.jpg", Coordinates = {x = 0, y = 0, w = 1184, h = 670}};
    Keywords = "";
    PlayFunction = function ()
        Damage(1, 2)
        AddGems(0, 2)
        return 1
    end;
    AIFunction = function ()
        return AIDamageEnemy(2)+AIAddGems(2)
    end;
}

Card
{
    Name = "Lingering Cold H";
    Description = "3 damage, +3 gems";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 3;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "pcb-5.jpg", Coordinates = {x = 0, y = 0, w = 640, h = 400}};
    Keywords = "";
    PlayFunction = function ()
        Damage(1, 3)
        AddGems(0, 3)
        return 1
    end;
    AIFunction = function ()
        return AIDamageEnemy(3)+AIAddGems(3)
    end;
}

Card
{
    Name = "Lingering Cold L";
    Description = "4 damage, +4 gems";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 4;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "pcb-6.jpg", Coordinates = {x = 0, y = 0, w = 718, h = 424}};
    Keywords = "";
    PlayFunction = function ()
        Damage(1, 4)
        AddGems(0, 4)
        return 1
    end;
    AIFunction = function ()
        return AIDamageEnemy(4)+AIAddGems(4)
    end;
}

Card
{
    Name = "Flower Wither Away E";
    Description = "Player with the most resources loses 1 of each";
    Frequency = 3;
    BrickCost = 1;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "pcb-7.jpg", Coordinates = {x = 0, y = 0, w = 668, h = 394}};
    Keywords = "";
    PlayFunction = function ()
        if GetBricks(1)+GetGems(1)+GetRecruits(1) < GetBricks(0)+GetGems(0)+GetRecruits(0) then
            RemoveBricks(0, 1)
            RemoveGems(0, 1)
            RemoveRecruits(0, 1)
        else
            RemoveBricks(1, 1)
            RemoveGems(1, 1)
            RemoveRecruits(1, 1)
        end
        return 1
    end;
    AIFunction = function ()
        if GetBricks(1)+GetGems(1)+GetRecruits(1) < GetBricks(0)+GetGems(0)+GetRecruits(0) then
            return AIRemoveBricks(1)+AIRemoveGems(1)+AIRemoveRecruits(1)
        else
            return AIRemoveEnemyBricks(1)+AIRemoveEnemyGems(1)+AIRemoveEnemyRecruits(1)
        end
    end;
}

Card
{
    Name = "Flower Wither Away";
    Description = "Player with the most resources loses 2 of each";
    Frequency = 3;
    BrickCost = 2;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "pcb-8.jpg", Coordinates = {x = 0, y = 0, w = 610, h = 360}};
    Keywords = "";
    PlayFunction = function ()
        if GetBricks(1)+GetGems(1)+GetRecruits(1) < GetBricks(0)+GetGems(0)+GetRecruits(0) then
            RemoveBricks(0, 2)
            RemoveGems(0, 2)
            RemoveRecruits(0, 2)
        else
            RemoveBricks(1, 2)
            RemoveGems(1, 2)
            RemoveRecruits(1, 2)
        end
        return 1
    end;
    AIFunction = function ()
        if GetBricks(1)+GetGems(1)+GetRecruits(1) < GetBricks(0)+GetGems(0)+GetRecruits(0) then
            return AIRemoveBricks(2)+AIRemoveGems(2)+AIRemoveRecruits(2)
        else
            return AIRemoveEnemyBricks(2)+AIRemoveEnemyGems(2)+AIRemoveEnemyRecruits(2)
        end
    end;
}

Card
{
    Name = "Undulation Ray";
    Description = "3 damage to enemy tower";
    Frequency = 3;
    BrickCost = 1;
    GemCost = 1;
    RecruitCost = 1;
    Cursed = false;
    Colour = "White";
    Picture = {File = "pcb-9.png", Coordinates = {x = 0, y = 0, w = 1280, h = 756}};
    Keywords = "";
    PlayFunction = function ()
        RemoveTower(1, 3)
        return 1
    end;
    AIFunction = function ()
        return AIRemoveEnemyTower(3)
    end;
}

Card
{
    Name = "Table-Turning";
    Description = "+3 tower to lowest tower";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 1;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "pcb-10.png", Coordinates = {x = 0, y = 0, w = 410, h = 242}};
    Keywords = "";
    PlayFunction = function ()
        if GetTower(1) < GetTower(0) then
            AddTower(1, 3)
        else
            AddTower(0, 3)
        end
        return 1
    end;
    AIFunction = function ()
        if GetTower(1) < GetTower(0) then
            return AIAddEnemyTower(3)
        else
            return AIAddTower(3)
        end
    end;
}

Card
{
    Name = "Phoenix Egg E";
    Description = "+6 recruits, +3 enemy recruits";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 1;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "pcb-11.png", Coordinates = {x = 0, y = 0, w = 590, h = 348}};
    Keywords = "";
    PlayFunction = function ()
        AddRecruits(0, 6)
        AddRecruits(1, 3)
        return 1
    end;
    AIFunction = function ()
        return AIAddRecruits(6)+AIAddEnemyRecruits(3)
    end;
}

Card
{
    Name = "Phoenix Egg";
    Description = "+12 recruits, +6 enemy recruits";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 2;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "pcb-12.jpg", Coordinates = {x = 0, y = 0, w = 658, h = 388}};
    Keywords = "";
    PlayFunction = function ()
        AddRecruits(0, 12)
        AddRecruits(1, 6)
        return 1
    end;
    AIFunction = function ()
        return AIAddRecruits(12)+AIAddEnemyRecruits(6)
    end;
}

Card
{
    Name = "Phoenix Wings";
    Description = "3 damage to enemy wall and tower";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 6;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "pcb-13.png", Coordinates = {x = 0, y = 0, w = 860, h = 508}};
    Keywords = "";
    PlayFunction = function ()
        RemoveWall(1, 3)
        RemoveTower(1, 3)
        return 1
    end;
    AIFunction = function ()
        return AIRemoveEnemyWall(3)+AIRemoveEnemyTower(3)
    end;
}

Card
{
    Name = "Phoenix Wings L";
    Description = "5 damage to enemy wall and tower";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 10;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "pcb-14.jpg", Coordinates = {x = 0, y = 0, w = 990, h = 586}};
    Keywords = "";
    PlayFunction = function ()
        RemoveWall(1, 5)
        RemoveTower(1, 5)
        return 1
    end;
    AIFunction = function ()
        return AIRemoveEnemyWall(5)+AIRemoveEnemyTower(5)
    end;
}

Card
{
    Name = "Pentagram Flight E";
    Description = "Steal 5 recruits";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 4;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "pcb-15.png", Coordinates = {x = 0, y = 0, w = 806, h = 476}};
    Keywords = "";
    PlayFunction = function ()
        RemoveRecruits(1, 5)
        AddRecruits(0, 5)
        return 1
    end;
    AIFunction = function ()
        return AIRemoveEnemyRecruits(5)+AIAddRecruits(5)
    end;
}

Card
{
    Name = "Pentagram Flight";
    Description = "Steal 5 of each resource";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 12;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "pcb-16.png", Coordinates = {x = 0, y = 0, w = 816, h = 482}};
    Keywords = "";
    PlayFunction = function ()
        RemoveRecruits(1, 5)
        AddRecruits(0, 5)
        RemoveGems(1, 5)
        AddGems(0, 5)
        RemoveBricks(1, 5)
        AddBricks(0, 5)
        return 1
    end;
    AIFunction = function ()
        return AIRemoveEnemyRecruits(5)+AIAddRecruits(5)+AIRemoveEnemyGems(5)+AIAddGems(5)+AIRemoveEnemyBricks(5)+AIAddBricks(5)
    end;
}

Card
{
    Name = "Douman-Seiman";
    Description = "Steal 5 wall";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 10;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "pcb-17.png", Coordinates = {x = 0, y = 0, w = 360, h = 212}};
    Keywords = "";
    PlayFunction = function ()
        RemoveWall(1, 5)
        AddWall(0, 5)
        return 1
    end;
    AIFunction = function ()
        return AIRemoveEnemyWall(5)+AIAddWall(5)
    end;
}

Card
{
    Name = "Pentagram Crest";
    Description = "Steal 5 tower";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 10;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "pcb-18.png", Coordinates = {x = 0, y = 0, w = 800, h = 472}};
    Keywords = "";
    PlayFunction = function ()
        RemoveTower(1, 5)
        AddTower(0, 5)
        return 1
    end;
    AIFunction = function ()
        return AIRemoveEnemyTower(5)+AIAddTower(5)
    end;
}

Card
{
    Name = "Sage's Rumbling E";
    Description = "Enemy loses 5 of a random resource";
    Frequency = 3;
    BrickCost = 2;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "pcb-19.png", Coordinates = {x = 0, y = 0, w = 600, h = 354}};
    Keywords = "";
    PlayFunction = function ()
        Target = math.random(3)
        if Target == 1 then
            RemoveBricks(1, 5)
        elseif Target == 2 then
            RemoveGems(1, 5)
        else
            RemoveRecruits(1, 5)
        end
        return 1
    end;
    AIFunction = function ()
        return AIRemoveEnemyBricks(5)/3 + AIRemoveEnemyGems(5)/3 + AIRemoveEnemyRecruits(5)/3
    end;
}

Card
{
    Name = "Sage's Rumbling";
    Description = "Enemy loses 10 of a random resource";
    Frequency = 3;
    BrickCost = 4;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "pcb-20.jpg", Coordinates = {x = 0, y = 0, w = 1050, h = 620}};
    Keywords = "";
    PlayFunction = function ()
        Target = math.random(3)
        if Target == 1 then
            RemoveBricks(1, 10)
        elseif Target == 2 then
            RemoveGems(1, 10)
        else
            RemoveRecruits(1, 10)
        end
        return 1
    end;
    AIFunction = function ()
        return AIRemoveEnemyBricks(10)/3 + AIRemoveEnemyGems(10)/3 + AIRemoveEnemyRecruits(10)/3
    end;
}

Card
{
    Name = "Flight of Idaten";
    Description = "Steal 1 of each resource and castle\nPlay again";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 8;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "pcb-21.jpg", Coordinates = {x = 0, y = 0, w = 562, h = 332}};
    Keywords = "";
    PlayFunction = function ()
        RemoveBricks(1, 1)
        RemoveGems(1, 1)
        RemoveRecruits(1, 1)
        RemoveTower(1, 1)
        RemoveWall(1, 1)
        AddWall(0, 1)
        AddTower(0, 1)
        AddRecruits(0, 1)
        AddGems(0, 1)
        AddBricks(0, 1)
        return 0
    end;
    AIFunction = function ()
        return AIRemoveEnemyBricks(1)+AIRemoveEnemyGems(1)+AIRemoveEnemyRecruits(1)+AIRemoveEnemyTower(1)+AIRemoveEnemyWall(1)+AIAddWall(1)+AIAddTower(1)+AIAddRecruits(1)+AIAddGems(1)+AIAddBricks(1)
    end;
}

Card
{
    Name = "Dharmapala";
    Description = "-10 enemy wall, gain wall equal to damage dealt";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 10;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "pcb-22.jpg", Coordinates = {x = 0, y = 0, w = 474, h = 280}};
    Keywords = "";
    PlayFunction = function ()
        Retribution = math.min(GetWall(1), 10)
        RemoveWall(1, 10)
        AddWall(0, Retribution)
        return 1
    end;
    AIFunction = function ()
        return AIRemoveEnemyWall(10)+AIAddWall(math.min(GetWall(1), 10))
    end;
}

Card
{
    Name = "Immortal Sage E";
    Description = "+5 random resource";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 2;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "pcb-23.jpg", Coordinates = {x = 0, y = 0, w = 648, h = 382}};
    Keywords = "";
    PlayFunction = function ()
        Target = math.random(3)
        if Target == 1 then
            AddBricks(0, 5)
        elseif Target == 2 then
            AddGems(0, 5)
        else
            AddRecruits(0, 5)
        end
        return 1
    end;
    AIFunction = function ()
        return AIAddBricks(5)/3 + AIAddGems(5)/3 + AIAddRecruits(5)/3
    end;
}

Card
{
    Name = "Immortal Sage";
    Description = "+10 random resource";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 4;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "pcb-24.jpg", Coordinates = {x = 0, y = 0, w = 500, h = 296}};
    Keywords = "";
    PlayFunction = function ()
        Target = math.random(3)
        if Target == 1 then
            AddBricks(0, 10)
        elseif Target == 2 then
            AddGems(0, 10)
        else
            AddRecruits(0, 10)
        end
        return 1
    end;
    AIFunction = function ()
        return AIAddBricks(10)/3 + AIAddGems(10)/3 + AIAddRecruits(10)/3
    end;
}

Card
{
    Name = "Demon's Gate";
    Description = "6 damage to enemy tower, -6 recruits";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 6;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "pcb-25.jpg", Coordinates = {x = 0, y = 0, w = 842, h = 498}};
    Keywords = "";
    PlayFunction = function ()
        RemoveTower(1, 6)
        RemoveRecruits(0, 6)
        return 1
    end;
    AIFunction = function ()
        return AIRemoveEnemyTower(6)+AIRemoveRecruits(6)
    end;
}

Card
{
    Name = "Kimontonkou";
    Description = "Gain +2 of each resource and +2 wall";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 3;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "pcb-26.jpg", Coordinates = {x = 0, y = 0, w = 440, h = 260}};
    Keywords = "";
    PlayFunction = function ()
        AddBricks(0, 2)
        AddGems(0, 2)
        AddRecruits(0, 2)
        AddWall(0, 2)
        return 1
    end;
    AIFunction = function ()
        return AIAddBricks(2)+AIAddGems(2)+AIAddRecruits(2)+AIAddWall(2)
    end;
}

Card
{
    Name = "Maiden's Bunraku";
    Description = "If dungeon < enemy dungeon, gain +1 dungeon";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 5;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "pcb-27.jpg", Coordinates = {x = 0, y = 0, w = 342, h = 202}};
    Keywords = "";
    PlayFunction = function ()
        if GetDungeon(0) < GetDungeon(1) then
            AddDungeon(0, 1)
        end
        return 1
    end;
    AIFunction = function ()
        if GetDungeon(0) < GetDungeon(1) then
            return AIAddDungeon(1)
        end
        return 0
    end;
}

Card
{
    Name = "Maiden's Bunraku L";
    Description = "If quarry < enemy quarry or magic < enemy magic, gain +1 dungeon";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 7;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "pcb-28.jpg", Coordinates = {x = 0, y = 0, w = 300, h = 178}};
    Keywords = "";
    PlayFunction = function ()
        if GetQuarry(0) < GetQuarry(1) or GetMagic(0) < GetMagic(1) then
            AddDungeon(0, 1)
        end
        return 1
    end;
    AIFunction = function ()
        if GetQuarry(0) < GetQuarry(1) or GetMagic(0) < GetMagic(1) then
            return AIAddDungeon(1)
        end
        return 0
    end;
}

Card
{
    Name = "French Dolls E";
    Description = "+3 tower";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 2;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "pcb-29.jpg", Coordinates = {x = 0, y = 0, w = 440, h = 260}};
    Keywords = "";
    PlayFunction = function ()
        AddTower(0, 3)
        return 1
    end;
    AIFunction = function ()
        return AIAddTower(3)
    end;
}

Card
{
    Name = "French Dolls";
    Description = "+4 tower";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 3;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "pcb-30.jpg", Coordinates = {x = 0, y = 0, w = 440, h = 260}};
    Keywords = "";
    PlayFunction = function ()
        AddTower(0, 4)
        return 1
    end;
    AIFunction = function ()
        return AIAddTower(4)
    end;
}

Card
{
    Name = "French Dolls H";
    Description = "+5 tower";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 4;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "pcb-31.jpg", Coordinates = {x = 0, y = 0, w = 440, h = 260}};
    Keywords = "";
    PlayFunction = function ()
        AddTower(0, 5)
        return 1
    end;
    AIFunction = function ()
        return AIAddTower(5)
    end;
}

Card
{
    Name = "Orléans Dolls";
    Description = "+5 tower and +1 wall";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 4;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "pcb-32.jpg", Coordinates = {x = 0, y = 0, w = 440, h = 260}};
    Keywords = "";
    PlayFunction = function ()
        AddTower(0, 5)
        AddWall(0, 1)
        return 1
    end;
    AIFunction = function ()
        return AIAddTower(5)+AIAddWall(1)
    end;
}

Card
{
    Name = "Dutch Dolls E";
    Description = "Deal 3 damage";
    Frequency = 3;
    BrickCost = 2;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "pcb-33.jpg", Coordinates = {x = 0, y = 0, w = 440, h = 260}};
    Keywords = "";
    PlayFunction = function ()
        Damage(1, 3)
        return 1
    end;
    AIFunction = function ()
        return AIDamageEnemy(3)
    end;
}

Card
{
    Name = "Dutch Dolls";
    Description = "Deal 4 damage";
    Frequency = 3;
    BrickCost = 3;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "pcb-34.jpg", Coordinates = {x = 0, y = 0, w = 440, h = 260}};
    Keywords = "";
    PlayFunction = function ()
        Damage(1, 4)
        return 1
    end;
    AIFunction = function ()
        return AIDamageEnemy(4)
    end;
}

Card
{
    Name = "Russian Dolls";
    Description = "Deal 5 damage, take 1 damage";
    Frequency = 3;
    BrickCost = 1;
    GemCost = 1;
    RecruitCost = 1;
    Cursed = false;
    Colour = "White";
    Picture = {File = "pcb-35.jpg", Coordinates = {x = 0, y = 0, w = 440, h = 260}};
    Keywords = "";
    PlayFunction = function ()
        Damage(1, 5)
        Damage(0, 1)
        return 1
    end;
    AIFunction = function ()
        return AIDamageEnemy(5)+AIDamage(1)
    end;
}

Card
{
    Name = "Russian Dolls L";
    Description = "Deal 7 damage, take 2 damage";
    Frequency = 3;
    BrickCost = 2;
    GemCost = 2;
    RecruitCost = 2;
    Cursed = false;
    Colour = "White";
    Picture = {File = "pcb-36.jpg", Coordinates = {x = 0, y = 0, w = 440, h = 260}};
    Keywords = "";
    PlayFunction = function ()
        Damage(1, 7)
        Damage(0, 2)
        return 1
    end;
    AIFunction = function ()
        return AIDamageEnemy(7)+AIDamage(2)
    end;
}

Card
{
    Name = "London Dolls E";
    Description = "Deal 2 damage and give +2 wall to each player";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Black";
    Picture = {File = "pcb-37.jpg", Coordinates = {x = 0, y = 0, w = 440, h = 260}};
    Keywords = "";
    PlayFunction = function ()
        Damage(1, 2)
        Damage(0, 2)
        AddWall(1, 2)
        AddWall(0, 2)
        return 1
    end;
    AIFunction = function ()
        return AIDamageEnemy(2)+AIDamage(2)+AIAddEnemyWall(2)+AIAddWall(2)
    end;
}

Card
{
    Name = "Foggy London Dolls";
    Description = "Deal 4 damage and give +4 wall to each player";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Black";
    Picture = {File = "pcb-38.jpg", Coordinates = {x = 0, y = 0, w = 478, h = 282}};
    Keywords = "";
    PlayFunction = function ()
        Damage(1, 4)
        Damage(0, 4)
        AddWall(1, 4)
        AddWall(0, 4)
        return 1
    end;
    AIFunction = function ()
        return AIDamageEnemy(4)+AIDamage(4)+AIAddEnemyWall(4)+AIAddWall(4)
    end;
}

Card
{
    Name = "Tibetan Dolls";
    Description = "Gain +2 tower and +3 wall";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 3;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "pcb-39.jpg", Coordinates = {x = 0, y = 0, w = 440, h = 260}};
    Keywords = "";
    PlayFunction = function ()
        AddTower(0, 2)
        AddWall(0, 3)
        return 1
    end;
    AIFunction = function ()
        return AIAddTower(2)+AIAddWall(3)
    end;
}

Card
{
    Name = "Spring Kyoto Dolls";
    Description = "Gain +5 gems and +3 wall";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 3;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "pcb-40.jpg", Coordinates = {x = 0, y = 0, w = 440, h = 260}};
    Keywords = "";
    PlayFunction = function ()
        AddGems(0, 5)
        AddWall(0, 3)
        return 1
    end;
    AIFunction = function ()
        return AIAddGems(5)+AIAddWall(3)
    end;
}

Card
{
    Name = "Shanghai Dolls E";
    Description = "Deal 3 damage, lose 2 random resources. Cannot discard";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = true;
    Colour = "Black";
    Picture = {File = "pcb-41.jpg", Coordinates = {x = 0, y = 0, w = 270, h = 160}};
    Keywords = "";
    PlayFunction = function ()
        Damage(1, 3)
        Loss = math.random(3)
        if Loss == 1 then
            RemoveBricks(0, 2)
        elseif Loss == 2 then
            RemoveGems(0, 2)
        else
            RemoveRecruits(0, 2)
        end
        return 1
    end;
    AIFunction = function ()
        return AIDamageEnemy(3)+AIRemoveBricks(2)/3+AIRemoveGems(2)/3+AIRemoveRecruits(2)/3
    end;
}

Card
{
    Name = "Shanghai Dolls";
    Description = "Deal 4 damage, lose 3 random resources. Cannot discard";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = true;
    Colour = "Black";
    Picture = {File = "pcb-42.jpg", Coordinates = {x = 0, y = 0, w = 440, h = 260}};
    Keywords = "";
    PlayFunction = function ()
        Damage(1, 4)
        Loss = math.random(3)
        if Loss == 1 then
            RemoveBricks(0, 3)
        elseif Loss == 2 then
            RemoveGems(0, 3)
        else
            RemoveRecruits(0, 3)
        end
        return 1
    end;
    AIFunction = function ()
        return AIDamageEnemy(4)+AIRemoveBricks(3)/3+AIRemoveGems(3)/3+AIRemoveRecruits(3)/3
    end;
}

Card
{
    Name = "Shanghai Dolls H";
    Description = "Deal 6 damage, lose 4 random resources. Cannot discard";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = true;
    Colour = "Black";
    Picture = {File = "pcb-43.jpg", Coordinates = {x = 0, y = 0, w = 440, h = 260}};
    Keywords = "";
    PlayFunction = function ()
        Damage(1, 6)
        Loss = math.random(3)
        if Loss == 1 then
            RemoveBricks(0, 4)
        elseif Loss == 2 then
            RemoveGems(0, 4)
        else
            RemoveRecruits(0, 4)
        end
        return 1
    end;
    AIFunction = function ()
        return AIDamageEnemy(6)+AIRemoveBricks(4)/3+AIRemoveGems(4)/3+AIRemoveRecruits(4)/3
    end;
}

Card
{
    Name = "Hanged Hourai Dolls";
    Description = "Deal 8 damage, lose 2 stock. Cannot discard";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = true;
    Colour = "Black";
    Picture = {File = "pcb-44.jpg", Coordinates = {x = 0, y = 0, w = 480, h = 284}};
    Keywords = "";
    PlayFunction = function ()
        Damage(1, 8)
        RemoveBricks(0, 2)
        RemoveGems(0, 2)
        RemoveRecruits(0, 2)
        return 1
    end;
    AIFunction = function ()
        return AIDamageEnemy(8)+AIRemoveBricks(2)+AIRemoveGems(2)+AIRemoveRecruits(2)
    end;
}
