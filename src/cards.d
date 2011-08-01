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
int NextTurn; /// Number of the player who will go next.
int LastTurn; /// Number of the player whose turn ended before.
CardInfo[] Queue; /// Cards in the bank.
int CurrentPosition; /// The current position in the Queue.

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
