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

extern(C):

void SetPlayerInfo(int PlayerNum, char* Name, bool AI)
{
    Player[PlayerNum].AI = AI;
    Player[PlayerNum].Name = to!string(Name);
}

void SetSoundPlay(void function(int) SoundPlay)
{
    FrontendFunctions.SoundPlay = SoundPlay;
}

void SetRedrawScreen(void function() RedrawScreen)
{
    FrontendFunctions.RedrawScreen = RedrawScreen;
}

void SetPlayCardAnimation(void function(CardInfo, int) PlayCardAnimation)
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

//GE: Get a colour number from the number of the card in hand.
int GetColourType(byte PlayerNum, byte CardNum)
{
	switch (Player[PlayerNum].Hand[CardNum].Colour)
	{
		case "Red": return 0; //GE: Make sure adapter is in sync!
		case "Blue": return 1;
		case "Green": return 2;
		case "White": case "Brown": return 3;
		default: return 4;
	}
}

//------------------------------------------------------------------------------
// Useful functions. These are not a wrapper, but are only used in C to make it
// easier for those writing frontends, so this is kept in wrapper.d.
//------------------------------------------------------------------------------

immutable(char)* GetFilePath(char* FileName)
{
    return toStringz(join([Config.DataDir, to!string(FileName)]));
}

immutable(char)*** GetCardDescriptionWords(int* NumSentences, int** NumWords)
{
    string[][] Words;
    int WordsLength, a;
    string ReadableDescription;
    immutable(char)*** Result;
    
    
    for (a=0; a<CardDB.length; a++)
        WordsLength += CardDB[a].length;
    Words.length = WordsLength;
    a=0;
    
    foreach (CardInfo[] Cards; CardDB)
    {
        foreach (CardInfo CurrentCard; Cards)
        {
            ReadableDescription = replace(CurrentCard.Description, "-\n", "");
            ReadableDescription = replace(ReadableDescription, "\n", " ");
            Words[a] = split(ReadableDescription);
            a++;
        }
    }
    
    
    *NumSentences = cast(int)(Words.length);
    Result = cast(immutable(char)***) malloc(Words.length * (immutable(char)***).sizeof);
    *NumWords = cast(int*) malloc((*NumSentences) * int.sizeof);
    foreach (int b, string[] Sentence; Words)
    {
        (*NumWords)[b] = cast(int)(Sentence.length);
        Result[b] = cast(immutable(char)**) malloc(Sentence.length * (immutable(char)**).sizeof);
        foreach (int c, string Word; Sentence)
            Result[b][c] = toStringz(Word);
    }
    return Result;
}
