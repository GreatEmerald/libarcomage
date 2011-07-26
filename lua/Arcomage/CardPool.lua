-- Arcomage/CardPool
-- The Card Pool for the stock Arcomage deck.
-- GreatEmerald, 2011

-- GE: begin algorithm:
-- A Card Pool is a file that provides all of the information about individual
-- cards in a mod. For instance, this file contains all of the information about
-- the names and the frequency of the cards. This information is taken by the C
-- code that uses it to setup the cards for first use.
-- In short: It takes and fills the CardDB array in cards.h.

-- This is how communication works:
-- C has CardPool[] -> CardDB[] -> CardInfo{} -> ID, Frequency, Name
-- This is a single pool, so C/D is handling the CardPool[] part. But we need
-- to setup CardDB[]. All of the entries are unique, so there won't be much of
-- a problem.
-- Now Lua has these things called tables. They are something like a mix of
-- arrays and structs. I believe that I can create a global table that holds
-- the same as CardDB[], then transmit it through the stack. The stack will be
-- humongous, but it will only take a single element! Parsing it should only
-- take a single loop, too, and I can do it in D!

bUseOriginalCards = False
DeckSize = 0

function ArcomageInit()

  local CardInfo = {ID = 0, Frequency = 1, Name = "", Description = "", BrickCost = 0, GemCost = 0, RecruitCost = 0, Cursed = false, Colour = "Black", Picture = {File = "", X = 0, Y = 0, W = 0, H = 0}, Keywords = "", LuaFunction = ""}
  local CardDB = {} --GE: This is the CardDB, thing that we'll send over to C/D
  local Iteration = 0
  
  --[[local Test = {{x = "a", y = "b"}, {"c", "d"}}
  print("Test is:")
  print(Test)
  print("Test[1] is:")
  print(Test[1])
  print("Test[1].x is:")
  print(Test[1].x) ]]
  
  for CardID = 0,101 do --GE: We have 102 cards, IDs from 0-101. NOTE: Tables start at 1, not 0, so add one before adding to CardDB!
     Iteration = Iteration + 1
     print(Iteration)
     --CardDB[Iteration] = CardInfo
     CardDB[Iteration] = {Picture = {}}
     CardInfo = {ID = CardID, Frequency = 1, Name = "", Description = "", BrickCost = 0, GemCost = 0, RecruitCost = 0, Cursed = false, Colour = "Black", Picture = {File = "", X = 0, Y = 0, W = 0, H = 0}, Keywords = "", LuaFunction = ""}
     --[[CardInfo.ID = CardID --GE: Make sure we reset CardInfo each loop.
     CardInfo.Frequency = 1
     CardInfo.Name = ""
     CardInfo.Description = ""
     CardInfo.BrickCost = 0
     CardInfo.GemCost = 0
     CardInfo.RecruitCost = 0
     CardInfo.Colour = "Black"
     CardInfo.Picture = ""
     CardInfo.Keywords = ""
     CardInfo.LuaFunction = ""]]
     
     --GE: Frequency is init as 1 because it's the most common in Arcomage, for your mod you might want to use 3
     if CardID == 0 then
        CardInfo.Name = "Brick Shortage"
        CardInfo.Description = "All players\nlose 8 bricks"
        CardInfo.Colour = "Red"
	CardInfo.LuaFunction = "Arcomage_BrickShortage"
        --[[if bUseOriginalCards then
         CardInfo.Picture = {File = "../moli-arm/Data/SPRITES.bmp", X = 0, Y = 220, W=96, H=128}
      else
         CardInfo.Picture = {File = "data/deck.png", X = 96, Y = 0, W=96, H=128}
      end]]
     elseif CardID == 1 then
        CardInfo.Name = "Lucky Cache"
        CardInfo.Description = "+2 Bricks\n+2 Gems\nPlay again"
        CardInfo.Colour = "Red"
	CardInfo.LuaFunction = "Arcomage_LuckyCache"
     elseif CardID == 2 then
        CardInfo.Name = "Friendly Terrain"
        CardInfo.Description = "+1 Wall\nPlay again"
	CardInfo.Frequency = 2
        CardInfo.BrickCost = 1
        CardInfo.Colour = "Red"
	CardInfo.LuaFunction = "Arcomage_FriendlyTerrain"
     elseif CardID == 3 then
        CardInfo.Name = "Miners"
        CardInfo.Description = "+1 Quarry"
	CardInfo.Frequency = 2
        CardInfo.BrickCost = 3
        CardInfo.Colour = "Red"
	CardInfo.LuaFunction = "Arcomage_Miners"
     elseif CardID == 4 then
        CardInfo.Name = "Mother Lode"
        CardInfo.Description = "If quarry<enemy\nquarry, +2 quarry\nElse, +1\nquarry"
        CardInfo.BrickCost = 4
        CardInfo.Colour = "Red"
	CardInfo.LuaFunction = "Arcomage_MotherLode"
     elseif CardID == 5 then
        CardInfo.Name = "Dwarven Miners"
        CardInfo.Description = "+4 Wall\n+1 Quarry"
        CardInfo.BrickCost = 7
        CardInfo.Colour = "Red"
	CardInfo.LuaFunction = "Arcomage_DwarvenMiners"
     elseif CardID == 6 then
        CardInfo.Name = "Work Overtime"
        CardInfo.Description = "+5 Wall\nYou lose 6 gems"
	CardInfo.Frequency = 2
        CardInfo.BrickCost = 2
        CardInfo.Colour = "Red"
	CardInfo.LuaFunction = "Arcomage_WorkOvertime"
     elseif CardID == 7 then
        CardInfo.Name = "Copping the Tech"
        CardInfo.Description = "If quarry<enemy\nquarry, quarry =\nenemy quarry"
        CardInfo.BrickCost = 5
        CardInfo.Colour = "Red"
	CardInfo.LuaFunction = "Arcomage_CoppingTheTech"
     elseif CardID == 8 then
        CardInfo.Name = "Basic Wall"
        CardInfo.Description = "+3 Wall"
	CardInfo.Frequency = 2
        CardInfo.BrickCost = 2
        CardInfo.Colour = "Red"
	CardInfo.LuaFunction = "Arcomage_BasicWall"
     elseif CardID == 9 then
        CardInfo.Name = "Sturdy Wall"
        CardInfo.Description = "+4 Wall"
        CardInfo.BrickCost = 3
        CardInfo.Colour = "Red"
	CardInfo.LuaFunction = "Arcomage_SturdyWall"
     elseif CardID == 10 then
        CardInfo.Name = "Innovations"
        CardInfo.Description = "+1 to all players\nquarrys, you gain\n+4 gems"
        CardInfo.BrickCost = 2
        CardInfo.Colour = "Red"
	CardInfo.LuaFunction = "Arcomage_Innovations"
     elseif CardID == 11 then
        CardInfo.Name = "Foundations"
        CardInfo.Description = "If wall = 0, +6\nwall, else\n+3 wall"
	CardInfo.Frequency = 2
        CardInfo.BrickCost = 3
        CardInfo.Colour = "Red"
	CardInfo.LuaFunction = "Arcomage_Foundations"
     elseif CardID == 12 then
        CardInfo.Name = "Tremors"
        CardInfo.Description = "All walls take\n5 damage\nPlay again"
        CardInfo.BrickCost = 7
        CardInfo.Colour = "Red"
	CardInfo.LuaFunction = "Arcomage_Tremors"
     elseif CardID == 13 then
        CardInfo.Name = "Secret Room"
        CardInfo.Description = "+1 Magicl\nPlay again"
        CardInfo.BrickCost = 8
        CardInfo.Colour = "Red"
	CardInfo.LuaFunction = "Arcomage_SecretRoom"
     elseif CardID == 14 then
        CardInfo.Name = "Earthquake"
        CardInfo.Description = "-1 To all players\nquarrys"
        CardInfo.Colour = "Red"
	CardInfo.LuaFunction = "Arcomage_Earthquake"
     elseif CardID == 15 then
        CardInfo.Name = "Big Wall"
        CardInfo.Description = "+6 Wall"
	CardInfo.Frequency = 2
        CardInfo.BrickCost = 5
        CardInfo.Colour = "Red"
	CardInfo.LuaFunction = "Arcomage_BigWall"
     elseif CardID == 16 then
        CardInfo.Name = "Collapse!"
        CardInfo.Description = "-1 Enemy quarry"
        CardInfo.BrickCost = 4
        CardInfo.Colour = "Red"
	CardInfo.LuaFunction = "Arcomage_Collapse"
     elseif CardID == 17 then
        CardInfo.Name = "New Equipment"
        CardInfo.Description = "+2 quarry"
        CardInfo.BrickCost = 6
        CardInfo.Colour = "Red"
	CardInfo.LuaFunction = "Arcomage_NewEquipment"
     elseif CardID == 18 then
        CardInfo.Name = "Strip Mine"
        CardInfo.Description = "-1 Quarry, +10\nwall. You gain\n5 gems"
        CardInfo.Colour = "Red"
	CardInfo.LuaFunction = "Arcomage_StripMine"
     elseif CardID == 19 then
        CardInfo.Name = "Reinforced wall"
        CardInfo.Description = "+8 Wall"
	CardInfo.Frequency = 2
        CardInfo.BrickCost = 8
        CardInfo.Colour = "Red"
	CardInfo.LuaFunction = "Arcomage_ReinforcedWall"
     elseif CardID == 20 then
        CardInfo.Name = "Porticulus"
        CardInfo.Description = "+6 Wall\n+1 Dungeon"
        CardInfo.BrickCost = 9
        CardInfo.Colour = "Red"
	CardInfo.LuaFunction = "Arcomage_Porticulus"
     elseif CardID == 21 then
        CardInfo.Name = "Crystal Rocks"
        CardInfo.Description = "+7 Wall\ngain 7 gems"
        CardInfo.BrickCost = 9
        CardInfo.Colour = "Red"
	CardInfo.LuaFunction = "Arcomage_CrystalRocks"
     elseif CardID == 22 then
        CardInfo.Name = "Harmonic Ore"
        CardInfo.Description = "+6 Wall\n+3 Tower"
        CardInfo.BrickCost = 11
        CardInfo.Colour = "Red"
	CardInfo.LuaFunction = "Arcomage_HarmonicOre"
     elseif CardID == 23 then
        CardInfo.Name = "Mondo Wall"
        CardInfo.Description = "+12 Wall"
        CardInfo.BrickCost = 13
        CardInfo.Colour = "Red"
	CardInfo.LuaFunction = "Arcomage_MondoWall"
     elseif CardID == 24 then
        CardInfo.Name = "Focused Designs"
        CardInfo.Description = "+8 Wall\n+5 Tower"
        CardInfo.BrickCost = 15
        CardInfo.Colour = "Red"
	CardInfo.LuaFunction = "Arcomage_FocusedDesigns"
     elseif CardID == 25 then
        CardInfo.Name = "Great Wall"
        CardInfo.Description = "+15 Wall"
        CardInfo.BrickCost = 16
        CardInfo.Colour = "Red"
	CardInfo.LuaFunction = "Arcomage_GreatWall"
     elseif CardID == 26 then
        CardInfo.Name = "Rock Launcher"
        CardInfo.Description = "+6 Wall\n10 Damage\n to enemy"
        CardInfo.BrickCost = 18
        CardInfo.Colour = "Red"
	CardInfo.LuaFunction = "Arcomage_RockLauncher"
     elseif CardID == 27 then
        CardInfo.Name = "Dragon's Heart"
        CardInfo.Description = "+20 Wall\n+8 Tower"
        CardInfo.BrickCost = 24
        CardInfo.Colour = "Red"
	CardInfo.LuaFunction = "Arcomage_DragonsHeart"
     elseif CardID == 28 then
        CardInfo.Name = "Forced Labor"
        CardInfo.Description = "+9 Wall\nLose 5 recruits"
        CardInfo.BrickCost = 7
        CardInfo.Colour = "Red"
	CardInfo.LuaFunction = "Arcomage_ForcedLabor"
     elseif CardID == 29 then --GE: Start MM8 BP cards
        CardInfo.Name = "Rock Garden"
        CardInfo.Description = "+1 Wall\n+1 Tower\n+2 recruits"
        CardInfo.BrickCost = 1
        CardInfo.Colour = "Red"
	CardInfo.LuaFunction = "Arcomage_RockGarden"
     elseif CardID == 30 then
        CardInfo.Name = "Flood Water"
        CardInfo.Description = "Player(s) w/ lowest\nWall are -1 Dung-\neon and 2 dam-\nage to Tower" --GE: YES, Dung Neon and Damnage! >:3
        CardInfo.BrickCost = 6
        CardInfo.Colour = "Red"
	CardInfo.LuaFunction = "Arcomage_FloodWater"
     elseif CardID == 31 then
        CardInfo.Name = "Barracks"
        CardInfo.Description = "+6 recruits, +6 Wall\nif dungeon <\nenemy dungeon,\n+1 dungeon"
        CardInfo.BrickCost = 10
        CardInfo.Colour = "Red"
	CardInfo.LuaFunction = "Arcomage_Barracks"
     elseif CardID == 32 then
        CardInfo.Name = "Battlements"
        CardInfo.Description = "+7 Wall\n6 damage to\nenemy"
        CardInfo.BrickCost = 14
        CardInfo.Colour = "Red"
	CardInfo.LuaFunction = "Arcomage_Battlements"
     elseif CardID == 33 then
        CardInfo.Name = "Shift"
        CardInfo.Description = "Switch your Wall\nwith enemy Wall"
        CardInfo.BrickCost = 17
        CardInfo.Colour = "Red"
	CardInfo.LuaFunction = "Arcomage_Shift"
     elseif CardID == 34 then --GE: Start blue cards
        CardInfo.Name = "Quartz"
        CardInfo.Description = "+1 Tower,\nplay again"
	CardInfo.Frequency = 2
        CardInfo.GemCost = 1
        CardInfo.Colour = "Blue"
	CardInfo.LuaFunction = "Arcomage_Quartz"
     elseif CardID == 35 then
        CardInfo.Name = "Smoky Quartz"
        CardInfo.Description = "1 Damage to\nenemy tower\nPlay again"
        CardInfo.GemCost = 2
        CardInfo.Colour = "Blue"
	CardInfo.LuaFunction = "Arcomage_SmokyQuartz"
     elseif CardID == 36 then
        CardInfo.Name = "Amethyst"
        CardInfo.Description = "+3 Tower"
	CardInfo.Frequency = 2
        CardInfo.GemCost = 2
        CardInfo.Colour = "Blue"
	CardInfo.LuaFunction = "Arcomage_Amethyst"
     elseif CardID == 37 then
        CardInfo.Name = "Spell Weavers"
        CardInfo.Description = "+1 Magic"
	CardInfo.Frequency = 2
        CardInfo.GemCost = 3
        CardInfo.Colour = "Blue"
	CardInfo.LuaFunction = "Arcomage_SpellWeavers"
     elseif CardID == 38 then
        CardInfo.Name = "Prism"
        CardInfo.Description = "Draw 1 card\nDiscard 1 card\nPlay again"
        CardInfo.GemCost = 2
        CardInfo.Colour = "Blue"
	CardInfo.LuaFunction = "Arcomage_Prism"
     elseif CardID == 39 then
        CardInfo.Name = "Lodestone"
        CardInfo.Description = "+3 Tower. This\ncard can't be dis-\ncarded without\nplaying it"
        CardInfo.GemCost = 5
        CardInfo.Cursed = true
        CardInfo.Colour = "Blue"
	CardInfo.LuaFunction = "Arcomage_Lodestone"
     elseif CardID == 40 then
        CardInfo.Name = "Solar Flare"
        CardInfo.Description = "+2 Tower\n2 Damage to\nenemy tower"
        CardInfo.GemCost = 4
        CardInfo.Colour = "Blue"
	CardInfo.LuaFunction = "Arcomage_SolarFlare"
     elseif CardID == 41 then
        CardInfo.Name = "Crystal Matrix"
        CardInfo.Description = "+1 Magic\n+3 Tower\n+1 Enemy\ntower"
        CardInfo.GemCost = 6
        CardInfo.Colour = "Blue"
	CardInfo.LuaFunction = "Arcomage_CrystalMatrix"
     elseif CardID == 42 then
        CardInfo.Name = "Gemstone Flaw"
        CardInfo.Description = "3 Damage to\nenemy tower"
	CardInfo.Frequency = 2
        CardInfo.GemCost = 2
        CardInfo.Colour = "Blue"
	CardInfo.LuaFunction = "Arcomage_GemstoneFlaw"
     elseif CardID == 43 then
        CardInfo.Name = "Ruby"
        CardInfo.Description = "+5 Tower"
	CardInfo.Frequency = 2
        CardInfo.GemCost = 3
        CardInfo.Colour = "Blue"
	CardInfo.LuaFunction = "Arcomage_Ruby"
     elseif CardID == 44 then
        CardInfo.Name = "Gem Spear"
        CardInfo.Description = "5 Damage\nto enemy tower"
        CardInfo.GemCost = 4
        CardInfo.Colour = "Blue"
	CardInfo.LuaFunction = "Arcomage_GemSpear"
     elseif CardID == 45 then
        CardInfo.Name = "Power Burn"
        CardInfo.Description = "5 Damage\nto your tower\n+2 Magic"
        CardInfo.GemCost = 3
        CardInfo.Colour = "Blue"
	CardInfo.LuaFunction = "Arcomage_PowerBurn"
     elseif CardID == 46 then
        CardInfo.Name = "Harmonic Vibe"
        CardInfo.Description = "+1 Magic\n+3 Tower\n+3 Wall"
        CardInfo.GemCost = 7
        CardInfo.Colour = "Blue"
	CardInfo.LuaFunction = "Arcomage_HarmonicVibe"
     elseif CardID == 47 then
        CardInfo.Name = "Parity"
        CardInfo.Description = "All player's\nmagic equals\nthe highest\nplayer's magic"
        CardInfo.GemCost = 7
        CardInfo.Colour = "Blue"
	CardInfo.LuaFunction = "Arcomage_Parity"
     elseif CardID == 48 then
        CardInfo.Name = "Emerald"
        CardInfo.Description = "+8 Tower"
	CardInfo.Frequency = 2
        CardInfo.GemCost = 6
        CardInfo.Colour = "Blue"
	CardInfo.LuaFunction = "Arcomage_Emerald"
     elseif CardID == 49 then
        CardInfo.Name = "Pearl of Wisdom"
        CardInfo.Description = "+5 Tower\n+1 Magic"
        CardInfo.GemCost = 9
        CardInfo.Colour = "Blue"
	CardInfo.LuaFunction = "Arcomage_PearlOfWisdom"
     elseif CardID == 50 then
        CardInfo.Name = "Shatterer"
        CardInfo.Description = "-1 Magic.\n9 Damage to\nenemy tower"
        CardInfo.GemCost = 8
        CardInfo.Colour = "Blue"
	CardInfo.LuaFunction = "Arcomage_Shatterer"
     elseif CardID == 51 then
        CardInfo.Name = "Crumblestone"
        CardInfo.Description = "+5 Tower\nEnemy loses\n6 bricks"
        CardInfo.GemCost = 7
        CardInfo.Colour = "Blue"
	CardInfo.LuaFunction = "Arcomage_Crumblestone"
     elseif CardID == 52 then
        CardInfo.Name = "Sapphire"
        CardInfo.Description = "+11 Tower"
	CardInfo.Frequency = 2
        CardInfo.GemCost = 10
        CardInfo.Colour = "Blue"
	CardInfo.LuaFunction = "Arcomage_Sapphire"
     elseif CardID == 53 then
        CardInfo.Name = "Discord"
        CardInfo.Description = "7 Damage to\nall towers, all\nplayer's magic\n-1"
        CardInfo.GemCost = 5
        CardInfo.Colour = "Blue"
	CardInfo.LuaFunction = "Arcomage_Discord"
     elseif CardID == 54 then
        CardInfo.Name = "Fire Ruby"
        CardInfo.Description = "+6 Tower\n4 Damage to\nall enemy\ntowers"
        CardInfo.GemCost = 13
        CardInfo.Colour = "Blue"
	CardInfo.LuaFunction = "Arcomage_FireRuby"
     elseif CardID == 55 then
        CardInfo.Name = "Quarry's Help"
        CardInfo.Description = "+7 Tower\nLose 10\nbricks"
        CardInfo.GemCost = 4
        CardInfo.Colour = "Blue"
	CardInfo.LuaFunction = "Arcomage_QuarrysHelp"
     elseif CardID == 56 then
        CardInfo.Name = "Crystal Shield"
        CardInfo.Description = "+8 Tower\n+3 Wall"
        CardInfo.GemCost = 12
        CardInfo.Colour = "Blue"
	CardInfo.LuaFunction = "Arcomage_CrystalShield"
     elseif CardID == 57 then
        CardInfo.Name = "Empathy Gem"
        CardInfo.Description = "+8 Tower\n+1 Dungeon"
        CardInfo.GemCost = 14
        CardInfo.Colour = "Blue"
	CardInfo.LuaFunction = "Arcomage_EmpathyGem"
     elseif CardID == 58 then
        CardInfo.Name = "Diamond"
        CardInfo.Description = "+15 Tower"
        CardInfo.GemCost = 16
        CardInfo.Colour = "Blue"
	CardInfo.LuaFunction = "Arcomage_Diamond"
     elseif CardID == 59 then
        CardInfo.Name = "Sanctuary"
        CardInfo.Description = "+10 Tower\n+5 Wall\nGain 5\nrecruits"
        CardInfo.GemCost = 15
        CardInfo.Colour = "Blue"
	CardInfo.LuaFunction = "Arcomage_Sanctuary"
     elseif CardID == 60 then
        CardInfo.Name = "Lava Jewel"
        CardInfo.Description = "+12 Tower\n6 damage to\nall enemies"
        CardInfo.GemCost = 17
        CardInfo.Colour = "Blue"
	CardInfo.LuaFunction = "Arcomage_LavaJewel"
     elseif CardID == 61 then
        CardInfo.Name = "Dragon's Eye"
        CardInfo.Description = "+20 Tower"
        CardInfo.GemCost = 21
        CardInfo.Colour = "Blue"
	CardInfo.LuaFunction = "Arcomage_DragonsEye"
     elseif CardID == 62 then
        CardInfo.Name = "Crystallize"
        CardInfo.Description = "+11 Tower\n-6 Wall"
        CardInfo.GemCost = 8
        CardInfo.Colour = "Blue"
	CardInfo.LuaFunction = "Arcomage_Crystallize"
     elseif CardID == 63 then --GE: Start MM8 BP cards
        CardInfo.Name = "Bag of Baubles"
        CardInfo.Description = "If Tower < enemy\nTower\n+2 Tower\nelse\n+1 Tower"
        CardInfo.GemCost = 2
        CardInfo.Colour = "Blue"
	CardInfo.LuaFunction = "Arcomage_BagOfBaubles"
     elseif CardID == 64 then
        CardInfo.Name = "Rainbow"
        CardInfo.Description = "+1 Tower to all\nplayers.\nYou gain\n3 gems"
        CardInfo.Colour = "Blue"
	CardInfo.LuaFunction = "Arcomage_Rainbow"
     elseif CardID == 65 then
        CardInfo.Name = "Apprentice"
        CardInfo.Description = "+4 Tower, you\nlose 3 recruits\n2 damage to\nenemy Tower"
        CardInfo.GemCost = 5
        CardInfo.Colour = "Blue"
	CardInfo.LuaFunction = "Arcomage_Apprentice"
     elseif CardID == 66 then
        CardInfo.Name = "Lightning Shard"
        CardInfo.Description = "If Tower > enemy\nWall, 8 damage\nto enemy tower\nelse 8 damage"
        CardInfo.GemCost = 11
        CardInfo.Colour = "Blue"
	CardInfo.LuaFunction = "Arcomage_LightningShard"
     elseif CardID == 67 then
        CardInfo.Name = "Phase Jewel"
        CardInfo.Description = "+13 Tower\n+6 recruits\n+6 bricks"
        CardInfo.GemCost = 18
        CardInfo.Colour = "Blue"
	CardInfo.LuaFunction = "Arcomage_PhaseJewel"
     elseif CardID == 68 then --GE: Start green cards
        CardInfo.Name = "Mad Cow Disease"
        CardInfo.Description = "All players lose\n6 recruits"
        CardInfo.Colour = "Green"
	CardInfo.LuaFunction = "Arcomage_MadCowDisease"
     elseif CardID == 69 then
        CardInfo.Name = "Faerie"
        CardInfo.Description = "2 Damage\nPlay again"
	CardInfo.Frequency = 2
        CardInfo.RecruitCost = 1
        CardInfo.Colour = "Green"
	CardInfo.LuaFunction = "Arcomage_Faerie"
     elseif CardID == 70 then
        CardInfo.Name = "Moody Goblins"
        CardInfo.Description = "4 Damage\nYou lose\n3 gems"
	CardInfo.Frequency = 2
        CardInfo.RecruitCost = 1
        CardInfo.Colour = "Green"
	CardInfo.LuaFunction = "Arcomage_MoodyGoblins"
     elseif CardID == 71 then
        CardInfo.Name = "Minotaur" --GE: AKA Husbandry
        CardInfo.Description = "+1 Dungeon"
        CardInfo.RecruitCost = 3
	CardInfo.LuaFunction = "Arcomage_Minotaur"
        CardInfo.Colour = "Green"
     elseif CardID == 72 then
        CardInfo.Name = "Elven Scout"
        CardInfo.Description = "Draw 1 card\nDiscard 1 card\nPlay again"
        CardInfo.RecruitCost = 2
        CardInfo.Colour = "Green"
	CardInfo.LuaFunction = "Arcomage_Prism"
     elseif CardID == 73 then
        CardInfo.Name = "Goblin Mob"
        CardInfo.Description = "6 Damage\nYou take\n3 damage"
	CardInfo.Frequency = 2
        CardInfo.RecruitCost = 3
        CardInfo.Colour = "Green"
	CardInfo.LuaFunction = "Arcomage_GoblinMob"
     elseif CardID == 74 then
        CardInfo.Name = "Goblin Archers"
        CardInfo.Description = "3 Damage to\nenemy tower\nYou take 1\ndamage"
        CardInfo.RecruitCost = 4
        CardInfo.Colour = "Green"
        CardInfo.LuaFunction = "Arcomage_GoblinArchers"
     elseif CardID == 75 then
        CardInfo.Name = "Shadow Faerie"
        CardInfo.Description = "2 Damage to\nenemy tower\nPlay again"
        CardInfo.RecruitCost = 6
        CardInfo.Colour = "Green"
        CardInfo.LuaFunction = "Arcomage_ShadowFaerie"
     elseif CardID == 76 then
        CardInfo.Name = "Orc"
        CardInfo.Description = "5 Damage"
	CardInfo.Frequency = 2
        CardInfo.RecruitCost = 3
        CardInfo.Colour = "Green"
        CardInfo.LuaFunction = "Arcomage_Orc"
     elseif CardID == 77 then
        CardInfo.Name = "Dwarves"
        CardInfo.Description = "4 Damage\n+3 Wall"
	CardInfo.Frequency = 2
        CardInfo.RecruitCost = 5
        CardInfo.Colour = "Green"
        CardInfo.LuaFunction = "Arcomage_Dwarves"
     elseif CardID == 78 then
        CardInfo.Name = "Little Snakes"
        CardInfo.Description = "4 Damage to\nenemy tower"
        CardInfo.RecruitCost = 6
        CardInfo.Colour = "Green"
        CardInfo.LuaFunction = "Arcomage_LittleSnakes"
     elseif CardID == 79 then
        CardInfo.Name = "Troll Trainer"
        CardInfo.Description = "+2 Dungeon"
	CardInfo.Frequency = 2
        CardInfo.RecruitCost = 7
        CardInfo.Colour = "Green"
        CardInfo.LuaFunction = "Arcomage_TrollTrainer"
     elseif CardID == 80 then
        CardInfo.Name = "Tower Gremlin"
        CardInfo.Description = "2 Damage\n+4 Wall\n+2 Tower"
        CardInfo.RecruitCost = 8
        CardInfo.Colour = "Green"
        CardInfo.LuaFunction = "Arcomage_TowerGremlin"
     elseif CardID == 81 then
        CardInfo.Name = "Full Moon"
        CardInfo.Description = "+1 to all player's\nDungeon\nYou gain 3\nrecruits"
        CardInfo.Colour = "Green"
        CardInfo.LuaFunction = "Arcomage_FullMoon"
     elseif CardID == 82 then
        CardInfo.Name = "Slasher"
        CardInfo.Description = "6 Damage"
        CardInfo.RecruitCost = 5
        CardInfo.Colour = "Green"
        CardInfo.LuaFunction = "Arcomage_Slasher"
     elseif CardID == 83 then
        CardInfo.Name = "Ogre"
        CardInfo.Description = "7 Damage"
	CardInfo.Frequency = 2
        CardInfo.RecruitCost = 6
        CardInfo.Colour = "Green"
        CardInfo.LuaFunction = "Arcomage_Ogre"
     elseif CardID == 84 then
        CardInfo.Name = "Rabid Sheep"
        CardInfo.Description = "6 Damage\nEnemy loses\n3recruits"
        CardInfo.RecruitCost = 6
        CardInfo.Colour = "Green"
        CardInfo.LuaFunction = "Arcomage_RabidSheep"
     elseif CardID == 85 then
        CardInfo.Name = "Imp"
        CardInfo.Description = "6 Damage. All\nplayers lose 5\nbricks, gems\nand recruits"
        CardInfo.RecruitCost = 5
        CardInfo.Colour = "Green"
        CardInfo.LuaFunction = "Arcomage_Imp"
     elseif CardID == 86 then
        CardInfo.Name = "Spizzer"
        CardInfo.Description = "If enemy wall\n= 0, 10 damage,\nelse 6\ndamage"
        CardInfo.RecruitCost = 8
        CardInfo.Colour = "Green"
        CardInfo.LuaFunction = "Arcomage_Spizzer"
     elseif CardID == 87 then
        CardInfo.Name = "Werewolf"
        CardInfo.Description = "9 Damage"
        CardInfo.RecruitCost = 9
        CardInfo.Colour = "Green"
        CardInfo.LuaFunction = "Arcomage_Werewolf"
     elseif CardID == 88 then
        CardInfo.Name = "Corrosion Cloud"
        CardInfo.Description = "If enemy wall>0,\n10 damage, else\n7 damage"
        CardInfo.RecruitCost = 11
        CardInfo.Colour = "Green"
        CardInfo.LuaFunction = "Arcomage_CorrosionCloud"
     elseif CardID == 89 then
        CardInfo.Name = "Unicorn"
        CardInfo.Description = "If magic>enemy\nmagic, 12 dam-\nage, else\n8 damage"
        CardInfo.RecruitCost = 9
        CardInfo.Colour = "Green"
        CardInfo.LuaFunction = "Arcomage_Unicorn"
     elseif CardID == 90 then
        CardInfo.Name = "Elven Archers"
        CardInfo.Description = "If wall>enemy\wall, 6 damage\nto enemy tower\nelse 6 damage"
        CardInfo.RecruitCost = 10
        CardInfo.Colour = "Green"
        CardInfo.LuaFunction = "Arcomage_ElvenArchers"
     elseif CardID == 91 then
        CardInfo.Name = "Succubus"
        CardInfo.Description = "5 Damage to\nenemy tower,\nenemy loses\n8 recruits"
        CardInfo.RecruitCost = 14
        CardInfo.Colour = "Green"
        CardInfo.LuaFunction = "Arcomage_Succubus"
     elseif CardID == 92 then
        CardInfo.Name = "Rock Stompers"
        CardInfo.Description = "8 Damage\n-1 Enemy quarry"
        CardInfo.RecruitCost = 11
        CardInfo.Colour = "Green"
        CardInfo.LuaFunction = "Arcomage_RockStompers"
     elseif CardID == 93 then
        CardInfo.Name = "Thief"
        CardInfo.Description = "Enemy loses 10\ngems, 5 bricks,\nyou gain 1/2 amt.\nround up"
        CardInfo.RecruitCost = 12
        CardInfo.Colour = "Green"
        CardInfo.LuaFunction = "Arcomage_Thief"
     elseif CardID == 94 then
        CardInfo.Name = "Stone Giant"
        CardInfo.Description = "10 Damage\n+4 Wall"
        CardInfo.RecruitCost = 15
        CardInfo.Colour = "Green"
        CardInfo.LuaFunction = "Arcomage_StoneGiant"
     elseif CardID == 95 then
        CardInfo.Name = "Vampire"
        CardInfo.Description = "10 Damage\nEnemy loses 5\nrecruits, -1 enemy\nDungeon"
        CardInfo.RecruitCost = 17
        CardInfo.Colour = "Green"
        CardInfo.LuaFunction = "Arcomage_Vampire"
     elseif CardID == 96 then
        CardInfo.Name = "Dragon"
        CardInfo.Description = "20 Damage\nEnemy loses 10\ngems, -1 enemy\nDungeon"
        CardInfo.RecruitCost = 25
        CardInfo.Colour = "Green"
        CardInfo.LuaFunction = "Arcomage_Dragon"
     elseif CardID == 97 then --GE: Start MM8 BP cards
        CardInfo.Name = "Spearman"
        CardInfo.Description = "If Wall>enemy\nWall do 3\nDamage else\ndo 2 Damage"
        CardInfo.RecruitCost = 2
        CardInfo.Colour = "Green"
        CardInfo.LuaFunction = "Arcomage_Spearman"
     elseif CardID == 98 then
        CardInfo.Name = "Gnome"
        CardInfo.Description = "3 Damage\n+1 gem"
        CardInfo.RecruitCost = 2
        CardInfo.Colour = "Green"
        CardInfo.LuaFunction = "Arcomage_Gnome"
     elseif CardID == 99 then
        CardInfo.Name = "Berserker"
        CardInfo.Description = "8 Damage\n3 Damage to\nyour Tower"
        CardInfo.RecruitCost = 4
        CardInfo.Colour = "Green"
        CardInfo.LuaFunction = "Arcomage_Berserker"
     elseif CardID == 100 then
        CardInfo.Name = "Warlord"
        CardInfo.Description = "13 Damage\nYou lose 3 gems"
        CardInfo.RecruitCost = 13
        CardInfo.Colour = "Green"
        CardInfo.LuaFunction = "Arcomage_Warlord"
     elseif CardID == 101 then
        CardInfo.Name = "Pegasus Lancer"
        CardInfo.Description = "12 Damage to\nenemy tower"
        CardInfo.RecruitCost = 18
        CardInfo.Colour = "Green"
        CardInfo.LuaFunction = "Arcomage_PegasusLancer"
     end
     
     CardDB[Iteration].ID = CardInfo.ID
     CardDB[Iteration].Frequency = CardInfo.Frequency
     CardDB[Iteration].Name = CardInfo.Name
     CardDB[Iteration].Description = CardInfo.Description
     CardDB[Iteration].BrickCost = CardInfo.BrickCost
     CardDB[Iteration].GemCost = CardInfo.GemCost
     CardDB[Iteration].RecruitCost = CardInfo.RecruitCost
     CardDB[Iteration].Cursed = CardInfo.Cursed
     CardDB[Iteration].Colour = CardInfo.Colour
     --CardDB[Iteration].Picture.File = CardInfo.Picture.File
     --if bUseOriginalCards then
     --    CardDB[Iteration].Picture.File = "../moli-arm/Data/SPRITES.bmp"
     --else
         CardDB[Iteration].Picture.File = "data/deck.png"
     --end
     --CardDB[Iteration].Picture.X = CardInfo.Picture.X
     CardDB[Iteration].Picture.X = CardID%34*96+96
     --CardDB[Iteration].Picture.Y = CardInfo.Picture.Y
     CardDB[Iteration].Picture.Y = math.floor(CardID/34)*128
     CardDB[Iteration].Picture.W = 96
     CardDB[Iteration].Picture.H = 128
     --CardDB[Iteration].Picture.W = CardInfo.Picture.W
     --CardDB[Iteration].Picture.H = CardInfo.Picture.H
     CardDB[Iteration].Keywords = CardInfo.Keywords
     CardDB[Iteration].LuaFunction = CardInfo.LuaFunction
     --print(CardDB[1]["Name"])
  end
  
  for i,v in ipairs(CardDB) do print(i,v) end
  
  --[[{ID = 0,
  Frequency = 1,
  Name = "ohai",
  Description = "",
  BrickCost = 0,
  GemCost = 0,
  RecruitCost = 0,
  Picture = "",
  Keywords = "",
  LuaFunction = "",
  Colour = "Black"},]]
  
  -- GE: Start CardDB information generation. Unfortunately, everything is a pointer in Lua, thus making a loop is not going to work.
  --[[CardDB = {
  
  {ID = 0,
  Frequency = 1,
  Name = "Brick Shortage",
  Description = "All players\nlose 8 bricks",
  BrickCost = 0,
  GemCost = 0,
  RecruitCost = 0,
  Picture = "",
  Keywords = "",
  LuaFunction = "",
  Colour = "Red"},
  
  {ID = 1,
  Frequency = 1,
  Name = "Lucky Cache",
  Description = "+2 Bricks\n+2 Gems\nPlay again",
  BrickCost = 0,
  GemCost = 0,
  RecruitCost = 0,
  Picture = "",
  Keywords = "",
  LuaFunction = "",
  Colour = "Red"},
  
  {ID = 2,
  Frequency = 1,
  Name = "Friendly Terrain",
  Description = "+1 Wall\nPlay again",
  BrickCost = 0,
  GemCost = 0,
  RecruitCost = 0,
  Picture = "",
  Keywords = "",
  LuaFunction = "",
  Colour = "Black"},
  
  } ]]
  return CardDB
end

-- GE: Begin card-specific functions. Returning the relative person who is going next: 0 is you, 1 is enemy.
function Arcomage_BrickShortage()
    RemoveBricks(0, 8)
    RemoveBricks(1, 8)
    return 1
end

function Arcomage_LuckyCache()
    AddBricks(0, 2)
    AddGems(0, 2)
    return 0
end

function Arcomage_FriendlyTerrain()
    AddWall(0, 1)
    return 0
end

function Arcomage_Miners()
    AddQuarry(0, 1)
    return 1
end

function Arcomage_MotherLode()
    --print("Motherlode: is" .. GetQuarry(0) .. "lower than" .. GetQuarry(1))
    if GetQuarry(0) < GetQuarry(1) then
	AddQuarry(0, 2)
    else
	AddQuarry(0, 1)
    end
    return 1
end

function Arcomage_DwarvenMiners()
    AddWall(0, 4)
    AddQuarry(0, 1)
    return 1
end

function Arcomage_WorkOvertime()
    AddWall(0, 5)
    RemoveGems(0, 6)
    return 1
end

function Arcomage_CoppingTheTech()
    if GetQuarry(0) < GetQuarry(1) then
	SetQuarry(0, GetQuarry(1))
    end
    return 1
end

function Arcomage_BasicWall()
    AddWall(0, 3)
    return 1
end

function Arcomage_SturdyWall()
    AddWall(0, 4)
    return 1
end

function Arcomage_Innovations()
    AddQuarry(0, 1)
    AddQuarry(1, 1)
    AddGems(0, 4)
    return 1
end

function Arcomage_Foundations()
    if GetWall(0) == 0 then
	AddWall(0, 6)
    else
	AddWall(0, 3)
    end
    return 1
end

function Arcomage_Tremors()
    RemoveWall(1, 5)
    RemoveWall(0, 5)
    return 0
end

function Arcomage_SecretRoom()
    AddMagic(0, 1)
    return 0
end

function Arcomage_Earthquake()
    RemoveQuarry(1, 1)
    RemoveQuarry(0, 1)
    return 1
end

function Arcomage_BigWall()
    AddWall(0, 6)
    return 1
end

function Arcomage_Collapse()
    RemoveQuarry(1, 1)
    return 1
end

function Arcomage_NewEquipment()
    AddQuarry(0, 2)
    return 1
end

function Arcomage_StripMine()
    RemoveQuarry(0, 1)
    AddWall(0, 10)
    AddGems(0, 5)
    return 1
end

function Arcomage_ReinforcedWall()
    AddWall(0, 8)
    return 1
end

function Arcomage_Porticulus()
    AddWall(0, 6)
    AddDungeon(0, 1)
    return 1
end

function Arcomage_CrystalRocks()
    AddWall(0, 7)
    AddGems(0, 7)
    return 1
end

function Arcomage_HarmonicOre()
    AddWall(0, 6)
    AddTower(0, 3)
    return 1
end

function Arcomage_MondoWall()
    AddWall(0, 12)
    return 1
end

function Arcomage_FocusedDesigns()
    AddWall(0, 8)
    AddTower(0, 5)
    return 1
end

function Arcomage_GreatWall()
    AddWall(0, 15)
    return 1
end

function Arcomage_RockLauncher()
    AddWall(0, 6)
    Damage(1, 10)
    return 1
end

function Arcomage_DragonsHeart()
    AddWall(0, 20)
    AddTower(0, 8)
    return 1
end

function Arcomage_ForcedLabor()
    AddWall(0, 9)
    RemoveRecruits(0, 5)
    return 1
end

function Arcomage_RockGarden()
    AddWall(0, 1)
    AddTower(0, 1)
    AddRecruits(0, 2)
    return 1
end

function Arcomage_FloodWater()
    if GetWall(0) < GetWall(1) then
	RemoveDungeon(0, 1)
	RemoveTower(0, 2)
    else
	RemoveDungeon(1, 1)
	RemoveTower(1, 2)
    end
    return 1
end

function Arcomage_Barracks()
    AddRecruits(0, 6)
    AddWall(0, 6)
    if GetDungeon(0) < GetDungeon(1) then
	AddDungeon(0, 1)
    end
    return 1
end

function Arcomage_Battlements()
    AddWall(0, 7)
    Damage(1, 6)
    return 1
end

function Arcomage_Shift()
    local temp = GetWall(0)
    SetWall(0, GetWall(1))
    SetWall(1, temp)
    return 1
end

function Arcomage_Quartz()
    AddTower(0, 1)
    return 0
end

function Arcomage_SmokyQuartz()
    RemoveTower(1, 1)
    return 0
end

function Arcomage_Amethyst()
    AddTower(0, 3)
    return 1
end

function Arcomage_SpellWeavers()
    AddMagic(0, 1)
    return 1
end

function Arcomage_Prism()
    return -1
end

function Arcomage_Lodestone()
    AddTower(0, 3)
    return 1
end

function Arcomage_SolarFlare()
    AddTower(0, 2)
    RemoveTower(1, 2)
    return 1
end

function Arcomage_CrystalMatrix()
    AddMagic(0, 1)
    AddTower(0, 3)
    AddTower(1, 1)
    return 1
end

function Arcomage_GemstoneFlaw()
    RemoveTower(1, 3)
    return 1
end

function Arcomage_Ruby()
    AddTower(0, 5)
    return 1
end

function Arcomage_GemSpear()
    RemoveTower(1, 5)
    return 1
end

function Arcomage_PowerBurn()
    RemoveTower(0, 5)
    AddMagic(0, 2)
    return 1
end

function Arcomage_HarmonicVibe()
    AddMagic(0, 1)
    AddTower(0, 3)
    AddWall(0, 3)
    return 1
end

function Arcomage_Parity()
    local HighestMagic = math.max(GetMagic(0), GetMagic(1))
    SetMagic(0, HighestMagic)
    SetMagic(1, HighestMagic)
    return 1
end

function Arcomage_Emerald()
    AddTower(0, 8)
    return 1
end

function Arcomage_PearlOfWisdom()
    AddTower(0, 5)
    AddMagic(0, 1)
    return 1
end

function Arcomage_Shatterer()
    RemoveMagic(0, 1)
    RemoveTower(1, 9)
    return 1
end

function Arcomage_Crumblestone()
    AddTower(0, 5)
    RemoveBricks(1, 6)
    return 1
end

function Arcomage_Sapphire()
    AddTower(0, 11)
    return 1
 end

function Arcomage_Discord()
    RemoveTower(0, 7)
    RemoveTower(1, 7)
    RemoveMagic(0, 1)
    RemoveMagic(1, 1)
    return 1
end

function Arcomage_FireRuby()
    AddTower(0, 6)
    RemoveTower(1, 4)
    return 1
end

function Arcomage_QuarrysHelp()
    AddTower(0, 7)
    RemoveBricks(0, 10)
    return 1
end

function Arcomage_CrystalShield()
    AddTower(0, 8)
    AddWall(0, 3)
    return 1
end

function Arcomage_EmpathyGem()
    AddTower(0, 8)
    AddDungeon(0, 1)
    return 1
end


function Arcomage_Diamond()
    AddTower(0, 15)
    return 1
end

function Arcomage_Sanctuary()
    AddTower(0, 10)
    AddWall(0, 5)
    AddRecruits(0, 5)
    return 1
 end

function Arcomage_LavaJewel()
    AddTower(0, 12)
    Damage(1, 6)
    return 1
end

function Arcomage_DragonsEye()
    AddTower(0, 20)
    return 1
end

function Arcomage_Crystallize()
    AddTower(0, 11)
    RemoveWall(0, 6)
    return 1
end

function Arcomage_BagOfBaubles()
    if GetTower(0) < GetTower(1) then
	AddTower(0, 2)
    else
	AddTower(0, 1)
    end
    return 1
end

function Arcomage_Rainbow()
    AddTower(0, 1)
    AddTower(1, 1)
    AddGems(0, 3)
    return 1
end

function Arcomage_Apprentice()
    AddTower(0, 4)
    RemoveRecruits(0, 3)
    RemoveTower(1, 2)
    return 1
end

function Arcomage_LightningShard()
    if GetTower(0) > GetWall(1) then
	RemoveTower(1, 8)
    else
	Damage(1, 8)
    end
    return 1
end

function Arcomage_PhaseJewel()
    AddTower(0, 13)
    AddRecruits(0, 6)
    AddBricks(0, 6)
    return 1
end

function Arcomage_MadCowDisease()
    RemoveRecruits(1, 6)
    RemoveRecruits(0, 6)
    return 1
end

function Arcomage_Faerie()
    Damage(1, 2)
    return 0
end

function Arcomage_MoodyGoblins()
    Damage(1, 4)
    RemoveGems(0, 3)
    return 1
end

function Arcomage_Minotaur()
    AddDungeon(0, 1)
    return 1
end

function Arcomage_GoblinMob()
    Damage(1, 6)
    Damage(0, 3)
    return 1
end

function Arcomage_GoblinArchers()
    RemoveTower(1, 3)
    Damage(0, 1)
    return 1
end

function Arcomage_ShadowFaerie()
    RemoveTower(1, 2)
    return 0
end

function Arcomage_Orc()
    Damage(1, 5)
    return 1
end

function Arcomage_Dwarves()
    Damage(1, 4)
    AddWall(0, 3)
    return 1
end

function Arcomage_LittleSnakes()
    RemoveTower(1, 4)
    return 1
end

function Arcomage_TrollTrainer()
    AddDungeon(0, 2)
    return 1
end

function Arcomage_TowerGremlin()
    Damage(1, 2)
    AddWall(0, 4)
    AddTower(0, 2)
    return 1
end

function Arcomage_FullMoon()
    AddDungeon(0, 1)
    AddDungeon(1, 1)
    AddRecruits(0, 3)
    return 1
end

function Arcomage_Slasher()
    Damage(1, 6)
    return 1
end

function Arcomage_Ogre()
    Damage(1, 7)
    return 1
end

function Arcomage_RabidSheep()
    Damage(1, 6)
    RemoveRecruits(1, 3)
    return 1
end

function Arcomage_Imp()
    Damage(1, 6)
    RemoveBricks(1, 5)
    RemoveGems(1, 5)
    RemoveRecruits(1, 5)
    RemoveBricks(0, 5)
    RemoveGems(0, 5)
    RemoveRecruits(0, 5)
    return 1
end

function Arcomage_Spizzer()
    if GetWall(1) == 0 then
	Damage(1, 10)
    else
	Damage(1, 6)
    end
    return 1
end

function Arcomage_Werewolf()
    Damage(1, 9)
    return 1
end

function Arcomage_CorrosionCloud()
    if GetWall(1) > 0 then
        Damage(1, 10)
    else
        Damage(1, 7)
    end
    return 1
end

function Arcomage_Unicorn()
    if GetMagic(0) > GetMagic(1) then
        Damage(1, 12)
    else
        Damage(1, 8)
    end
    return 1
end

function Arcomage_ElvenArchers()
    if GetWall(0) > GetWall(1) then
        RemoveTower(1, 6)
    else
        Damage(1, 6)
    end
    return 1
end

function Arcomage_Succubus()
    RemoveTower(1, 5)
    RemoveRecruits(1, 8)
    return 1
end

function Arcomage_RockStompers()
    Damage(1, 8)
    RemoveQuarry(1, 1)
    return 1
end

function Arcomage_Thief()
    if GetGems(1) >= 10 then
        RemoveGems(1, 10)
        AddGems(0, 5)
    else
        RemoveGems(1, 10)
        AddGems(0, math.ceil(GetGems(1)/2))
    end
    if GetBricks(1) >= 5 then
        RemoveBricks(1, 5)
        AddBricks(0, 3)
    else
        RemoveBricks(1, 5)
        AddBricks(0, math.ceil(GetBricks(1)/2))
    end
    return 1
end

function Arcomage_StoneGiant()
    Damage(1, 10)
    AddWall(0, 4)
    return 1
end

function Arcomage_Vampire()
    Damage(1, 10)
    RemoveRecruits(1, 5)
    RemoveDungeon(1, 1)
    return 1
end

function Arcomage_Dragon()
    Damage(1, 20)
    RemoveGems(1, 10)
    RemoveDungeon(1, 1)
    return 1
end

function Arcomage_Spearman()
    if GetWall(0) > GetWall(1) then
        Damage(1, 3)
    else
        Damage(1, 2)
    end
    return 1
end

function Arcomage_Gnome()
    Damage(1, 3)
    AddGems(0, 1)
    return 1
end

function Arcomage_Berserker()
    Damage(1, 8)
    RemoveTower(0, 3)
    return 1
end

function Arcomage_Warlord()
    Damage(1, 13)
    RemoveGems(0, 3)
    return 1
end

function Arcomage_PegasusLancer()
    RemoveTower(1, 12)
    return 1
end
