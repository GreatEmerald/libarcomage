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

extern(C):

//------------------------------------------------------------------------------
// Useful functions. These are not a wrapper, but are only used in C to make it
// easier for those writing frontends, so this is kept in wrapper.d.
//------------------------------------------------------------------------------

void SetPlayerInfo(int PlayerNum, char* Name, bool AI)
{
    Player[PlayerNum].AI = AI;
    Player[PlayerNum].Name = to!string(Name);
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
        case 14: return cast(int)Config.OneResourceVictory;
        case 15: return cast(int)Config.UseOriginalCards;
        case 16: return cast(int)Config.UseOriginalMenu;
        case 17: return 640; //FIXME - Needs to be configurable
        case 18: return 480;
        default: return 0;
    }
}

immutable(char)* GetFilePath(char* FileName)
{
    return toStringz(join([Config.DataDir, to!string(FileName)]));
}
