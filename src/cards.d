/**
 * Module that handles all the inner mechanics of libarcomage.
 */

module cards;
import std.stdio;
import arco;
import std.random;
import std.algorithm;

struct Stats
{
    int Bricks, Gems, Recruits;
    int Quarry, Magic, Dungeon;
    int Tower, Wall;
    string Name;
    bool AI;
    CardInfo[] Hand;
};

Stats[] Player; /// Players. Supports more than 2. TODO to implement it.
bool DiscardRound; /// Whether this turn is discard only.
bool InitComplete; /// Indicates whether the Queue is set up already.
extern(C) shared int Turn; /// Number of the player whose turn it is. This is an absolute value.
int NextTurn; /// Number of the player who will go next.
int LastTurn; /// Number of the player whose turn ended before.
CardInfo[] Queue; /// Cards in the bank.
int CurrentPosition = 0; /// The current position in the Queue.

struct ChangeInfo
{
    int Bricks, Gems, Recruits; // GEm: The changes the played card had on the player's resources
    int Quarry, Magic, Dungeon;
    int Tower, Wall;
    CardInfo PlayedCard; // GEm: This is only filled for the player who played the card
    bool bDiscarded;
}

Stats[][] StatHistory; // GEm: Absolute stat changes.
ChangeInfo[][] StatChanges; // GEm: Relative stat changes and the last card played. The two are synced.

/**
 * Defines functions and sends them over to Lua.
 */
void InitLuaFunctions()
{
    lua["Damage"] = (int Who, int Amount)
    {
        Stats* P = &Player[GetAbsolutePlayer(Who)];
        int OldWall;

        if (Amount <= 0)
            return;

        if (P.Wall >= Amount)
        {
            P.Wall -= Amount;
            FrontendFunctions.EffectNotify(GetAbsolutePlayer(Who), EffectType.DamageWall);
        }
        else
        {
            OldWall = P.Wall;
            if (P.Wall > 0)
            {
                P.Wall = 0;
                FrontendFunctions.EffectNotify(GetAbsolutePlayer(Who), EffectType.DamageWall);
            }
            P.Tower -= (Amount - OldWall);
            FrontendFunctions.EffectNotify(GetAbsolutePlayer(Who), EffectType.DamageTower);
        }

    };

    lua["AddQuarry"] = (int Who, int Amount)
    {
        Stats* P = &Player[GetAbsolutePlayer(Who)];

        if (P.Quarry >= 99)
            return;

        P.Quarry += Amount;
        FrontendFunctions.EffectNotify(GetAbsolutePlayer(Who), EffectType.QuarryUp);
    };

    lua["AddMagic"] = (int Who, int Amount)
    {
        Stats* P = &Player[GetAbsolutePlayer(Who)];

        if (P.Magic >= 99)
            return;

        P.Magic += Amount;
        FrontendFunctions.EffectNotify(GetAbsolutePlayer(Who), EffectType.MagicUp);
    };

    lua["AddDungeon"] = (int Who, int Amount)
    {
        Stats* P = &Player[GetAbsolutePlayer(Who)];

        if (P.Dungeon >= 99)
            return;

        P.Dungeon += Amount;
        FrontendFunctions.EffectNotify(GetAbsolutePlayer(Who), EffectType.DungeonUp);
    };

    lua["AddBricks"] = (int Who, int Amount)
    {
        Stats* P = &Player[GetAbsolutePlayer(Who)];

        if (P.Bricks >= 999)
            return;

        P.Bricks += Amount;
        FrontendFunctions.EffectNotify(GetAbsolutePlayer(Who), EffectType.BricksUp);
    };

    lua["AddGems"] = (int Who, int Amount)
    {
        Stats* P = &Player[GetAbsolutePlayer(Who)];

        if (P.Gems >= 999)
            return;

        P.Gems += Amount;
        FrontendFunctions.EffectNotify(GetAbsolutePlayer(Who), EffectType.GemsUp);
    };

    lua["AddRecruits"] = (int Who, int Amount)
    {
        Stats* P = &Player[GetAbsolutePlayer(Who)];

        if (P.Recruits >= 999)
            return;

        P.Recruits += Amount;
        FrontendFunctions.EffectNotify(GetAbsolutePlayer(Who), EffectType.RecruitsUp);
    };

    lua["AddTower"] = (int Who, int Amount)
    {
        Stats* P = &Player[GetAbsolutePlayer(Who)];

        if (P.Tower >= Config.TowerVictory)
            return;

        P.Tower += Amount;
        FrontendFunctions.EffectNotify(GetAbsolutePlayer(Who), EffectType.TowerUp);
    };

    lua["AddWall"] = (int Who, int Amount)
    {
        Stats* P = &Player[GetAbsolutePlayer(Who)];

        if (P.Wall >= Config.MaxWall)
            return;

        P.Wall += Amount;
        FrontendFunctions.EffectNotify(GetAbsolutePlayer(Who), EffectType.WallUp);
    };

    lua["RemoveQuarry"] = (int Who, int Amount)
    {
        Stats* P = &Player[GetAbsolutePlayer(Who)];

        if (P.Quarry <= 1)
            return;

        P.Quarry -= Amount;
        FrontendFunctions.EffectNotify(GetAbsolutePlayer(Who), EffectType.QuarryDown);
    };

    lua["RemoveMagic"] = (int Who, int Amount)
    {
        Stats* P = &Player[GetAbsolutePlayer(Who)];

        if (P.Magic <= 1)
            return;
        P.Magic -= Amount;
        FrontendFunctions.EffectNotify(GetAbsolutePlayer(Who), EffectType.MagicDown);
    };

    lua["RemoveDungeon"] = (int Who, int Amount)
    {
        Stats* P = &Player[GetAbsolutePlayer(Who)];

        if (P.Dungeon <= 1)
            return;

        P.Dungeon -= Amount;
        FrontendFunctions.EffectNotify(GetAbsolutePlayer(Who), EffectType.DungeonDown);
    };

    lua["RemoveBricks"] = (int Who, int Amount)
    {
        Stats* P = &Player[GetAbsolutePlayer(Who)];

        if (P.Bricks <= 0)
            return;

        P.Bricks -= Amount;
        FrontendFunctions.EffectNotify(GetAbsolutePlayer(Who), EffectType.BricksDown);
    };

    lua["RemoveGems"] = (int Who, int Amount)
    {
        Stats* P = &Player[GetAbsolutePlayer(Who)];

        if (P.Gems <= 0)
            return;

        P.Gems -= Amount;
        FrontendFunctions.EffectNotify(GetAbsolutePlayer(Who), EffectType.GemsDown);
    };

    lua["RemoveRecruits"] = (int Who, int Amount)
    {
        Stats* P = &Player[GetAbsolutePlayer(Who)];

        if (P.Recruits <= 0)
            return;

        P.Recruits -= Amount;
        FrontendFunctions.EffectNotify(GetAbsolutePlayer(Who), EffectType.RecruitsDown);
    };

    lua["RemoveTower"] = (int Who, int Amount)
    {
        Stats* P = &Player[GetAbsolutePlayer(Who)];

        P.Tower -= Amount;
        FrontendFunctions.EffectNotify(GetAbsolutePlayer(Who), EffectType.DamageTower);
    };

    lua["RemoveWall"] = (int Who, int Amount)
    {
        Stats* P = &Player[GetAbsolutePlayer(Who)];

        if (P.Wall <= 0)
            return;

        P.Wall -= Amount;
        FrontendFunctions.EffectNotify(GetAbsolutePlayer(Who), EffectType.DamageWall);
    };

    lua["GetQuarry"] = (int Who)
    {
        return Player[GetAbsolutePlayer(Who)].Quarry;
    };

    lua["GetMagic"] = (int Who)
    {
        return Player[GetAbsolutePlayer(Who)].Magic;
    };

    lua["GetDungeon"] = (int Who)
    {
        return Player[GetAbsolutePlayer(Who)].Dungeon;
    };

    lua["GetBricks"] = (int Who)
    {
        return Player[GetAbsolutePlayer(Who)].Bricks;
    };

    lua["GetGems"] = (int Who)
    {
        return Player[GetAbsolutePlayer(Who)].Gems;
    };

    lua["GetRecruits"] = (int Who)
    {
        return Player[GetAbsolutePlayer(Who)].Recruits;
    };

    lua["GetTower"] = (int Who)
    {
        return Player[GetAbsolutePlayer(Who)].Tower;
    };

    lua["GetWall"] = (int Who)
    {
        return Player[GetAbsolutePlayer(Who)].Wall;
    };

    lua["GetResourceVictory"] = ()
    {
        return Config.ResourceVictory;
    };

    lua["GetTowerVictory"] = ()
    {
        return Config.TowerVictory;
    };

    lua["GetMaxWall"] = ()
    {
        return Config.MaxWall;
    };

    lua["SetQuarry"] = (int Who, int Amount)
    {
        Stats* P = &Player[GetAbsolutePlayer(Who)];
        int OldQuarry = P.Quarry;

        P.Quarry = Amount;

        if (OldQuarry < Amount)
            FrontendFunctions.EffectNotify(GetAbsolutePlayer(Who), EffectType.QuarryUp);
        else if (OldQuarry > Amount)
            FrontendFunctions.EffectNotify(GetAbsolutePlayer(Who), EffectType.QuarryDown);
    };

    lua["SetMagic"] = (int Who, int Amount)
    {
        Stats* P = &Player[GetAbsolutePlayer(Who)];
        int OldMagic = P.Magic;

        P.Magic = Amount;

        if (OldMagic < Amount)
            FrontendFunctions.EffectNotify(GetAbsolutePlayer(Who), EffectType.MagicUp);
        else if (OldMagic > Amount)
            FrontendFunctions.EffectNotify(GetAbsolutePlayer(Who), EffectType.MagicDown);
    };

    lua["SetDungeon"] = (int Who, int Amount)
    {
        Stats* P = &Player[GetAbsolutePlayer(Who)];
        int OldDungeon = P.Dungeon;

        P.Dungeon = Amount;

        if (OldDungeon < Amount)
            FrontendFunctions.EffectNotify(GetAbsolutePlayer(Who), EffectType.DungeonUp);
        else if (OldDungeon > Amount)
            FrontendFunctions.EffectNotify(GetAbsolutePlayer(Who), EffectType.DungeonDown);
    };

    lua["SetWall"] = (int Who, int Amount)
    {
        Stats* P = &Player[GetAbsolutePlayer(Who)];
        int OldWall = P.Wall;

        P.Wall = Amount;

        if (OldWall < Amount)
            FrontendFunctions.EffectNotify(GetAbsolutePlayer(Who), EffectType.WallUp);
        else if (OldWall > Amount)
            FrontendFunctions.EffectNotify(GetAbsolutePlayer(Who), EffectType.DamageWall);
    };

    lua["SetTower"] = (int Who, int Amount)
    {
        Stats* P = &Player[GetAbsolutePlayer(Who)];
        int OldTower = P.Tower;

        P.Tower = Amount;

        if (OldTower < Amount)
            FrontendFunctions.EffectNotify(GetAbsolutePlayer(Who), EffectType.TowerUp);
        else if (OldTower > Amount)
            FrontendFunctions.EffectNotify(GetAbsolutePlayer(Who), EffectType.DamageTower);
    };

    lua["OneResourceVictory"] = Config.OneResourceVictory;
}

extern(C) void initGame()
{
    int i, n;

    InitDeck();

    for (i=0;i<2;i++)//GE: TODO Implement variable amount of players!
    {
        for (n=0; n<Config.CardsInHand; n++)
        {
            Player.length = i+1;
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
        a=uniform(0, cast(int).Queue.length);
        b=uniform(0, cast(int).Queue.length);
        t=Queue[a]; Queue[a]=Queue[b]; Queue[b]=t;
    }
    FrontendFunctions.EffectNotify(0, EffectType.CardShuffle);
}

/**
 * Returns the next card in the queue and moves the CurrentPosition up.
 */
CardInfo GetCard()
{
    CardInfo CI;
    CI = Queue[CurrentPosition];
    if (CurrentPosition + 1 < Queue.length)
	   CurrentPosition++;
    else
    {
      ShuffleQueue();
      CurrentPosition = 0;
    }
    return CI;
}

/**
 * Puts the card to the closest garbage card slot.
 * This way we know what has been discarded before etc.
 */
void PutCard(CardInfo CI)
{

    Queue[((CurrentPosition-Config.CardsInHand*2)+cast(int).Queue.length)%cast(int).Queue.length] = CI;
}

extern (C) bool IsVictorious(int PlayerNumber)
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

extern (C) void AIPlay()
{
    float HighestPriority=-1.0, CurrentPriority, LowestPriority=1.0;
    int Favourite, Worst;

    foreach (int i, CardInfo CI; Player[Turn].Hand)
    {
        //writeln("DEBUG: AI is trying to figure out the priority of ", CI.Name);
        CurrentPriority = CI.AIFunction();//CI.AIFunction.call!float(); //GE: DMD has no clue what LuaFunction returns, thus we have to tell it that it's a single float.
        //writeln("DEBUG: Priority ", CurrentPriority);
        CurrentPriority = AlterAIPriority(CurrentPriority, CI);
        //writeln("DEBUG: Priority ", CurrentPriority);

        if ( (CanAffordCard(CI, Turn)) &&                                       //GE: If we can afford the card
            ( (HighestPriority < CurrentPriority) ||                      //GE: And it is more attractive than what we saw before
            (HighestPriority == CurrentPriority && uniform(0,2) >= 1) ) ) //GE: Or it is as attractive (in which case we let luck decide)
        {
            HighestPriority = CurrentPriority; //GE: Get the highest priority card
            Favourite = i;
        }
        if ( (!CI.Cursed) &&
            ( (LowestPriority > CurrentPriority) ||
            (LowestPriority == CurrentPriority && uniform(0,2) >= 1) ) )
        {
            LowestPriority = CurrentPriority; //GE: Get the lowest priority card
            Worst = i;
        }
    }
    if (((HighestPriority < 0.0) || ((HighestPriority == 0.0) && (uniform(0,2) >= 1))) || DiscardRound )
    {
        if (!Player[Turn].Hand[Worst].Cursed)
            PlayCard(Worst, true); //GE: If we have bad cards, pick the worst one and discard.
        else
        {
            writeln("Warning: cards: AIPlay: Trying to discard a cursed card!");
            foreach (int i, CardInfo CI; Player[Turn].Hand)
            {
                if (!CI.Cursed)
                {
                    PlayCard(i, true);
                    break;
                }
            }
        }
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
    /*if (Player[Turn].Tower >= Config.TowerVictory*0.75 && CI.Colour == "Blue")
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
        Priority += 0.1;*/
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

/**
 * Check whether the card the payer is attempting to play is playable.
 */
bool CanPlayCard(CardInfo CI, bool Discarded)
{
    if (Discarded && CI.Cursed)
        return false;     // Cursed cards like LodeStone can't be discarded

    if (DiscardRound && !Discarded) //GE: You're trying to play a card during a discard round. Bad.
       return false;

    return true;
}

/**
 * Functionality when playing a card.
 *
 * Plays the animation, handles the turn sequence, distributes resources
 *
 * Parameters:
 *     CardPlace = The number of the card in the player's hand.
 *     Discarded = Whether this card is to be discarded.
 */
bool PlayCard(int CardPlace, bool Discarded)
{
    CardInfo CI = Player[Turn].Hand[CardPlace];

    //GE: You get resources when you use a card and next up is the enemy's turn.

    if (!CanPlayCard(CI, Discarded) || (!Discarded && !CanAffordCard(CI, Turn)))
        return false;

    FrontendFunctions.PlayCardAnimation(CardPlace, Discarded, LastTurn == Turn);

    if (!Discarded)
        TakeResources(&Player[Turn], CI.BrickCost, CI.GemCost, CI.RecruitCost); //GE: Eat the required resources.

    StatHistory ~= Player; // GEm: Save the pre-play stats into the history.
    GetNextTurn(CI, Discarded); //GE: Execute the card and change NextTurn based on it.
    SaveStatChanges(CI, Discarded);

    Normalise(); //GE: Make sure we are not out of bounds.
    PutCard(CI); //GE: Put that card back to the queue, like in a real card game.
    FrontendFunctions.PlayCardPostAnimation(CardPlace);

    if (Turn != NextTurn) //GE: if you didn't put a play again card or you have discarded
    {
        Player[NextTurn].Bricks += Player[NextTurn].Quarry; //GE: The enemy gets resources.
        Player[NextTurn].Gems += Player[NextTurn].Magic;
        Player[NextTurn].Recruits += Player[NextTurn].Dungeon;
    }
    Player[Turn].Hand[CardPlace] = GetCard();
    LastTurn = Turn;
    Turn = NextTurn;

    return true;
}

/**
 * Figures out what exactly the played card changed and writes it into StatChanges.
 * Needed for the MArcomage card abilities.
 */
void SaveStatChanges(CardInfo PlayedCard, bool bDiscarded)
{
    ChangeInfo[] CI;
    CI.length = Player.length;

    foreach (int i, ChangeInfo Diff; CI)
    {
        CI[i].Bricks = Player[i].Bricks - StatHistory[StatHistory.length-1][i].Bricks;
        CI[i].Gems = Player[i].Gems - StatHistory[StatHistory.length-1][i].Gems;
        CI[i].Recruits = Player[i].Recruits - StatHistory[StatHistory.length-1][i].Recruits;
        CI[i].Quarry = Player[i].Quarry - StatHistory[StatHistory.length-1][i].Quarry;
        CI[i].Magic = Player[i].Magic - StatHistory[StatHistory.length-1][i].Magic;
        CI[i].Dungeon = Player[i].Dungeon - StatHistory[StatHistory.length-1][i].Dungeon;
        CI[i].Tower = Player[i].Tower - StatHistory[StatHistory.length-1][i].Tower;
        CI[i].Wall = Player[i].Wall - StatHistory[StatHistory.length-1][i].Wall;
        if (Turn == i)
        {
            CI[i].PlayedCard = PlayedCard;
            CI[i].bDiscarded = bDiscarded;
        }
    }
    StatChanges ~= CI;
}

int ExecuteCard(CardInfo CI)
{
    return CI.PlayFunction();//CI.PlayFunction.call!int();
}

/**
 * Executes the card to get the number of the player that is supposed to move
 * next.
 */
void GetNextTurn(CardInfo CI, bool Discarded)
{
    if (Discarded)
    {
        if (!DiscardRound)
            NextTurn = GetEnemy();
        else
        {
            NextTurn = Turn;
            DiscardRound = false;
        }
    }
    else
        NextTurn = GetAbsolutePlayer(ExecuteCard(CI)); //GE: This is where we really execute the card.
    if (NextTurn == -1) //GE: If the card inits a discard turn.
    {
        DiscardRound = true;
        NextTurn = Turn;
    }
}

bool CanAffordCard(CardInfo CI, int PlayerNum)
{
    if (CI.BrickCost > Player[PlayerNum].Bricks) return false;
    if (CI.GemCost > Player[PlayerNum].Gems) return false;
    if (CI.RecruitCost > Player[PlayerNum].Recruits) return false;
    return true;
}

void TakeResources(Stats* P, int Bricks, int Gems, int Recruits)
{
    P.Bricks -= Bricks;
    P.Gems -= Gems;
    P.Recruits -= Recruits;
}

/**
 * Checks whether the card effect made us go out of bounds, and if it did,
 * makes the values stay within acceptable limits.
 */
void Normalise()
{
    foreach (ref Stats P; Player)
    {
        if (P.Quarry < 1) P.Quarry = 1;
        if (P.Magic < 1) P.Magic = 1;
        if (P.Dungeon < 1) P.Dungeon = 1;
        if (P.Quarry > 99) P.Quarry = 99;
        if (P.Magic > 99) P.Magic = 99;
        if (P.Dungeon > 99) P.Dungeon = 99;

        if (P.Bricks < 0) P.Bricks = 0;
        if (P.Gems < 0) P.Gems = 0;
        if (P.Recruits < 0) P.Recruits = 0;
        if (P.Bricks > 999) P.Bricks = 999;
        if (P.Gems > 999) P.Gems = 999;
        if (P.Recruits > 999) P.Recruits = 999;

        if (P.Tower < 0) P.Tower = 0;
        if (P.Wall < 0) P.Wall = 0;
        if (P.Tower > Config.TowerVictory) P.Tower = Config.TowerVictory;
        if (P.Wall > Config.MaxWall) P.Wall = Config.MaxWall;
    }
}

extern(C) int GetEnemy()
{
    return (Turn+1)%cast(int).Player.length;
}

int GetAbsolutePlayer(int PlayerNumber)
{
    if (PlayerNumber == 1)
        return GetEnemy();
    else if (PlayerNumber == 0)
        return Turn;
    else
        return PlayerNumber;
}
