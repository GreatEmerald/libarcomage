-- Arcomage/CardPool
--- The Card Pool for the stock Arcomage deck.
-- @copyright GreatEmerald, 2011

-- GE: begin algorithm:
-- A Card Pool is a file that provides all of the information about individual
-- cards in a mod. For instance, this file contains all of the information about
-- the names and the frequency of the cards. This information is taken by the C
-- code that uses it to setup the cards for first use.
-- In short: It takes and fills the CardDB array in cards.h.

-- This is how communication works:
-- Each Card{} block is actually, in Lua documentation words, syntactic sugar
-- for Card({}) - that is, those are function calls. They simply call the
-- function Card() that is defined in D and that way pass arguments directly to
-- D in an orderly fashion - and looks good, too. Thanks to LuaD examples for
-- this one!
-- I could use a slightly different method - create a CardTable{} global, then
-- alter that global and send it through the function Card(). That would allow
-- me to save some space and easily change the properties of many cards in one
-- go; however, it's terribly hard to read and very unsafe, so I wil stick with
-- this method that has more redundancy, but also more safety.
-- Be careful not to omit anythying, though! Or else you will crash! :{
bUseOriginalCards = false
DeckSize = 0

--[[ GE: Copy paste convenience.
Card
{
    Name = "";
    Description = "";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Black";
    Picture = {File = "", Coordinates = {x = 0, y = 0, w = 0, h = 0}};
    Keywords = "";
    PlayFunction = function () return 1 end;
    AIFunction = function () return 0 end;
}
]]

Card
{
    Name = "Brick Shortage";
    Description = "All players\nlose 8 bricks";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "images.png", Coordinates = {x = 0, y = 0, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        RemoveBricks(0, 8)
        RemoveBricks(1, 8)
        return 1
    end;
    AIFunction = function () --FIXME Priority
        local Priority = 0.0
        if GetBricks(0) < 8 then Priority = Priority+0.04 end
        if GetBricks(1) < 8 then Priority = Priority-0.04 end
        if GetBricks(1) >= GetResourceVictory()*0.75 then
            if OneResourceVictory then Priority = Priority+0.08
            elseif GetGems(1) >= GetResourceVictory() and GetRecruits(1) >= GetResourceVictory() then Priority = Priority+0.08 end
        end
        if GetQuarry(0) > GetQuarry(1) then Priority = Priority+0.04
        elseif GetQuarry(0) < GetQuarry(1) then Priority = Priority-0.08 end
        return Priority
    end;
}

Card
{
    Name = "Lucky Cache";
    Description = "+2 Bricks\n+2 Gems\nPlay again";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "images.png", Coordinates = {x = 88, y = 0, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddBricks(0, 2)
        AddGems(0, 2)
        return 0
    end;
    AIFunction = function () return 1 end;
}

Card
{
    Name = "Friendly Terrain";
    Description = "+1 Wall\nPlay again";
    Frequency = 2;
    BrickCost = 1;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "images.png", Coordinates = {x = 88*2, y = 0, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddWall(0, 1)
        return 0
    end;
    AIFunction = function () return 0.97 end;
}

Card
{
    Name = "Miners";
    Description = "+1 Quarry";
    Frequency = 2;
    BrickCost = 3;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "images.png", Coordinates = {x = 88*3, y = 0, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddQuarry(0, 1)
        return 1
    end;
    AIFunction = function ()
        return AIAddQuarry(1)
    end;
}

Card
{
    Name = "Mother Lode";
    Description = "If quarry<enemy\nquarry, +2 quarry\nElse, +1\nquarry";
    Frequency = 1;
    BrickCost = 4;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "images.png", Coordinates = {x = 88*4, y = 0, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        if GetQuarry(0) < GetQuarry(1) then
            AddQuarry(0, 2)
        else
            AddQuarry(0, 1)
        end
        return 1
    end;
    AIFunction = function ()
        if GetQuarry(0) < GetQuarry(1) then return AIAddQuarry(2) end
        return AIAddQuarry(1)
    end;
}

Card
{
    Name = "Dwarven Miners";
    Description = "+4 Wall\n+1 Quarry";
    Frequency = 1;
    BrickCost = 7;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "images.png", Coordinates = {x = 88*5, y = 0, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddWall(0, 4)
        AddQuarry(0, 1)
        return 1
    end;
    AIFunction = function ()
        return math.min(AIAddQuarry(1) + AIAddWall(4), 0.95)
    end;
}

Card
{
    Name = "Work Overtime";
    Description = "+5 Wall\nYou lose 6 gems";
    Frequency = 2;
    BrickCost = 2;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "images.png", Coordinates = {x = 0, y = 52, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddWall(0, 5)
        RemoveGems(0, 6)
        return 1
    end;
    AIFunction = function ()
        return AIAddWall(5)-(math.min(GetGems(0), 6)*0.01)
    end;
}

Card
{
    Name = "Copping the Tech";
    Description = "If quarry<enemy\nquarry, quarry =\nenemy quarry";
    Frequency = 1;
    BrickCost = 5;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "images.png", Coordinates = {x = 88, y = 52, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        if GetQuarry(0) < GetQuarry(1) then
            SetQuarry(0, GetQuarry(1))
        end
        return 1
    end;
    AIFunction = function ()
        return AIAddQuarry(math.max(GetQuarry(1)-GetQuarry(0), 0))
    end;
}

Card
{
    Name = "Basic Wall";
    Description = "+3 Wall";
    Frequency = 2;
    BrickCost = 2;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "images.png", Coordinates = {x = 88*2, y = 52, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddWall(0, 3)
        return 1
    end;
    AIFunction = function ()
        return AIAddWall(3)
    end;
}

Card
{
    Name = "Sturdy Wall";
    Description = "+4 Wall";
    Frequency = 1;
    BrickCost = 3;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "images.png", Coordinates = {x = 88*3, y = 52, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddWall(0, 4)
        return 1
    end;
    AIFunction = function ()
        return AIAddWall(4)
    end;
}

Card
{
    Name = "Innovations";
    Description = "+1 to all players\nquarrys, you gain\n+4 gems";
    Frequency = 1;
    BrickCost = 2;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "images.png", Coordinates = {x = 88*4, y = 52, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddQuarry(0, 1)
        AddQuarry(1, 1)
        AddGems(0, 4)
        return 1
    end;
    AIFunction = function () --FIXME AI priority
        local Priority = AIAddGems(4)
        if GetQuarry(1) == 1 then Priority = Priority-0.04 end
        if GetQuarry(0) < GetQuarry(1) then Priority = Priority+0.02
        elseif GetQuarry(0) > GetQuarry(1) then Priority = Priority-0.02 end
        return Priority
    end;
}

Card
{
    Name = "Foundations";
    Description = "If wall = 0, +6\nwall, else\n+3 wall";
    Frequency = 2;
    BrickCost = 3;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "images.png", Coordinates = {x = 88*5, y = 52, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        if GetWall(0) == 0 then
            AddWall(0, 6)
        else
            AddWall(0, 3)
        end
        return 1
    end;
    AIFunction = function ()
        if GetWall(0) == 0 then return AIAddWall(6) end
        return AIAddWall(3)
    end;
}

Card
{
    Name = "Tremors";
    Description = "All walls take\n5 damage\nPlay again";
    Frequency = 1;
    BrickCost = 7;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "images.png", Coordinates = {x = 0, y = 52*2, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        RemoveWall(1, 5)
        RemoveWall(0, 5)
        return 0
    end;
    AIFunction = function ()
        return AIRemoveWall(math.min(GetWall(0), 5)) + AIRemoveEnemyWall(math.min(GetWall(1), 5))
    end;
}

Card
{
    Name = "Secret Room";
    Description = "+1 Magic\nPlay again";
    Frequency = 1;
    BrickCost = 8;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "images.png", Coordinates = {x = 88, y = 52*2, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddMagic(0, 1)
        return 0
    end;
    AIFunction = function () return 0.97 end;
}

Card
{
    Name = "Earthquake";
    Description = "-1 To all players\nquarrys";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "images.png", Coordinates = {x = 88*2, y = 52*2, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        RemoveQuarry(1, 1)
        RemoveQuarry(0, 1)
        return 1
    end;
    AIFunction = function () --FIXME AI priority
        local Priority = 0.0
        if GetQuarry(0) == 1 then return 0.25 end
        if GetQuarry(0) < GetQuarry(1) then Priority = Priority-0.05
        elseif GetQuarry(0) > GetQuarry(1) then Priority = Priority+0.05 end
        return Priority
    end;
}

Card
{
    Name = "Big Wall";
    Description = "+6 Wall";
    Frequency = 2;
    BrickCost = 5;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "images.png", Coordinates = {x = 88*3, y = 52*2, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddWall(0, 6)
        return 1
    end;
    AIFunction = function ()
        return AIAddWall(6)
    end;
}

Card
{
    Name = "Collapse!";
    Description = "-1 Enemy quarry";
    Frequency = 1;
    BrickCost = 4;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "images.png", Coordinates = {x = 88*4, y = 52*2, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        RemoveQuarry(1, 1)
        return 1
    end;
    AIFunction = function ()
        return AIRemoveEnemyQuarry(1)
    end;
}

Card
{
    Name = "New Equipment";
    Description = "+2 quarry";
    Frequency = 1;
    BrickCost = 6;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "images.png", Coordinates = {x = 88*5, y = 52*2, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddQuarry(0, 2)
        return 1
    end;
    AIFunction = function ()
        return AIAddQuarry(2)
    end;
}

Card
{
    Name = "Strip Mine";
    Description = "-1 Quarry, +10\nwall. You gain\n5 gems";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "images.png", Coordinates = {x = 0, y = 52*3, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        RemoveQuarry(0, 1)
        AddWall(0, 10)
        AddGems(0, 5)
        return 1
    end;
    AIFunction = function ()
        return math.min(AIRemoveQuarry(1) + AIAddWall(10) + AIAddGems(5), 0.95)
    end;
}

Card
{
    Name = "Reinforced wall";
    Description = "+8 Wall";
    Frequency = 2;
    BrickCost = 8;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "images.png", Coordinates = {x = 88, y = 52*3, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddWall(0, 8)
        return 1
    end;
    AIFunction = function ()
        return AIAddWall(8)
    end;
}

Card
{
    Name = "Porticulus";
    Description = "+6 Wall\n+1 Dungeon";
    Frequency = 1;
    BrickCost = 9;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "images.png", Coordinates = {x = 88*2, y = 52*3, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddWall(0, 6)
        AddDungeon(0, 1)
        return 1
    end;
    AIFunction = function ()
        return math.min(AIAddWall(6) + AIAddDungeon(1), 0.95)
    end;
}

Card
{
    Name = "Crystal Rocks";
    Description = "+7 Wall\ngain 7 gems";
    Frequency = 1;
    BrickCost = 9;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "images.png", Coordinates = {x = 88*3, y = 52*3, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddWall(0, 7)
        AddGems(0, 7)
        return 1
    end;
    AIFunction = function ()
        return math.min(AIAddWall(7) + AIAddGems(7), 0.95)
    end;
}

Card
{
    Name = "Harmonic Ore";
    Description = "+6 Wall\n+3 Tower";
    Frequency = 1;
    BrickCost = 11;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "images.png", Coordinates = {x = 88*4, y = 52*3, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddWall(0, 6)
        AddTower(0, 3)
        return 1
    end;
    AIFunction = function ()
        return math.min(AIAddWall(6) + AIAddTower(3), 0.95)
    end;
}

Card
{
    Name = "Mondo Wall";
    Description = "+12 Wall";
    Frequency = 1;
    BrickCost = 13;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "images.png", Coordinates = {x = 88*5, y = 52*3, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddWall(0, 12)
        return 1
    end;
    AIFunction = function ()
        return AIAddWall(12)
    end;
}

Card
{
    Name = "Focused Designs";
    Description = "+8 Wall\n+5 Tower";
    Frequency = 1;
    BrickCost = 15;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "images.png", Coordinates = {x = 88*0, y = 52*4, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddWall(0, 8)
        AddTower(0, 5)
        return 1
    end;
    AIFunction = function ()
        return math.min(AIAddWall(8) + AIAddTower(5), 0.95)
    end;
}

Card
{
    Name = "Great Wall";
    Description = "+15 Wall";
    Frequency = 1;
    BrickCost = 16;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "images.png", Coordinates = {x = 88*1, y = 52*4, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddWall(0, 15)
        return 1
    end;
    AIFunction = function ()
        return AIAddWall(15)
    end;
}

Card
{
    Name = "Rock Launcher";
    Description = "+6 Wall\n10 Damage\nto enemy";
    Frequency = 1;
    BrickCost = 18;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "images.png", Coordinates = {x = 88*2, y = 52*4, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddWall(0, 6)
        Damage(1, 10)
        return 1
    end;
    AIFunction = function ()
        return math.min(AIAddWall(6) + AIDamageEnemy(10), 0.95)
    end;
}

Card
{
    Name = "Dragon's Heart";
    Description = "+20 Wall\n+8 Tower";
    Frequency = 1;
    BrickCost = 24;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "images.png", Coordinates = {x = 88*3, y = 52*4, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddWall(0, 20)
        AddTower(0, 8)
        return 1
    end;
    AIFunction = function ()
        return math.min(AIAddWall(20) + AIAddTower(8), 0.95)
    end;
}

Card
{
    Name = "Forced Labor";
    Description = "+9 Wall\nLose 5 recruits";
    Frequency = 1;
    BrickCost = 7;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "images.png", Coordinates = {x = 88*4, y = 52*4, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddWall(0, 9)
        RemoveRecruits(0, 5)
        return 1
    end;
    AIFunction = function ()
        return math.min(AIAddWall(9) + AIRemoveRecruits(5), 0.95)
    end;
}

Card
{
    Name = "Rock Garden";
    Description = "+1 Wall\n+1 Tower\n+2 recruits";
    Frequency = 1;
    BrickCost = 1;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "images.png", Coordinates = {x = 88*5, y = 52*4, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddWall(0, 1)
        AddTower(0, 1)
        AddRecruits(0, 2)
        return 1
    end;
    AIFunction = function ()
        return math.min(AIAddWall(1)+AIAddTower(1)+AIAddRecruits(2), 0.95)
    end;
}

Card
{
    Name = "Flood Water";
    Description = "Player(s) w/ lowest\nWall are -1 Dung-\neon and 2 dam-\nage to Tower";
    Frequency = 1;
    BrickCost = 6;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "images.png", Coordinates = {x = 88*0, y = 52*5, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        if GetWall(0) < GetWall(1) then
            RemoveDungeon(0, 1)
            RemoveTower(0, 2)
        else
            RemoveDungeon(1, 1)
            RemoveTower(1, 2)
        end
        return 1
    end;
    AIFunction = function ()
        if GetWall(0) < GetWall(1) then return math.max(AIRemoveDungeon(1)+AIRemoveTower(2), -0.95)
        else return math.min(AIRemoveEnemyDungeon(1)+AIRemoveEnemyTower(2), 0.95) end
    end;
}

Card
{
    Name = "Barracks";
    Description = "+6 recruits, +6 Wall\nif dungeon <\nenemy dungeon,\n+1 dungeon";
    Frequency = 1;
    BrickCost = 10;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "images.png", Coordinates = {x = 88*1, y = 52*5, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddRecruits(0, 6)
        AddWall(0, 6)
        if GetDungeon(0) < GetDungeon(1) then
            AddDungeon(0, 1)
        end
        return 1
    end;
    AIFunction = function ()
        if GetDungeon(0) < GetDungeon(1) then return math.min(AIAddRecruits(6)+AIAddWall(6)+AIAddDungeon(1), 0.95) end
        return math.min(AIAddRecruits(6)+AIAddWall(6), 0.95)
    end;
}

Card
{
    Name = "Battlements";
    Description = "+7 Wall\n6 damage to\nenemy";
    Frequency = 1;
    BrickCost = 14;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "images.png", Coordinates = {x = 88*2, y = 52*5, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddWall(0, 7)
        Damage(1, 6)
        return 1
    end;
    AIFunction = function ()
        return math.min(AIAddWall(7)+AIDamageEnemy(6), 0.95)
    end;
}

Card
{
    Name = "Shift";
    Description = "Switch your Wall\nwith enemy Wall";
    Frequency = 1;
    BrickCost = 17;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Red";
    Picture = {File = "images.png", Coordinates = {x = 88*3, y = 52*5, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        local temp = GetWall(0)
        SetWall(0, GetWall(1))
        SetWall(1, temp)
        return 1
    end;
    AIFunction = function ()
        if GetWall(0) > GetWall(1) then return math.max(AIRemoveWall(GetWall(0)-GetWall(1))+AIAddEnemyWall(GetWall(0)-GetWall(1)), -0.95) end
        return math.min(AIAddWall(GetWall(1)-GetWall(0))+AIRemoveEnemyWall(GetWall(1)-GetWall(0)), 0.95)
    end;
}

Card
{
    Name = "Quartz";
    Description = "+1 Tower,\nplay again";
    Frequency = 2;
    BrickCost = 0;
    GemCost = 1;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "images.png", Coordinates = {x = 88*4, y = 52*5, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddTower(0, 1)
        return 0
    end;
    AIFunction = function () return 0.95 end;
}

Card
{
    Name = "Smoky Quartz";
    Description = "1 Damage to\nenemy tower\nPlay again";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 2;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "images.png", Coordinates = {x = 88*5, y = 52*5, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        RemoveTower(1, 1)
        return 0
    end;
    AIFunction = function () return 0.95 end;
}

Card
{
    Name = "Amethyst";
    Description = "+3 Tower";
    Frequency = 2;
    BrickCost = 0;
    GemCost = 2;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "images.png", Coordinates = {x = 88*0, y = 52*6, w = 88, h = 52}};
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
    Name = "Spell Weavers";
    Description = "+1 Magic";
    Frequency = 2;
    BrickCost = 0;
    GemCost = 3;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "images.png", Coordinates = {x = 88*1, y = 52*6, w = 88, h = 52}};
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
    Name = "Prism";
    Description = "Draw 1 card\nDiscard 1 card\nPlay again";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 2;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "images.png", Coordinates = {x = 88*2, y = 52*6, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        return -1
    end;
    AIFunction = function ()
        return 0.05
    end;
}

Card
{
    Name = "Lodestone";
    Description = "+3 Tower. This\ncard can't be dis-\ncarded without\nplaying it";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 5;
    RecruitCost = 0;
    Cursed = true;
    Colour = "Blue";
    Picture = {File = "images.png", Coordinates = {x = 88*3, y = 52*6, w = 88, h = 52}};
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
    Name = "Solar Flare";
    Description = "+2 Tower\n2 Damage to\nenemy tower";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 4;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "images.png", Coordinates = {x = 88*4, y = 52*6, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddTower(0, 2)
        RemoveTower(1, 2)
        return 1
    end;
    AIFunction = function ()
        return math.min(AIAddTower(2), AIRemoveEnemyTower(2), 0.95)
    end;
}

Card
{
    Name = "Crystal Matrix";
    Description = "+1 Magic\n+3 Tower\n+1 Enemy\ntower";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 6;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "images.png", Coordinates = {x = 88*5, y = 52*6, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddMagic(0, 1)
        AddTower(0, 3)
        AddTower(1, 1)
        return 1
    end;
    AIFunction = function ()
        return math.min(AIAddMagic(1)+AIAddTower(3)+AIAddEnemyTower(1), 0.95)
    end;
}

Card
{
    Name = "Gemstone Flaw";
    Description = "3 Damage to\nenemy tower";
    Frequency = 2;
    BrickCost = 0;
    GemCost = 2;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "images.png", Coordinates = {x = 88*0, y = 52*7, w = 88, h = 52}};
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
    Name = "Ruby";
    Description = "+5 Tower";
    Frequency = 2;
    BrickCost = 0;
    GemCost = 3;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "images.png", Coordinates = {x = 88*1, y = 52*7, w = 88, h = 52}};
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
    Name = "Gem Spear";
    Description = "5 Damage\nto enemy tower";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 4;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "images.png", Coordinates = {x = 88*2, y = 52*7, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        RemoveTower(1, 5)
        return 1
    end;
    AIFunction = function ()
        return AIRemoveEnemyTower(5)
    end;
}

Card
{
    Name = "Power Burn";
    Description = "5 Damage\nto your tower\n+2 Magic";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 3;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "images.png", Coordinates = {x = 88*3, y = 52*7, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        RemoveTower(0, 5)
        AddMagic(0, 2)
        return 1
    end;
    AIFunction = function ()
        return AIRemoveTower(5)+AIAddMagic(2)
    end;
}

Card
{
    Name = "Harmonic Vibe";
    Description = "+1 Magic\n+3 Tower\n+3 Wall";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 7;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "images.png", Coordinates = {x = 88*4, y = 52*7, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddMagic(0, 1)
        AddTower(0, 3)
        AddWall(0, 3)
        return 1
    end;
    AIFunction = function ()
        return math.min(AIAddMagic(1)+AIAddTower(3)+AIAddWall(3), 0.95)
    end;
}

Card
{
    Name = "Parity";
    Description = "All player's\nmagic equals\nthe highest\nplayer's magic";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 7;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "images.png", Coordinates = {x = 88*5, y = 52*7, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        local HighestMagic = math.max(GetMagic(0), GetMagic(1))
        SetMagic(0, HighestMagic)
        SetMagic(1, HighestMagic)
        return 1
    end;
    AIFunction = function ()
        if GetMagic(0) < GetMagic(1) then return AIAddMagic(GetMagic(1)-GetMagic(0)) end
        return -0.07
    end;
}

Card
{
    Name = "Emerald";
    Description = "+8 Tower";
    Frequency = 2;
    BrickCost = 0;
    GemCost = 6;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "images.png", Coordinates = {x = 88*0, y = 52*8, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddTower(0, 8)
        return 1
    end;
    AIFunction = function ()
        return AIAddTower(8)
        end;
}

Card
{
    Name = "Pearl of Wisdom";
    Description = "+5 Tower\n+1 Magic";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 9;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "images.png", Coordinates = {x = 88*1, y = 52*8, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddTower(0, 5)
        AddMagic(0, 1)
        return 1
    end;
    AIFunction = function ()
        return math.min(AIAddTower(5)+AIAddMagic(1), 0.95)
    end;
}

Card
{
    Name = "Shatterer";
    Description = "-1 Magic.\n9 Damage to\nenemy tower";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 8;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "images.png", Coordinates = {x = 88*2, y = 52*8, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        RemoveMagic(0, 1)
        RemoveTower(1, 9)
        return 1
    end;
    AIFunction = function ()
        if AIRemoveEnemyTower(9) > 0.95 then return AIRemoveEnemyTower(9) end
        return AIRemoveMagic(1)+AIRemoveEnemyTower(9)
    end;
}

Card
{
    Name = "Crumblestone";
    Description = "+5 Tower\nEnemy loses\n6 bricks";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 7;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "images.png", Coordinates = {x = 88*3, y = 52*8, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddTower(0, 5)
        RemoveBricks(1, 6)
        return 1
    end;
    AIFunction = function ()
        return math.min(AIAddTower(5)+AIRemoveEnemyBricks(6), 0.95)
    end;
}

Card
{
    Name = "Sapphire";
    Description = "+11 Tower";
    Frequency = 2;
    BrickCost = 0;
    GemCost = 10;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "images.png", Coordinates = {x = 88*4, y = 52*8, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddTower(0, 11)
        return 1
    end;
    AIFunction = function ()
        return AIAddTower(11)
    end;
}

Card
{
    Name = "Discord";
    Description = "7 Damage to\nall towers, all\nplayer's magic\n-1";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 5;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "images.png", Coordinates = {x = 88*5, y = 52*8, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        RemoveTower(0, 7)
        RemoveTower(1, 7)
        RemoveMagic(0, 1)
        RemoveMagic(1, 1)
        return 1
    end;
    AIFunction = function ()
        return AIRemoveTower(7)+AIRemoveEnemyTower(7)+AIRemoveMagic(1)+AIRemoveEnemyMagic(1)
    end;
}

Card
{
    Name = "Fire Ruby";
    Description = "+6 Tower\n4 Damage to\nall enemy\ntowers";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 13;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "images.png", Coordinates = {x = 88*0, y = 52*9, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddTower(0, 6)
        RemoveTower(1, 4)
        return 1
    end;
    AIFunction = function ()
        return AIAddTower(6)+AIRemoveEnemyTower(4)
    end;
}

Card
{
    Name = "Quarry's Help";
    Description = "+7 Tower\nLose 10\nbricks";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 4;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "images.png", Coordinates = {x = 88*1, y = 52*9, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddTower(0, 7)
        RemoveBricks(0, 10)
        return 1
    end;
    AIFunction = function ()
        return AIAddTower(7)+AIRemoveBricks(10)
    end;
}

Card
{
    Name = "Crystal Shield";
    Description = "+8 Tower\n+3 Wall";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 12;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "images.png", Coordinates = {x = 88*2, y = 52*9, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddTower(0, 8)
        AddWall(0, 3)
        return 1
    end;
    AIFunction = function ()
        return AIAddTower(8)+AIAddWall(3)
    end;
}

Card
{
    Name = "Empathy Gem";
    Description = "+8 Tower\n+1 Dungeon";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 14;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "images.png", Coordinates = {x = 88*3, y = 52*9, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddTower(0, 8)
        AddDungeon(0, 1)
        return 1
    end;
    AIFunction = function ()
        return AIAddTower(8)+AIAddDungeon(1)
    end;
}

Card
{
    Name = "Diamond";
    Description = "+15 Tower";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 16;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "images.png", Coordinates = {x = 88*4, y = 52*9, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddTower(0, 15)
        return 1
    end;
    AIFunction = function ()
        return AIAddTower(15)
    end;
}

Card
{
    Name = "Sanctuary";
    Description = "+10 Tower\n+5 Wall\nGain 5\nrecruits";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 15;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "images.png", Coordinates = {x = 88*5, y = 52*9, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddTower(0, 10)
        AddWall(0, 5)
        AddRecruits(0, 5)
        return 1
     end;
    AIFunction = function ()
        return AIAddTower(10)+AIAddWall(5)+AIAddRecruits(5)
    end;
}

Card
{
    Name = "Lava Jewel";
    Description = "+12 Tower\n6 damage to\nall enemies";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 17;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "images.png", Coordinates = {x = 88*0, y = 52*10, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddTower(0, 12)
        Damage(1, 6)
        return 1
    end;
    AIFunction = function ()
        return AIAddTower(12)+AIDamageEnemy(6)
    end;
}

Card
{
    Name = "Dragon's Eye";
    Description = "+20 Tower";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 21;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "images.png", Coordinates = {x = 88*1, y = 52*10, w = 88, h = 52}};
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
    Name = "Crystallize";
    Description = "+11 Tower\n-6 Wall";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 8;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "images.png", Coordinates = {x = 88*2, y = 52*10, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddTower(0, 11)
        RemoveWall(0, 6)
        return 1
    end;
    AIFunction = function ()
        return AIAddTower(11)+AIRemoveWall(6)
    end;
}

Card
{
    Name = "Bag of Baubles";
    Description = "If Tower < enemy Tower\n+2 Tower\nelse +1 Tower";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 2;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "images.png", Coordinates = {x = 88*3, y = 52*10, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        if GetTower(0) < GetTower(1) then
            AddTower(0, 2)
        else
            AddTower(0, 1)
        end
        return 1
    end;
    AIFunction = function ()
        if GetTower(0) < GetTower(1) then return AIAddTower(2) end
        return AIAddTower(1)
    end;
}

Card
{
    Name = "Rainbow";
    Description = "+1 Tower to all\nplayers.\nYou gain\n3 gems";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "images.png", Coordinates = {x = 88*4, y = 52*10, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddTower(0, 1)
        AddTower(1, 1)
        AddGems(0, 3)
        return 1
    end;
    AIFunction = function ()
        return AIAddTower(1)+AIAddEnemyTower(1)+AIAddGems(3)
    end;
}

Card
{
    Name = "Apprentice";
    Description = "+4 Tower, you\nlose 3 recruits\n2 damage to\nenemy Tower";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 5;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "images.png", Coordinates = {x = 88*5, y = 52*10, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddTower(0, 4)
        RemoveRecruits(0, 3)
        RemoveTower(1, 2)
        return 1
    end;
    AIFunction = function ()
        return AIAddTower(4)+AIRemoveRecruits(3)+AIRemoveEnemyTower(2)
    end;
}

Card
{
    Name = "Lightning Shard";
    Description = "If Tower > enemy\nWall, 8 damage\nto enemy tower\nelse 8 damage";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 11;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "images.png", Coordinates = {x = 88*0, y = 52*11, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        if GetTower(0) > GetWall(1) then
            RemoveTower(1, 8)
        else
            Damage(1, 8)
        end
        return 1
    end;
    AIFunction = function ()
        if GetTower(0) > GetWall(1) then return AIRemoveEnemyTower(8) end
        return AIDamageEnemy(8)
    end;
}

Card
{
    Name = "Phase Jewel";
    Description = "+13 Tower\n+6 recruits\n+6 bricks";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 18;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Blue";
    Picture = {File = "images.png", Coordinates = {x = 88*1, y = 52*11, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddTower(0, 13)
        AddRecruits(0, 6)
        AddBricks(0, 6)
        return 1
    end;
    AIFunction = function ()
        return AIAddTower(13)+AIAddRecruits(6)+AIAddBricks(6)
    end;
}

Card
{
    Name = "Mad Cow Disease";
    Description = "All players lose\n6 recruits";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "images.png", Coordinates = {x = 88*2, y = 52*11, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        RemoveRecruits(1, 6)
        RemoveRecruits(0, 6)
        return 1
    end;
    AIFunction = function ()
        return AIRemoveRecruits(6)+AIRemoveEnemyRecruits(6)
    end;
}

Card
{
    Name = "Faerie";
    Description = "2 Damage\nPlay again";
    Frequency = 2;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 1;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "images.png", Coordinates = {x = 88*3, y = 52*11, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        Damage(1, 2)
        return 0
    end;
    AIFunction = function () return 0.97 end;
}

Card
{
    Name = "Moody Goblins";
    Description = "4 Damage\nYou lose\n3 gems";
    Frequency = 2;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 1;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "images.png", Coordinates = {x = 88*4, y = 52*11, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        Damage(1, 4)
        RemoveGems(0, 3)
        return 1
    end;
    AIFunction = function ()
        return AIDamageEnemy(4)+AIRemoveGems(3)
    end;
}

Card
{
    Name = "Minotaur"; --GE: AKA Husbandry
    Description = "+1 Dungeon";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 3;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "images.png", Coordinates = {x = 88*5, y = 52*11, w = 88, h = 52}};
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
    Name = "Elven Scout";
    Description = "Draw 1 card\nDiscard 1 card\nPlay again";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 2;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "images.png", Coordinates = {x = 88*0, y = 52*12, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        return -1
    end;
    AIFunction = function () return 0.05 end;
}

Card
{
    Name = "Goblin Mob";
    Description = "6 Damage\nYou take\n3 damage";
    Frequency = 2;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 3;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "images.png", Coordinates = {x = 88*1, y = 52*12, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        Damage(1, 6)
        Damage(0, 3)
        return 1
    end;
    AIFunction = function ()
        return AIDamageEnemy(6)+AIDamage(3)
    end;
}

Card
{
    Name = "Goblin Archers";
    Description = "3 Damage to\nenemy tower\nYou take 1\ndamage";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 4;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "images.png", Coordinates = {x = 88*2, y = 52*12, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        RemoveTower(1, 3)
        Damage(0, 1)
        return 1
    end;
    AIFunction = function ()
        return AIRemoveEnemyTower(3)+AIDamage(1)
    end;
}

Card
{
    Name = "Shadow Faerie";
    Description = "2 Damage to\nenemy tower\nPlay again";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 6;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "images.png", Coordinates = {x = 88*3, y = 52*12, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        RemoveTower(1, 2)
        return 0
    end;
    AIFunction = function () return 0.97 end;
}

Card
{
    Name = "Orc";
    Description = "5 Damage";
    Frequency = 2;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 3;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "images.png", Coordinates = {x = 88*4, y = 52*12, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        Damage(1, 5)
        return 1
    end;
    AIFunction = function ()
        return AIDamageEnemy(5)
    end;
}

Card
{
    Name = "Dwarves";
    Description = "4 Damage\n+3 Wall";
    Frequency = 2;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 5;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "images.png", Coordinates = {x = 88*5, y = 52*12, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        Damage(1, 4)
        AddWall(0, 3)
        return 1
    end;
    AIFunction = function ()
        return AIDamageEnemy(4)+AIAddWall(3)
    end;
}

Card
{
    Name = "Little Snakes";
    Description = "4 Damage to\nenemy tower";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 6;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "images.png", Coordinates = {x = 88*0, y = 52*13, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        RemoveTower(1, 4)
        return 1
    end;
    AIFunction = function ()
        return AIRemoveEnemyTower(4)
    end;
}

Card
{
    Name = "Troll Trainer";
    Description = "+2 Dungeon";
    Frequency = 2;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 7;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "images.png", Coordinates = {x = 88*1, y = 52*13, w = 88, h = 52}};
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
    Name = "Tower Gremlin";
    Description = "2 Damage\n+4 Wall\n+2 Tower";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 8;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "images.png", Coordinates = {x = 88*2, y = 52*13, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        Damage(1, 2)
        AddWall(0, 4)
        AddTower(0, 2)
        return 1
    end;
    AIFunction = function ()
        return AIDamageEnemy(2)+AIAddWall(4)+AIAddTower(2)
    end;
}

Card
{
    Name = "Full Moon";
    Description = "+1 to all player's\nDungeon\nYou gain 3\nrecruits";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "images.png", Coordinates = {x = 88*3, y = 52*13, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        AddDungeon(0, 1)
        AddDungeon(1, 1)
        AddRecruits(0, 3)
        return 1
    end;
    AIFunction = function ()
        return AIAddDungeon(1)+AIAddEnemyDungeon(1)+AIAddRecruits(3)
    end;
}

Card
{
    Name = "Slasher";
    Description = "6 Damage";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 5;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "images.png", Coordinates = {x = 88*4, y = 52*13, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        Damage(1, 6)
        return 1
    end;
    AIFunction = function ()
        return AIDamageEnemy(6)
    end;
}

Card
{
    Name = "Ogre";
    Description = "7 Damage";
    Frequency = 2;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 6;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "images.png", Coordinates = {x = 88*5, y = 52*13, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        Damage(1, 7)
        return 1
    end;
    AIFunction = function ()
        return AIDamageEnemy(7)
    end;
}

Card
{
    Name = "Rabid Sheep";
    Description = "6 Damage\nEnemy loses\n3 recruits";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 6;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "images.png", Coordinates = {x = 88*0, y = 52*14, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        Damage(1, 6)
        RemoveRecruits(1, 3)
        return 1
    end;
    AIFunction = function ()
        return AIDamageEnemy(6)+AIRemoveEnemyRecruits(3)
    end;
}

Card
{
    Name = "Imp";
    Description = "6 Damage. All\nplayers lose 5\nbricks, gems\nand recruits";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 5;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "images.png", Coordinates = {x = 88*1, y = 52*14, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        Damage(1, 6)
        RemoveBricks(1, 5)
        RemoveGems(1, 5)
        RemoveRecruits(1, 5)
        RemoveBricks(0, 5)
        RemoveGems(0, 5)
        RemoveRecruits(0, 5)
        return 1
    end;
    AIFunction = function ()
        return AIDamageEnemy(6)+AIRemoveBricks(5)+AIRemoveEnemyBricks(5)+AIRemoveGems(5)+AIRemoveEnemyGems(5)+AIRemoveRecruits(5)+AIRemoveEnemyRecruits(5)
    end;
}

Card
{
    Name = "Spizzer";
    Description = "If enemy wall\n= 0, 10 damage,\nelse 6\ndamage";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 8;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "images.png", Coordinates = {x = 88*2, y = 52*14, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        if GetWall(1) == 0 then
            Damage(1, 10)
        else
            Damage(1, 6)
        end
        return 1
    end;
    AIFunction = function ()
        if GetWall(1) == 0 then return AIRemoveEnemyTower(10) end
        return AIDamageEnemy(6)
    end;
}

Card
{
    Name = "Werewolf";
    Description = "9 Damage";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 9;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "images.png", Coordinates = {x = 88*3, y = 52*14, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        Damage(1, 9)
        return 1
    end;
    AIFunction = function ()
        return AIDamageEnemy(9)
    end;
}

Card
{
    Name = "Corrosion Cloud";
    Description = "If enemy wall>0,\n10 damage, else\n7 damage";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 11;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "images.png", Coordinates = {x = 88*4, y = 52*14, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        if GetWall(1) > 0 then
            Damage(1, 10)
        else
            Damage(1, 7)
        end
        return 1
    end;
    AIFunction = function ()
        if GetWall(1) > 0 then return AIDamageEnemy(10) end
        return AIDamageEnemy(7)
    end;
}

Card
{
    Name = "Unicorn";
    Description = "If magic>enemy\nmagic, 12 dam-\nage, else\n8 damage";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 9;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "images.png", Coordinates = {x = 88*5, y = 52*14, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        if GetMagic(0) > GetMagic(1) then
            Damage(1, 12)
        else
            Damage(1, 8)
        end
        return 1
    end;
    AIFunction = function ()
        if GetMagic(0) > GetMagic(1) then return AIDamageEnemy(12) end
        return AIDamageEnemy(8)
    end;
}

Card
{
    Name = "Elven Archers";
    Description = "If wall>enemy\nwall, 6 damage\nto enemy tower\nelse 6 damage";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 10;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "images.png", Coordinates = {x = 88*0, y = 52*15, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        if GetWall(0) > GetWall(1) then
            RemoveTower(1, 6)
        else
            Damage(1, 6)
        end
        return 1
    end;
    AIFunction = function ()
        if GetWall(0) > GetWall(1) then return AIRemoveEnemyTower(6) end
        return AIDamageEnemy(6)
    end;
}

Card
{
    Name = "Succubus";
    Description = "5 Damage to\nenemy tower,\nenemy loses\n8 recruits";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 14;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "images.png", Coordinates = {x = 88*1, y = 52*15, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        RemoveTower(1, 5)
        RemoveRecruits(1, 8)
        return 1
    end;
    AIFunction = function ()
        return AIRemoveEnemyTower(5)+AIRemoveEnemyRecruits(8)
    end;
}

Card
{
    Name = "Rock Stompers";
    Description = "8 Damage\n-1 Enemy quarry";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 11;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "images.png", Coordinates = {x = 88*2, y = 52*15, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        Damage(1, 8)
        RemoveQuarry(1, 1)
        return 1
    end;
    AIFunction = function ()
        return AIDamageEnemy(8)+AIRemoveEnemyQuarry(1)
    end;
}

Card
{
    Name = "Thief";
    Description = "Enemy loses 10\ngems, 5 bricks,\nyou gain 1/2 amt.\nround up";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 12;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "images.png", Coordinates = {x = 88*3, y = 52*15, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        RemoveGems(1, 10)
        AddGems(0, math.ceil(math.min(GetGems(1), 10)/2.0))
        RemoveBricks(1, 5)
        AddBricks(0, math.ceil(math.min(GetBricks(1), 5)/2.0))
        return 1
    end;
    AIFunction = function ()
        local Priority = 0.0
        Priority = Priority+AIRemoveEnemyGems(10)+AIAddGems(math.ceil(math.min(GetGems(1), 10)/2.0))
        Priority = Priority+AIRemoveEnemyBricks(5)+AIAddBricks(math.ceil(math.min(GetBricks(1), 5)/2.0))
        return Priority
    end;
}

Card
{
    Name = "Stone Giant";
    Description = "10 Damage\n+4 Wall";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 15;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "images.png", Coordinates = {x = 88*4, y = 52*15, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        Damage(1, 10)
        AddWall(0, 4)
        return 1
    end;
    AIFunction = function ()
        return AIDamageEnemy(10)+AIAddWall(4)
    end;
}

Card
{
    Name = "Vampire";
    Description = "10 Damage\nEnemy loses 5\nrecruits, -1 enemy\nDungeon";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 17;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "images.png", Coordinates = {x = 88*5, y = 52*15, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        Damage(1, 10)
        RemoveRecruits(1, 5)
        RemoveDungeon(1, 1)
        return 1
    end;
    AIFunction = function ()
        return AIDamageEnemy(10)+AIRemoveEnemyRecruits(5)+AIRemoveEnemyDungeon(1)
    end;
}

Card
{
    Name = "Dragon";
    Description = "20 Damage\nEnemy loses 10\ngems, -1 enemy\nDungeon";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 25;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "images.png", Coordinates = {x = 88*0, y = 52*16, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        Damage(1, 20)
        RemoveGems(1, 10)
        RemoveDungeon(1, 1)
        return 1
    end;
    AIFunction = function ()
        local Priority = AIDamageEnemy(20)
        if Priority >= 1.0 then return Priority end
        return math.min(Priority+AIRemoveEnemyGems(10)+AIRemoveEnemyDungeon(1), 0.95)
    end;
}

Card
{
    Name = "Spearman";
    Description = "If Wall>enemy\nWall do 3\nDamage else\ndo 2 Damage";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 2;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "images.png", Coordinates = {x = 88*1, y = 52*16, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        if GetWall(0) > GetWall(1) then
            Damage(1, 3)
        else
            Damage(1, 2)
        end
        return 1
    end;
    AIFunction = function ()
        if GetWall(0) > GetWall(1) then return AIDamageEnemy(3) end
        return AIDamageEnemy(2)
    end;
}

Card
{
    Name = "Gnome";
    Description = "3 Damage\n+1 gem";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 2;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "images.png", Coordinates = {x = 88*2, y = 52*16, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        Damage(1, 3)
        AddGems(0, 1)
        return 1
    end;
    AIFunction = function ()
        return AIDamageEnemy(3)+AIAddGems(1)
    end;
}

Card
{
    Name = "Berserker";
    Description = "8 Damage\n3 Damage to\nyour Tower";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 4;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "images.png", Coordinates = {x = 88*3, y = 52*16, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        Damage(1, 8)
        RemoveTower(0, 3)
        return 1
    end;
    AIFunction = function ()
        return AIDamageEnemy(8)+AIRemoveTower(3)
    end;
}

Card
{
    Name = "Warlord";
    Description = "13 Damage\nYou lose 3 gems";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 13;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "images.png", Coordinates = {x = 88*4, y = 52*16, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        Damage(1, 13)
        RemoveGems(0, 3)
        return 1
    end;
    AIFunction = function ()
        return AIDamageEnemy(13)+AIRemoveGems(3)
    end;
}

Card
{
    Name = "Pegasus Lancer";
    Description = "12 Damage to\nenemy tower";
    Frequency = 1;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 18;
    Cursed = false;
    Colour = "Green";
    Picture = {File = "images.png", Coordinates = {x = 88*5, y = 52*16, w = 88, h = 52}};
    Keywords = "";
    PlayFunction = function ()
        RemoveTower(1, 12)
        return 1
    end;
    AIFunction = function ()
        return AIRemoveEnemyTower(12)
    end;
}
