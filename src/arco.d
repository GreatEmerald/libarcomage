/**
 * The main module of libarcomage.
 * Initialisation, configuration, contact with frontends and other important
 * functions are here. Most code is in arcomage.cards though.
 * 
 * Authors: GreatEmerald
 */

module arco;
import std.stdio; //GE: Debugging purposes so far.
import std.conv;
import std.string;
import std.file;
import luad.all;
import cards;

/*struct Coords {
    int X, Y, W, H;
} */
struct SDL_Rect {
	short x, y;
	ushort w, h;
};

struct Rect {
	int x, y, w, h;
};

struct PictureInfo {
    string File;
    SDL_Rect Coordinates;
    /*int X;
    int Y;
    int H;
    int W;*/
}

struct CardInfo { //GE: Holds information about a single card.
    //int ID; //GE: Obsolete, use n from CardDB[i][n] instead
    string Name;
    string Description;
    int Frequency; //GE: This is the number of cards of this type in the deck. 1=Rare, 2=Uncommon, 3=Common
    int BrickCost; //GE: These three are for rendering purposes, but are used in code as well
    int GemCost;
    int RecruitCost;
    bool Cursed;
    string Colour; //GE: Red, Geen, Blue, Gray/Grey/Black, Brown/White. Rendering purposes, mostly for 0 cost coloured cards
    PictureInfo Picture; //GE: Rendering purposes.
    string Keywords; //GE: Might become an array. These are MArcomage keywords, also used in Lua functions
    /*LuaFunction*/ int delegate() PlayFunction; //GE: This is what we call on playing the card.
    /*LuaFunction*/ float delegate() AIFunction; /// The function that rates the desirability of the card.
    
    /**
     * Creates a function in Lua that adds a card to the card array. The Lua
     * code only contains calls to this function.
     * 
     * Authors: GreatEmerald, JakobOvrum
     */ 
    static CardInfo[] fromFile(in char[] path)
    {
        CardInfo[] Cards;

        lua["Card"] = (CardInfo Card)
        {
            Cards ~= Card;
        };

        lua.doFile(path);

        return Cards;
    }
};
//CardInfo[] CardPool; //GE: Holds information about all cards in a single Card Pool.
/*struct CardPoolInfo {
    CardPool Pool;
    string Name;
} */
CardInfo[][] CardDB; //GE: Holds information about all the different loaded Card Pools.
string[] PoolNames; //GE: Holds the names of each pool. Becareful to align this to CardDB.
string[] PrecachePictures;
//int[] Queue; //GE: This is the list of card IDs in the bank.

struct S_Config {
    bool Fullscreen;
    bool SoundEnabled;
    byte CardTranslucency;
    byte CardsInHand;
    int TowerLevels;
    int WallLevels;
    int QuarryLevels;
    int MagicLevels;
    int DungeonLevels;
    int BrickQuantities;
    int GemQuantities;
    int RecruitQuantities;
    int MaxWall;
    int TowerVictory;
    int ResourceVictory;
    bool OneResourceVictory;
    bool UseOriginalCards;
    bool UseOriginalMenu;
    string OriginalDataDir;
}
S_Config Config;

enum SoundTypes {
    Damage, ResB_Up, ResS_Up, Tower_Up, Wall_Up, ResB_Down, ResS_Down, Shuffle
}

struct S_FrontendFunctions {
    void function(SoundTypes) Sound_Play;
    void function() RedrawScreenFull;
    void function(const char*, int) PrecacheCard;
    void function(CardInfo, int) PlayCardAnimation;
}
S_FrontendFunctions FrontendFunctions;

LuaState lua; /// The main Lua state.

/**
 * Lua initialisation. Normally, LuaD handles everything for us - this is just
 * additional content specific to our libary.
 * 
 * Authors: GreatEmerald
 */ 
void initLua()
{
    lua = new LuaState();
    lua.openLibs();
    
    if (!exists("lua/Configuration.lua"))
    {
        writeln("The configuration file is missing! It must be relatively in lua/Configuration.lua.");
        return;
    }
    lua.doFile("lua/Configuration.lua"); //GE: This sets global variables inside Lua. We need to fish them out now.
    Config.Fullscreen = lua.get!bool("Fullscreen"); //GE: Configuration support.
    Config.SoundEnabled = lua.get!bool("SoundEnabled");
    Config.CardTranslucency = lua.get!byte("CardTranslucency");
    Config.CardsInHand = lua.get!byte("CardsInHand");
    Config.TowerLevels = lua.get!int("TowerLevels");
    Config.WallLevels = lua.get!int("WallLevels");
    Config.QuarryLevels = lua.get!int("QuarryLevels");
    Config.MagicLevels = lua.get!int("MagicLevels");
    Config.DungeonLevels = lua.get!int("DungeonLevels");
    Config.BrickQuantities = lua.get!int("BrickQuantities");
    Config.GemQuantities = lua.get!int("GemQuantities");
    Config.RecruitQuantities = lua.get!int("RecruitQuantities");
    Config.MaxWall = lua.get!int("MaxWall");
    Config.TowerVictory = lua.get!int("TowerVictory");
    Config.ResourceVictory = lua.get!int("ResourceVictory");
    Config.OneResourceVictory = lua.get!bool("OneResourceVictory");
    Config.UseOriginalMenu = lua.get!bool("UseOriginalMenu");
    Config.UseOriginalCards = lua.get!bool("UseOriginalCards");
    Config.OriginalDataDir = lua.get!string("OriginalDataDir");
    
    InitLuaFunctions();
    
    lua.doFile("lua/CardPools.lua"); //GE: Execute the CardPools file. Here we get to know what pools there are on the system.
    struct PoolInfo                  //GE: Thanks to JakobOvrum for a nice way to fill PoolNames and CardDB!
    {
        string Name;
        string Path;
    };
    auto Pools = lua.get!(PoolInfo[])("PoolInfo");
    foreach (PoolInfo Pool; Pools)
    {
        PoolNames ~= Pool.Name; //GE: Put pool names into PoolNames[].
        CardDB ~= CardInfo.fromFile(Pool.Path); //GE: Populate the CardDB.
    }
}

//GE: Make sure the array we have is big enough to use.
/*void setBounds(int Pool, int Card)
{
    if (Pool >= CardDB.length)
        CardDB.length = Pool+1;
    if (Card >= CardDB[Pool].length)
        CardDB[Pool].length = Card+1;
}*/

//GE: Declare initialisation and termination of the D runtime.
extern (C) bool  rt_init( void delegate( Exception ) dg = null );
extern (C) bool  rt_term( void delegate( Exception ) dg = null );

version (linux) version (clibrary) void main(){} //GE: Workaround for a bug in Phobos.

extern(C):

    /**
     * The main initialisation function. This needs to be called from the
     * frontend to initialise the game.
     * 
     * Note: Do not forget to call rt_init() and D_LinuxInit() as well.
     * 
     * Authors: GreatEmerald
     */
    void InitArcomage()
    {
        D_LinuxInit();
        FrontendFunctions.Sound_Play = function(SoundTypes){}; //GE: Init all the frontend functions to empty ones. Frontends may overwrite later.
        FrontendFunctions.RedrawScreenFull = function(){};
        FrontendFunctions.PrecacheCard = function(const char*, int){};
        FrontendFunctions.PlayCardAnimation = function(CardInfo CI, int Discarded){};
        initLua();
    }

    void D_LinuxInit() //GE: Special Linux initialisation.
    {
        version (linux) version (clibrary) //GE: Only enabled on Linux and when using the -version=clibrary compiler option, because it's a workaround that shouldn't normally be here.
            main();
    }
    
    // GE: GET CODE BEGIN ---------------------------------------

    int D_getFrequency(int Pool, int Card)
    {
        return CardDB[Pool][Card].Frequency;
    }

    int D_getBrickCost(int Pool, int Card)
    {
        return CardDB[Pool][Card].BrickCost;
    }

    int D_getGemCost(int Pool, int Card)
    {
        return CardDB[Pool][Card].GemCost;
    }

    int D_getRecruitCost(int Pool, int Card)
    {
        return CardDB[Pool][Card].RecruitCost;
    }

    int D_getCursed(int Pool, int Card) //GE: No, I'm not telling you to get cursed!
    {
        //writeln("Cursed: ", cast(int)CardDB[Pool][Card].Cursed);
	return cast(int)CardDB[Pool][Card].Cursed;
    }

    immutable(char)* D_getPictureFile(int Pool, int Card)
    {
        return toStringz(CardDB[Pool][Card].Picture.File);
    }

    size_t D_getPictureFileSize(int Pool, int Card)
    {
        //writeln("Getting ur pic size for Pool ", Pool, " Card ", Card);
        return CardDB[Pool][Card].Picture.File.length+1;
    }

    SDL_Rect D_getPictureCoords(int Pool, int Card)
    {
        //writeln("Getting ur pic coords for Pool ", Pool, " Card ", Card);
        //writeln("We have CardDB.pool? ", CardDB[Pool].length);
        //writeln("We have Picture? ", CardDB[Pool][Card].Picture.sizeof);
        //writeln("We have Coordinates? ", CardDB[Pool][Card].Picture.Coordinates.sizeof);
        //writeln("Picture: ", CardDB[Pool][Card].Picture);
        //writeln("One coordinate is: ", CardDB[Pool][Card].Picture.Coordinates.x);
        //writeln("Returning ", CardDB[Pool][Card].Picture.Coordinates.x, ":", CardDB[Pool][Card].Picture.Coordinates.y, "; ", CardDB[Pool][Card].Picture.Coordinates.w, ":", CardDB[Pool][Card].Picture.Coordinates.h);
        return CardDB[Pool][Card].Picture.Coordinates;
    }

    int D_getPictureCoordX(int Pool, int Card)
    {
	writeln("Warning: using a workaround for sharing coordinates for Pool ", Pool, " Card ", Card);
	//writeln("On this D platform, int size is ", int.sizeof);
	//writeln("On this D platform, short size is ", short.sizeof);
	return cast(int).CardDB[Pool][Card].Picture.Coordinates.x;
    }

    int D_getPictureCoordY(int Pool, int Card)
    {
	writeln("Warning: using a workaround for sharing coordinates for Pool ", Pool, " Card ", Card);
	return cast(int).CardDB[Pool][Card].Picture.Coordinates.y;
    }

    int D_getPictureCoordW(int Pool, int Card)
    {
	writeln("Warning: using a workaround for sharing coordinates for Pool ", Pool, " Card ", Card);
	return cast(int).CardDB[Pool][Card].Picture.Coordinates.w;
    }

    int D_getPictureCoordH(int Pool, int Card)
    {
	writeln("Warning: using a workaround for sharing coordinates for Pool ", Pool, " Card ", Card);
	return cast(int).CardDB[Pool][Card].Picture.Coordinates.h;
    }

    /*immutable(char)* D_getLuaFunction(int Pool, int Card)
    {
        return toStringz(CardDB[Pool][Card].PlayFunction);
    }

    size_t D_getLuaFunctionSize(int Pool, int Card)
    {
        //writeln("Getting ur pic size for Pool ", Pool, " Card ", Card);
        return CardDB[Pool][Card].PlayFunction.length+1;
    }*/

    /*void D_getPrecachePictures()
    {
        bool bAlreadyListed;
        
        for (int Pool=0; Pool < CardDB.length; Pool++)
        {
            for (int Card=0; Card < CardDB[Pool].length; Card++)
            {
                //GE: See if we have it listed already and filter out empty entries (it shouldn't happen!).
                for (int i=0; i < PrecachePictures.length; i++)
                {
                    if (PrecachePictures[i] == CardDB[Pool][Card].Picture.File || CardDB[Pool][Card].Picture.File == "")
                        bAlreadyListed = True;
                }
                if (!bAlreadyListed)
                {
                    PrecachePictures.length += 1;
                    PrecachePictures[PrecachePictures.length] = CardDB[Pool][Card].Picture.File;
                }
                bAlreadyListed = False;
            }
        }
    } */

    void D_printCardDB()
    {
	  writeln("Warning: Debugging is activated.");
      /*for (int Pool=0; Pool < CardDB.length; Pool++)
        {
            for (int Card=0; Card < CardDB[Pool].length; Card++)
            {
                writeln("CardDB[", Pool, "][", Card, "] = ", CardDB[Pool][Card]);
            }
        }*/
    }
