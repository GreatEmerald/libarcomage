-- A Touhou Perfect Cherry Blossom theme pool for Arcomage
-- Copyright © GreatEmerald, 2015

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
