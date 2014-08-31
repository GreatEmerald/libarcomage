/**
 * The wrapper for interfacing with C frontends. Completely irrelevant to D
 * frontends, since it only handles the data conversion between the two
 * specifications, so do not include this if you are using libarcomage as a
 * source library for D only. You must include this if you use a C library.
 * Interfaces with C's adapter.c; see the /libarcomage/include directory.
 */

module wrapper;
import arco;
import cards;
import std.stdio:writeln;
import std.conv;
import std.string;
import std.array;
import std.c.stdlib;
import std.random;
import std.datetime;

extern(C):

void SetPlayerInfo(int PlayerNum, char* Name, bool AI)
{
    Player[PlayerNum].AI = AI;
    Player[PlayerNum].Name = to!string(Name);
}

void SetEffectNotify(void function(int, int, int) EffectNotify)
{
    FrontendFunctions.EffectNotify = EffectNotify;
}

void SetPlayCardPostAnimation(void function(int) PlayCardPostAnimation)
{
    FrontendFunctions.PlayCardPostAnimation = PlayCardPostAnimation;
}

void SetPlayCardAnimation(void function(int, char, char) PlayCardAnimation)
{
    FrontendFunctions.PlayCardAnimation = PlayCardAnimation;
}

int GetConfig(int Type)
{
    switch (Type)
    {
        case 0: return cast(int)Config.Fullscreen;
        case 1: return cast(int)Config.SoundEnabled;
        case 2: return cast(int)Config.CardTranslucency;
        case 3: return cast(int)Config.CardsInHand;
        case 4: return Config.TowerLevels;
        case 5: return Config.WallLevels;
        case 6: return Config.QuarryLevels;
        case 7: return Config.MagicLevels;
        case 8: return Config.DungeonLevels;
        case 9: return Config.BrickQuantities;
        case 10: return Config.GemQuantities;
        case 11: return Config.RecruitQuantities;
        case 12: return Config.MaxWall;
        case 13: return Config.ResourceVictory;
        case 14: return Config.TowerVictory;
        case 15: return cast(int)Config.OneResourceVictory;
        case 16: return cast(int)Config.UseOriginalCards;
        case 17: return cast(int)Config.UseOriginalMenu;
        case 18: return 800; //FIXME - Needs to be configurable
        case 19: return 600;
        default: return 0;
    }
}

immutable(char)* GetPlayerName(int Who)
{
    return toStringz(Player[Who].Name);
}

char GetIsAI(int Who)
{
    return cast(char)Player[Who].AI;
}

char GetCanPlayCard(int Who, char CardNum, char bDiscarded)
{
    return CanPlayCard(Player[Who].Hand[CardNum], cast(bool)bDiscarded);
}

char GetCanAffordCard(int Who, char CardNum)
{
    return CanAffordCard(Player[Who].Hand[CardNum], Who);
}

//GE: Get a colour number from the number of the card in hand.
int GetColourType(int Pool, int Card)
{
	switch (CardDB[Pool][Card].Colour)
	{
		case "Red": return 0; //GE: Make sure adapter is in sync!
		case "Blue": return 1;
		case "Green": return 2;
		case "White": case "Brown": return 3;
		default: return 4;
	}
}

void GetCardDBSize(int* NumPools, int** NumCards)
{
    int x;

    *NumPools = cast(int)CardDB.length;
    *NumCards = cast(int*) malloc((*NumPools) * int.sizeof);
    for (x=0; x<*NumPools; x++)
        *NumCards[x] = cast(int)CardDB[x].length;
}

//GEm: It's best to use handles in code - should save both memory and processor time!
void GetCardHandle(byte PlayerNum, byte PositionInHand, int* Pool, int* Card)
{
    foreach (int a, CardInfo[] Cards; CardDB)
    {
        foreach (int b, CardInfo CI; Cards)
        {
            if (CI == Player[PlayerNum].Hand[PositionInHand]) //GEm: Thank goodness D allows this!
            {
                *Pool = a;
                *Card = b;
                return;
            }
        }
    }
}

immutable(char)***** GetCardDescriptionWords(int* NumPools, int** NumSentences, int*** NumLines, int**** NumWords)
{
    string[] SplitLines, SplitWords;
    immutable(char)***** Result;

    *NumPools = cast(int)CardDB.length;
    *NumSentences = cast(int*) malloc((*NumPools) * int.sizeof);
    *NumLines = cast(int**) malloc((*NumPools) * (int*).sizeof);
    *NumWords = cast(int***) malloc((*NumPools) * (int**).sizeof);
    Result = cast(immutable(char)*****) malloc((*NumPools) * (immutable(char)****).sizeof);
    foreach (int Pools, CardInfo[] Cards; CardDB)
    {
        (*NumSentences)[Pools] = cast(int)CardDB[Pools].length;
        (*NumLines)[Pools] = cast(int*) malloc((*NumSentences)[Pools] * int.sizeof);
        (*NumWords)[Pools] = cast(int**) malloc((*NumSentences)[Pools] * (int*).sizeof);
        Result[Pools] = cast(immutable(char)****) malloc((*NumSentences)[Pools] * (immutable(char)***).sizeof);
        foreach (int Sentences, CardInfo CurrentCard; Cards)
        {
            SplitLines = split(CurrentCard.Description, "\n");
            (*NumLines)[Pools][Sentences] = cast(int)SplitLines.length;
            (*NumWords)[Pools][Sentences] = cast(int*) malloc((*NumLines)[Pools][Sentences] * int.sizeof);
            Result[Pools][Sentences] = cast(immutable(char)***) malloc((*NumLines)[Pools][Sentences] * (immutable(char)**).sizeof);
            foreach (int Lines, string Line; SplitLines)
            {
                SplitWords = split(Line);
                (*NumWords)[Pools][Sentences][Lines] = cast(int)(SplitWords.length);
                Result[Pools][Sentences][Lines] = cast(immutable(char)**) malloc((*NumWords)[Pools][Sentences][Lines] * (immutable(char)*).sizeof);
                foreach (int Words, string Word; SplitWords)
                    Result[Pools][Sentences][Lines][Words] = toStringz(Word);
            }
        }
    }
    return Result;
}

immutable(char)*** GetCardTitleWords()
{
    immutable(char)*** Result;

    Result = cast(immutable(char)***) malloc(cast(int)CardDB.length * (immutable(char)**).sizeof);
    foreach (int Pools, CardInfo[] Cards; CardDB)
    {
        Result[Pools] = cast(immutable(char)**) malloc(cast(int)Cards.length * (immutable(char)*).sizeof);
        foreach (int CardNum, CardInfo Card; Cards)
            Result[Pools][CardNum] = toStringz(CardDB[Pools][CardNum].Name);
    }
    return Result;
}

void GetCardPrice(int Pool, int Card, int* Bricks, int* Gems, int* Recruits)
{
    *Bricks = CardDB[Pool][Card].BrickCost;
    *Gems = CardDB[Pool][Card].GemCost;
    *Recruits = CardDB[Pool][Card].RecruitCost;
}

immutable(char)*** GetCardPicturePaths()
{
    immutable(char)*** Result;

    Result = cast(immutable(char)***) malloc(cast(int)CardDB.length * (immutable(char)**).sizeof);
    foreach (int Pools, CardInfo[] Cards; CardDB)
    {
        Result[Pools] = cast(immutable(char)**) malloc(cast(int)Cards.length * (immutable(char)*).sizeof);
        foreach (int CardNum, CardInfo Card; Cards)
            Result[Pools][CardNum] = toStringz(join(["lua/", PoolNames[Pools], "/", CardDB[Pools][CardNum].Picture.File]));
    }
    return Result;
}

SDLRect** GetCardPictureCoords()
{
    SDLRect** Result;

    Result = cast(SDLRect**) malloc(cast(int)CardDB.length * (SDLRect*).sizeof);
    foreach (int Pools, CardInfo[] Cards; CardDB)
    {
        Result[Pools] = cast(SDLRect*) malloc(cast(int)Cards.length * SDLRect.sizeof);
        foreach (int CardNum, CardInfo Card; Cards)
            Result[Pools][CardNum] = CardDB[Pools][CardNum].Picture.Coordinates;
    }
    return Result;
}

int GetResource(int PlayerNum, int Type)
{
    switch (Type)
    {
        case 0: return Player[PlayerNum].Quarry;
        case 1: return Player[PlayerNum].Magic;
        case 2: return Player[PlayerNum].Dungeon;
        case 3: return Player[PlayerNum].Bricks;
        case 4: return Player[PlayerNum].Gems;
        case 5: return Player[PlayerNum].Recruits;
        case 6: return Player[PlayerNum].Tower;
        case 7: return Player[PlayerNum].Wall;
        default: writeln("Warning: GetResource: Invalid type specified!"); return 0;
    }
}

char ExecutePlayCard(int CardPlace, char bDiscarded)
{
    return cast(char)PlayCard(CardPlace, cast(bool)bDiscarded);
}

//------------------------------------------------------------------------------
// Useful functions. These are not a wrapper, but are only used in C to make it
// easier for those writing frontends, so this is kept in wrapper.d.
//------------------------------------------------------------------------------

immutable(char)* GetFilePath(char* FileName)
{
    return toStringz(join([Config.DataDir, to!string(FileName)]));
}

float FRand()
{
    return uniform(0.0, 1.0);
}

long GetCurrentTimeD()
{
    auto Result = Clock.currTime;
    return Result.stdTime;
}
