-- MArcomage/MArcomagePool
-- The card pool for MArcomage cards
-- GreatEmerald, 2011

function MA_Init()
    local CardInfo = {ID = 0, Frequency = 1, Name = "", Description = "", BrickCost = 0, GemCost = 0, RecruitCost = 0, Cursed = false, Colour = "Black", Picture = {File = "", X = 0, Y = 0, W = 0, H = 0}, Keywords = "", LuaFunction = ""}
    local CardDB = {} --GE: This is the CardDB, thing that we'll send over to C/D
    
    for CardID = 0,1 do
        CardInfo = {ID = CardID, Frequency = 2, Name = "", Description = "", BrickCost = 0, GemCost = 0, RecruitCost = 0, Cursed = false, Colour = "Black", Picture = {File = "", X = 0, Y = 0, W = 0, H = 0}, Keywords = "", LuaFunction = ""}
    
        if CardID == 0 then
            CardInfo.Name = "Abyssal Scavenger"
            CardInfo.Description = "Returns 1/3 of total\ncost of opponent's\nlast card (max 4)"
            CardInfo.Frequency = 3
            CardInfo.LuaFunction = "MA_AbyssalScavenger"
            CardInfo.Keywords = "Far sight"
        end

        CardDB[CardID+1] = {Picture = {}}
        CardDB[CardID+1].ID = CardInfo.ID
        CardDB[CardID+1].Frequency = CardInfo.Frequency
        CardDB[CardID+1].Name = CardInfo.Name
        CardDB[CardID+1].Description = CardInfo.Description
        CardDB[CardID+1].BrickCost = CardInfo.BrickCost
        CardDB[CardID+1].GemCost = CardInfo.GemCost
        CardDB[CardID+1].RecruitCost = CardInfo.RecruitCost
        CardDB[CardID+1].Cursed = CardInfo.Cursed
        CardDB[CardID+1].Colour = CardInfo.Colour
        CardDB[CardID+1].Picture.File = CardInfo.Picture.File
        CardDB[CardID+1].Picture.X = CardInfo.Picture.X
        CardDB[CardID+1].Picture.Y = CardInfo.Picture.Y
        CardDB[CardID+1].Picture.W = CardInfo.Picture.W
        CardDB[CardID+1].Picture.H = CardInfo.Picture.H
        CardDB[CardID+1].Keywords = CardInfo.Keywords
        CardDB[CardID+1].LuaFunction = CardInfo.LuaFunction
    end
    return CardDB
end

function MA_AbyssalScavenger()
    AddBricks(0, math.floor( math.min(GetLast("BrickCost", 1)/3, 4)+.5 ) )
    AddGems(0, math.floor( math.min(GetLast("GemCost", 1)/3, 4)+.5 ) )
    AddRecruits(0, math.floor( math.min(GetLast("RecruitCost", 1)/3, 4)+.5 ) )
    return 1
end
