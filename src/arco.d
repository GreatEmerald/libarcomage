/**
 * The main module of libarcomage.
 * Initialisation, configuration, contact with frontends and other important
 * functions are here. Most code is in arcomage.cards though.
 * 
 * Authors: GreatEmerald
 */

module arcomage.arco;
import std.stdio; //GE: Debugging purposes so far.
import std.conv;
import std.string;
import luad.all;
import luad.c.all;

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
    //int X;
    //int Y;
    //int H;
    //int W;
}

struct CardInfo { //GE: Holds information about a single card.
    //int ID; //GE: Obsolete, use n from CardDB[i][n] instead
    int Frequency; //GE: This is the number of cards of this type in the deck. 1=Rare, 2=Uncommon, 3=Common
    string Name;
    string Description;
    int BrickCost; //GE: These three are for rendering purposes, but are used in code as well
    int GemCost;
    int RecruitCost;
    bool Cursed;
    string Colour; //GE: Red, Geen, Blue, Gray/Grey/Black, Brown/White. Rendering purposes, mostly for 0 cost coloured cards
    PictureInfo Picture; //GE: Rendering purposes.
    string Keywords; //GE: Might become an array. These are MArcomage keywords, also used in Lua functions
    LuaFunction PlayFunction; //GE: This is what we call on playing the card.
    LuaFunction AIFunction; /// The function that rates the desirability of the card.
    
    /**
     * Creates a function in Lua that adds a card to the card array. The Lua
     * code only contains calls to this function.
     * 
     * Authors: GreatEmerald, JakobOvrum
     */ 
    static CardInfo[] fromFile(string path)
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

struct ConfigOptions {
    bool Fullscreen;
    bool SoundEnabled;
    byte CardTranslucency;
    int TowerLevels;
    int WallLevels;
    int QuarryLevels;
    int MagicLevels;
    int DungeonLevels;
    int BrickQuantities;
    int GemQuantities;
    int RecruitQuantities;
    int TowerVictory;
    int ResourceVictory;
    bool OneResourceVictory;
} Config;

lua_State * L; /// Workaround for SIGSEGV on exit.
LuaState lua; /// The main Lua state.

version(linux) //GE: Linux needs an entry point.
{
    int main()
    {
        return 0;
    }
}

/**
 * Lua initialisation. Normally, LuaD handles everything for us - this is just
 * additional content specific to our libary.
 * 
 * Authors: GreatEmerald
 */ 
void initLua()
{
    L = luaL_newstate();
    lua = new LuaState(L);
    lua.openLibs();
    
    lua.doFile("lua/Configuration.lua"); //GE: This sets global variables inside Lua. We need to fish them out now.
    Config.Fullscreen = lua.get!bool("Fullscreen"); //GE: Configuration support.
    Config.SoundEnabled = lua.get!bool("SoundEnabled");
    Config.CardTranslucency = lua.get!byte("CardTranslucency");
    Config.TowerLevels = lua.get!int("TowerLevels");
    Config.WallLevels = lua.get!int("WallLevels");
    Config.QuarryLevels = lua.get!int("QuarryLevels");
    Config.MagicLevels = lua.get!int("MagicLevels");
    Config.DungeonLevels = lua.get!int("DungeonLevels");
    Config.BrickQuantities = lua.get!int("BrickQuantities");
    Config.GemQuantities = lua.get!int("GemQuantities");
    Config.RecruitQuantities = lua.get!int("RecruitQuantities");
    Config.TowerVictory = lua.get!int("TowerVictory");
    Config.ResourceVictory = lua.get!int("ResourceVictory");
    Config.OneResourceVictory = lua.get!bool("OneResourceVictory");
    
    lua["Damage"] = (int Who, int Amount); //GE: Register D functions in Lua.
    lua["AddQuarry"] = (int Who, int Amount); //GE: TODO - implement the actual functions
    lua["AddMagic"] = (int Who, int Amount);
    lua["AddDungeon"] = (int Who, int Amount);
    lua["AddBricks"] = (int Who, int Amount);
    lua["AddGems"] = (int Who, int Amount);
    lua["AddRecruits"] = (int Who, int Amount);
    lua["AddTower"] = (int Who, int Amount);
    lua["AddWall"] = (int Who, int Amount);
    lua["RemoveQuarry"] = (int Who, int Amount);
    lua["RemoveMagic"] = (int Who, int Amount);
    lua["RemoveDungeon"] = (int Who, int Amount);
    lua["RemoveBricks"] = (int Who, int Amount);
    lua["RemoveGems"] = (int Who, int Amount);
    lua["RemoveRecruits"] = (int Who, int Amount);
    lua["RemoveTower"] = (int Who, int Amount);
    lua["RemoveWall"] = (int Who, int Amount);
    lua["GetQuarry"] = int (int Who) { return 0; }
    lua["GetMagic"] = int (int Who) { return 0; }
    lua["GetDungeon"] = int (int Who) { return 0; }
    lua["GetBricks"] = int (int Who) { return 0; }
    lua["GetGems"] = int (int Who) { return 0; }
    lua["GetRecruits"] = int (int Who) { return 0; }
    lua["GetTower"] = int (int Who) { return 0; }
    lua["GetWall"] = int (int Who) { return 0; }
    lua["SetQuarry"] = (int Who, int Amount);
    lua["SetMagic"] = (int Who, int Amount);
    lua["SetWall"] = (int Who, int Amount);
    
    lua.doFile("lua/CardPools.lua"); //GE: Execute the CardPools file. Here we get to know what pools there are on the system.
    lua.doString("PoolSize = #PoolInfo"); //GE: Get the amount of pools installed.
    auto TableSize = lua.get!int("PoolSize");
    PoolNames.length = TableSize; //GE: Make sure we're not out of bounds.
    CardDB.length = TableSize;
    auto Table = lua.get!LuaTable("PoolInfo"); //GE: Get a table.
    LuaTable Cell;
    string Name, Path;
    for (int i=1; i<=TableSize; i++)
    {
        Cell = Table.get!LuaTable(i);
        PoolNames[i-1] = Cell.get!string("Name"); //GE: Put pool names into PoolNames[].
        CardDB[i-1] = CardInfo.fromFile(Cell.get!string("Path")); //GE: Populate the CardDB.
    }
}

//GE: Make sure the array we have is big enough to use.
void setBounds(int Pool, int Card)
{
    if (Pool >= CardDB.length)
        CardDB.length = Pool+1;
    if (Card >= CardDB[Pool].length)
        CardDB[Pool].length = Card+1;
}

//GE: Declare initialisation and termination of the D runtime.
extern (C) bool  rt_init( void delegate( Exception ) dg = null );
extern (C) bool  rt_term( void delegate( Exception ) dg = null );

/*
 * GE: C code sends us the information it's gathering from Lua. We are here to
 * build a CardDB. C is aware of the pool it's accessing and of which card it's
 * looking at, so it sends us the information.
 * Might need to make a struct which would hold the name of the pool.   
 */

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
        initLua();
    }

    void D_LinuxInit() //GE: Special Linux initialisation.
    {
        version(linux)
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

    immutable(char)* D_getLuaFunction(int Pool, int Card)
    {
        return toStringz(CardDB[Pool][Card].LuaFunction);
    }

    size_t D_getLuaFunctionSize(int Pool, int Card)
    {
        //writeln("Getting ur pic size for Pool ", Pool, " Card ", Card);
        return CardDB[Pool][Card].LuaFunction.length+1;
    }

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
