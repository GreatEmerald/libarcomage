/**
 * Module that handles all the inner mechanics of libarcomage.
 */  

module arcomage.cards;
import std.stdio;
import arcomage.arco;
import std.random;
import std.algorithm;

struct Stats
{
    int Bricks, Gems, Recruits;
    int Quarry, Magic, Dungeon;
    int Tower, Wall;
    string Name;
    CardInfo[] Hand;
};

Stats[] Player; /// Players. Supports more than 2. TODO to implement it.
bool DiscardTurn; /// Whether this turn is discard only.
bool InitComplete; /// Indicates whether the Queue is set up already.
int Turn; /// Number of the player whose turn it is. This is an absolute value.
//int NextTurn; /// Number of the player who will go next.
//int LastTurn; /// Number of the player whose turn ended before.
CardInfo[] Queue; /// Cards in the bank.
int CurrentPosition; /// The current position in the Queue.

/**
 * Defines functions and sends them over to Lua.
 */ 
auto InitLuaFunctions()
{
    lua["Damage"] = (int Who, int Amount)
    {
        Stats P = GetAbsolutePlayer(Who);
        
        if (P >= Amount)
            P.Wall -= Amount;
        else
        {
            P.Tower -= (Amount - P.Wall);
            P.Wall = 0;
        }
        FrontendFunctions.Sound_Play(SoundTypes.Damage);
    }
    
    lua["AddQuarry"] = (int Who, int Amount)
    {
        if (P.Quarry >= 99)
            return;
        
        Stats P = GetAbsolutePlayer(Who);
        
        P.Quarry += Amount;
        FrontendFunctions.Sound_Play(SoundTypes.ResB_Up);
    }
    
    lua["AddMagic"] = (int Who, int Amount)
    {
        if (P.Magic >= 99)
            return;
        
        Stats P = GetAbsolutePlayer(Who);

        P.Magic += Amount;
        FrontendFunctions.Sound_Play(SoundTypes.ResB_Up);
    }
    
    lua["AddDungeon"] = (int Who, int Amount)
    {
        if (P.Dungeon >= 99)
            return;

        Stats P = GetAbsolutePlayer(Who);
        
        P.Dungeon += Amount;
        FrontendFunctions.Sound_Play(SoundTypes.ResB_Up);
    }
    
    lua["AddBricks"] = (int Who, int Amount)
    {
        if (P.Bricks >= 999)
            return;
        
        Stats P = GetAbsolutePlayer(Who);

        P.Bricks += Amount;
        FrontendFunctions.Sound_Play(SoundTypes.ResS_Up);
    }
    
    lua["AddGems"] = (int Who, int Amount)
    {
        if (P.Gems >= 999)
            return;
        
        Stats P = GetAbsolutePlayer(Who);

        P.Gems += Amount;
        FrontendFunctions.Sound_Play(SoundTypes.ResS_Up);
    }
    
    lua["AddRecruits"] = (int Who, int Amount)
    {
        if (P.Recruits >= 999)
            return;
        
        Stats P = GetAbsolutePlayer(Who);

        P.Recruits += Amount;
        FrontendFunctions.Sound_Play(SoundTypes.ResS_Up);
    }
    
    lua["AddTower"] = (int Who, int Amount)
    {
        if (P.Tower >= Config.TowerVictory)
            return;
        
        Stats P = GetAbsolutePlayer(Who);

        P.Tower += Amount;
        FrontendFunctions.Sound_Play(SoundTypes.Tower_Up);
    }
    
    lua["AddWall"] = (int Who, int Amount)
    {
        if (P.Wall >= Config.MaxWall)
            return;
        
        Stats P = GetAbsolutePlayer(Who);

        P.Wall += Amount;
        FrontendFunctions.Sound_Play(SoundTypes.Wall_Up);
    }
    
    lua["RemoveQuarry"] = (int Who, int Amount)
    {
        if (P.Quarry <= 1)
            return;
        
        Stats P = GetAbsolutePlayer(Who);

        P.Quarry -= Amount;
        FrontendFunctions.Sound_Play(SoundTypes.ResB_Down);
    }
    
    lua["RemoveMagic"] = (int Who, int Amount)
    {
        if (P.Magic <= 1)
            return;
        
        Stats P = GetAbsolutePlayer(Who);

        P.Magic -= Amount;
        FrontendFunctions.Sound_Play(SoundTypes.ResB_Down);
    }
    
    lua["RemoveDungeon"] = (int Who, int Amount)
    {
        if (P.Dungeon <= 1)
            return;
        
        Stats P = GetAbsolutePlayer(Who);

        P.Dungeon -= Amount;
        FrontendFunctions.Sound_Play(SoundTypes.ResB_Down);
    }
    
    lua["RemoveBricks"] = (int Who, int Amount)
    {
        if (P.Bricks <= 0)
            return;
        
        Stats P = GetAbsolutePlayer(Who);

        P.Bricks -= Amount;
        FrontendFunctions.Sound_Play(SoundTypes.ResS_Down);
    }
    
    lua["RemoveGems"] = (int Who, int Amount)
    {
        if (P.Gems <= 0)
            return;
        
        Stats P = GetAbsolutePlayer(Who);

        P.Gems -= Amount;
        FrontendFunctions.Sound_Play(SoundTypes.ResS_Down);
    }
    
    lua["RemoveRecruits"] = (int Who, int Amount)
    {
        if (P.Recruits <= 0)
            return;
        
        Stats P = GetAbsolutePlayer(Who);

        P.Recruits -= Amount;
        FrontendFunctions.Sound_Play(SoundTypes.ResS_Down);
    }
    
    lua["RemoveTower"] = (int Who, int Amount)
    {
        Stats P = GetAbsolutePlayer(Who);

        P.Tower -= Amount;
        FrontendFunctions.Sound_Play(SoundTypes.Damage);
    }
    
    lua["RemoveWall"] = (int Who, int Amount)
    {
        if (P.Wall <= 0)
            return;
        
        Stats P = GetAbsolutePlayer(Who);

        P.Wall -= Amount;
        FrontendFunctions.Sound_Play(SoundTypes.Damage);
    }
    
    lua["GetQuarry"] = (int Who)
    {
        return GetAbsolutePlayer(Who).Quarry;
    }
    
    lua["GetMagic"] = (int Who)
    {
        return GetAbsolutePlayer(Who).Magic;
    }
    
    lua["GetDungeon"] = (int Who)
    {
        return GetAbsolutePlayer(Who).Dungeon;
    }
    
    lua["GetBricks"] = (int Who)
    {
        return GetAbsolutePlayer(Who).Bricks;
    }
    
    lua["GetGems"] = (int Who)
    {
        return GetAbsolutePlayer(Who).Gems;
    }
    
    lua["GetRecruits"] = (int Who)
    {
        return GetAbsolutePlayer(Who).Recruits;
    }
    
    lua["GetTower"] = (int Who)
    {
        return GetAbsolutePlayer(Who).Tower;
    }
    
    lua["GetWall"] = (int Who)
    {
        return GetAbsolutePlayer(Who).Wall;
    }
    
    lua["GetResourceVictory"] = ()
    {
        return Config.ResourceVictory;
    }
    
    lua["SetQuarry"] = (int Who, int Amount)
    {
        Stats P = GetAbsolutePlayer(Who);

        if (P.Quarry < Amount)
            Sound_Play(ResB_Up);
        else if (P.Quarry > Amount)
            Sound_Play(ResB_Down);

        P.Quarry = Amount;
    }
    
    lua["SetMagic"] = (int Who, int Amount)
    {
        Stats P = GetAbsolutePlayer(Who);

        if (P.Magic < Amount)
            Sound_Play(ResB_Up);
        else if (P.Magic > Amount)
            Sound_Play(ResB_Down);

        P.Magic = Amount;
    }
    
    lua["SetWall"] = (int Who, int Amount)
    {
        Stats P = GetAbsolutePlayer(Who);

        if (P.Wall < Amount)
            Sound_Play(Wall_Up);
        else if (P.Wall > Amount)
            Sound_Play(Damage);

        P.Wall = Amount;
    }
}

auto InitGame()
{
    int i, n;

    InitDeck();
    
    for (i=0;i<2;i++)//GE: TODO Implement variable amount of players!
    {
        for (n=0; n<Config.CardsInHand; n++)
        {
            Player[i].Hand ~= GetCard();
        }
        
        Player[i].Bricks = Config.BrickQuantities; Player[i].Gems = Config.GemQuantities; Player[i].Recruits = Config.RecruitQuantities;
        Player[i].Quarry = Config.QuarryLevels; Player[i].Magic = Config.MagicLevels; Player[i].Dungeon = Config.DungeonLevels;
        Player[i].Tower = Config.TowerLevels; Player[i].Wall = Config.WallLevels;
    }
}

void InitDeck()
{
    int i;

    if (!InitComplete)
    {
        foreach (CardInfo[] CIA; CardDB) //GE: TODO Add true Deck support
            foreach (CardInfo CI; CIA) //GE: Iterate through every card in CardDB
                for (i = 0; i < CI.Frequency; i++) //GE: Iterate though the frequency settings and set them
                    Queue ~= CI; //GE: This is a slow process, but I have to do it that way for readability and in order not to iterate through the DB twice.
        //GE: We now have Queue set up as a tidy array with card IDs depending on their frequency.
        InitComplete = true;
    }
    ShuffleQueue();
}

void ShuffleQueue()
{
    int a, b;
    CardInfo t;
    for (int i=0; i<32000; i++) //GE: A ludicrous way to randomise the Queue array.
	{
		a=rand()%Queue.length;
		b=rand()%Queue.length;
		t=Queue[a]; Queue[a]=Queue[b]; Queue[b]=t;
	}
	FrontendFunctions.Sound_Play(SHUFFLE);
}

CardInfo GetCard()//GE: Returns next card in the Queue array and moves CurrentPosition up.
{
    CardInfo CI;
    CI = Queue[CurrentPosition];
    if (CurrentPosition + 1 < Queue.length)
	   CurrentPosition++;
    else
    {
      ShuffleQ();
      CurrentPosition = 0;
    }
    return CI;
}

bool IsVictorious(int PlayerNumber)
{
    foreach (int i, Stats P; Player) //GE: Check if we are the last man standing.
    {
        if (P.Tower > 0 && i != PlayerNumber)
            break;
        else if (i == Player.length-1)
            return true;
    }
    if (Player[PlayerNumber].Tower >= Config.TowerVictory) //GE: Check if we got a tower victory.
        return true;
    
    if (Config.OneResourceVictory)
        return ((Player[PlayerNumber].Bricks >= Config.ResourceVictory) ||
            (Player[PlayerNumber].Gems >= Config.ResourceVictory) ||
            (Player[PlayerNumber].Recruits >= Config.ResourceVictory));
    else
        return ((Player[PlayerNumber].Bricks >= Config.ResourceVictory) &&
            (Player[PlayerNumber].Gems >= Config.ResourceVictory) &&
            (Player[PlayerNumber].Recruits >= Config.ResourceVictory));
}

void AIPlay()
{
    float HighestPriority=-1.f, CurrentPriority, LowestPriority=0.f;
    CardInfo Favourite, Worst;
    
    foreach (CardInfo CI; Player[Turn].Hand)
    {
        CurrentPriority = CI.AIFunction();
        CurentPriority = AlterAIPriority(CurrentPriority, CI);
        
        if ( (CanAffordCard(CI)) &&                                       //GE: If we can afford the card
            ( (HighestPriority < CurrentPriority) ||                      //GE: And it is more attractive than what we saw before
            (HighestPriority == CurrentPriority && uniform(0,2) => 1) ) ) //GE: Or it is as attractive (in which case we let luck decide)
        {
            HighestPriority = CurrentPriority; //GE: Get the highest priority card
            Favourite = CI;
        }
        if ( (!CI.Cursed) &&
            ( (LowestPriority > CurrentPriority) ||
            (LowestPriority == CurrentPriority && uniform(0,2) => 1) ) )
        {
            LowestPriority = CurrentPriority; //GE: Get the lowest priority card
            Worst = CI;
        }
    }
    if ((HighestPriority < 0.f) || ((HighestPriority == 0.f) && (uniform(0,2) => 1)))
    {
        PlayCard(Worst, true); //GE: If we have bad cards, pick the worst one and discard.
        return;
    }
    
    PlayCard(Favourite, false);
}

/**
 * Changes the AI priority of the given card by looking at the general trends
 * of the game. This is not specific to any card; card-specific code goes to Lua.
 * 
 * Bugs: Cards should use tags to denote which cards increase tower, which
 * damage etc.
 * 
 * Returns: Altered priority.
 */ 
float AlterAIPriority(float Priority, CardInfo CI)
{
    if (Player[Turn].Tower >= Config.TowerVictory*0.75 && CI.Colour == "Blue")
        Priority += 0.1;
    if (Player[Turn].Tower <= Config.TowerVictory*0.25 && CI.Colour == "Blue")
        Priority += 0.1;
    if (GetEnemy().Tower <= Config.TowerVictory*0.25 && GetEnemy().Wall <= Config.MaxWall*0.25 && CI.Colour == "Green")
        Priority += 0.1;
    if (GetEnemy().Tower >= Config.TowerVictory*0.75 && GetEnemy().Wall <= Config.MaxWall*0.25 && CI.Colour == "Green")
        Priority += 0.1;
    if (GetEnemy().Wall >= Config.MaxWall*0.75 && CI.Colour == "Green")
        Priority -= 0.1;
    if (GetEnemy().Wall <= Config.MaxWall*0.05 && CI.Colour == "Green")
        Priority += 0.1;
    if (Player[Turn].Wall >= Config.MaxWall*0.75 && CI.Colour == "Red")
        Priority -= 0.1;
    if (Player[Turn].Wall <= Config.MaxWall*0.25 && CI.Colour == "Red")
        Priority += 0.1;
    if (Config.OneResourceVictory)
    {
        if ((Player[Turn].Bricks >= Config.ResourceVictory*0.75 && CI.BrickCost > 0) ||
            (Player[Turn].Gems >= Config.ResourceVictory*0.75 && CI.GemCost > 0) ||
            (Player[Turn].Recruits >= Config.ResourceVictory*0.75 && CI.RecruitCost > 0))
            Priority -= 0.1;
    }
    else if (Player[Turn].Bricks >= Config.ResourceVictory*0.75 &&
        Player[Turn].Gems >= Config.ResourceVictory*0.75 &&
        Player[Turn].Recruits >= Config.ResourceVictory*0.75 &&
        (CI.BrickCost > 0 || CI.GemCost > 0 || CI.RecruitCost > 0))
        Priority -= 0.1;
    
    return Priority;
}

Stats GetEnemy()
{
    return Player[(Turn+1)%Player.length];
}

Stats GetAbsolutePlayer(int PlayerNumber)
{
    if (PlayerNumber == 1)
        return GetEnemy();
    else if (PlayerNumber == 0)
        return Player[Turn];
    else
        return Player[0];
}
