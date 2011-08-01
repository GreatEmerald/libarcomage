/**
 * Module that handles all the inner mechanics of libarcomage.
 */  

module arcomage.cards;
import std.stdio;
import arcomage.arco;

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
    int i, i2=0, i3=0;

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
		t=Q[a]; Q[a]=Q[b]; Q[b]=t;
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
