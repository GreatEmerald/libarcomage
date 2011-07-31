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

auto L = luaL_newstate(); /// Workaround for SIGSEGV on exit.
auto lua = new LuaState(L); /// The main Lua state.

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
    lua.openLibs();
    lua.doFile("lua/Configuration.lua"); //GE: This sets global variables inside Lua. We need to fish them out now.
    Config.Fullscreen = lua.get!bool("Fullscreen");
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
    lua.doFile("lua/CardPools.lua"); //GE: Execute the CardPools file. Here we get to know what pools there are on the system.
    auto Pools = lua.get!string[string][int]("PoolInfo");
    /*foreach (int i, string[string] s; Pools)
    {
        foreach (string index, string value; s)
        {
            
        }
    }*/
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
    
    void D_setPoolName(int Pool, const char* Name)
    {
        if (Pool >= PoolNames.length) //GE: Make sure we're not out of bounds.
            PoolNames.length = Pool+1;
        PoolNames[Pool] = to!string(Name);
    }
    
    void D_setID(int Pool, int Card, int ID)
    {
        setBounds(Pool, Card);
        CardDB[Pool][Card].ID = ID;
        //writeln("CardDB.Length is ", CardDB.length, " and that pool has ", CardDB[Pool].length, " cards registered so far.");
    }

    void D_setFrequency(int Pool, int Card, int Frequency)
    {
        setBounds(Pool, Card);
        CardDB[Pool][Card].Frequency = Frequency;
        //writeln("CardDB.Length is ", CardDB.length, " and that pool has ", CardDB[Pool].length, " cards registered so far.");
    }

    void D_setName(int Pool, int Card, const char* Name)
    {
        setBounds(Pool, Card);
        CardDB[Pool][Card].Name = to!string(Name);
        //writeln("Named card: ", CardDB[Pool][Card].Name);
        //writeln("CardDB.Length is ", CardDB.length, " and that pool has ", CardDB[Pool].length, " cards registered so far.");
    }

    void D_setDescription(int Pool, int Card, const char* Description)
    {
        setBounds(Pool, Card);
        CardDB[Pool][Card].Description = to!string(Description);
        //writeln("CardDB.Length is ", CardDB.length, " and that pool has ", CardDB[Pool].length, " cards registered so far.");
    }

    void D_setBrickCost(int Pool, int Card, int BrickCost)
    {
        setBounds(Pool, Card);
        CardDB[Pool][Card].BrickCost = BrickCost;
        //writeln("CardDB.Length is ", CardDB.length, " and that pool has ", CardDB[Pool].length, " cards registered so far.");
    }

    void D_setGemCost(int Pool, int Card, int GemCost)
    {
        setBounds(Pool, Card);
        CardDB[Pool][Card].GemCost = GemCost;
        //writeln("CardDB.Length is ", CardDB.length, " and that pool has ", CardDB[Pool].length, " cards registered so far.");
    }

    void D_setRecruitCost(int Pool, int Card, int RecruitCost)
    {
        setBounds(Pool, Card);
        CardDB[Pool][Card].RecruitCost = RecruitCost;
        //writeln("CardDB.Length is ", CardDB.length, " and that pool has ", CardDB[Pool].length, " cards registered so far.");
    }

    void D_setCursed(int Pool, int Card, int Cursed)
    {
        setBounds(Pool, Card);
        CardDB[Pool][Card].Cursed = cast(bool)Cursed;
	//writeln("Cursed: ", cast(bool)Cursed);
        //writeln("CardDB.Length is ", CardDB.length, " and that pool has ", CardDB[Pool].length, " cards registered so far.");
    }

    void D_setColour(int Pool, int Card, const char* Colour)
    {
        setBounds(Pool, Card);
        CardDB[Pool][Card].Colour = to!string(Colour);
        //writeln("CardDB.Length is ", CardDB.length, " and that pool has ", CardDB[Pool].length, " cards registered so far.");
    }

    void D_setPictureFile(int Pool, int Card, const char* File)
    {
        setBounds(Pool, Card);
        CardDB[Pool][Card].Picture.File = to!string(File);
    }

    void D_setPictureCoords(int Pool, int Card, int X, int Y, int W, int H)
    {
        setBounds(Pool, Card);
        CardDB[Pool][Card].Picture.Coordinates.x = to!short(X);
        CardDB[Pool][Card].Picture.Coordinates.y = to!short(Y);
        CardDB[Pool][Card].Picture.Coordinates.w = to!ushort(W);
        CardDB[Pool][Card].Picture.Coordinates.h = to!ushort(H);
    }

    void D_setLuaFunction(int Pool, int Card, const char* LuaFunction)
    {
	setBounds(Pool, Card);
        CardDB[Pool][Card].LuaFunction = to!string(LuaFunction);
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
