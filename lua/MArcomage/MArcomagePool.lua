-- MArcomage/MArcomagePool
--- The card pool for MArcomage cards
-- @copyright GreatEmerald, 2011

Card 
{
    Name = "Abyssal Scavenger";
    Description = "Returns 1/3 of total\ncost of opponent's\nlast card (max 4)";
    Frequency = 3;
    BrickCost = 0;
    GemCost = 0;
    RecruitCost = 0;
    Cursed = false;
    Colour = "Black";
    Picture = {File = "", X = 0, Y = 0, W = 0, H = 0};
    Keywords = "Far sight";
    PlayFunction = function ()
        AddBricks(0, math.floor( math.min(GetLast("BrickCost", 1)/3, 4)+.5 ) )
        AddGems(0, math.floor( math.min(GetLast("GemCost", 1)/3, 4)+.5 ) )
        AddRecruits(0, math.floor( math.min(GetLast("RecruitCost", 1)/3, 4)+.5 ) )
        return 1
    end;
    AIFunction = function () return 0 end;
}
