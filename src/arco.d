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
struct SDLRect {
	short x, y;
	ushort w, h;
};

struct Rect {
	int x, y, w, h;
};

struct PictureInfo {
    string File;
    SDLRect Coordinates;
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
//string[] PrecachePictures;
//int[] Queue; //GE: This is the list of card IDs in the bank.

struct S_Config {
    bool Fullscreen;
    int ResolutionX;
    int ResolutionY;
    bool SoundEnabled;
    byte CardTranslucency;
    byte CardsInHand;
    bool HiddenCards;
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
    string DataDir;
}
S_Config Config;

enum EffectType
{
    DamageWall,
    QuarryUp,
    BricksUp,
    TowerUp,
    WallUp,
    QuarryDown,
    BricksDown,
    CardShuffle,
    DamageTower,
    MagicUp,
    MagicDown,
    GemsUp,
    GemsDown,
    DungeonUp,
    DungeonDown,
    RecruitsUp,
    RecruitsDown
}

struct S_FrontendFunctions {
    extern (C) void function(int, int, int) EffectNotify;
    extern (C) void function(int) PlayCardPostAnimation;
    extern (C) void function(int, char, char) PlayCardAnimation;
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
    lua.setPanicHandler(&LuaProtectionFault);
    lua.openLibs();

    if (!exists("lua/Configuration.lua"))
    {
        writeln("The configuration file is missing! It must be relatively in lua/Configuration.lua.");
        return;
    }
    lua.doFile("lua/Configuration.lua"); //GE: This sets global variables inside Lua. We need to fish them out now.
    Config.Fullscreen = lua.get!bool("Fullscreen"); //GE: Configuration support.
    Config.ResolutionX = lua.get!int("ResolutionX");
    Config.ResolutionY = lua.get!int("ResolutionY");
    Config.SoundEnabled = lua.get!bool("SoundEnabled");
    Config.CardTranslucency = lua.get!byte("CardTranslucency");
    Config.CardsInHand = lua.get!byte("CardsInHand");
    Config.HiddenCards = lua.get!bool("HiddenCards");
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
    Config.DataDir = lua.get!string("DataDir");
    if (Config.DataDir == "")
        Config.DataDir = "../data/";

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

static void LuaProtectionFault(LuaState lua, in char[] error)
{
    throw new Exception(error.idup); // GEm: If things go badly, throw a stringified exception
}


void BackendReset()
{
    StatChanges = StatChanges.init;
    StatHistory = StatHistory.init;
    Queue = Queue.init;
    InitComplete = false;
    Player = Player.init;
    CardDB = CardDB.init;
    PoolNames = PoolNames.init;
    Turn = NextTurn = LastTurn = CurrentPosition = 0;
    initLua();
}

//GE: Declare initialisation and termination of the D runtime.
extern (C) bool  rt_init( void delegate( Exception ) dg = null );
extern (C) bool  rt_term( void delegate( Exception ) dg = null );

version (linux) version (clibrary) void main(){} //GE: Workaround for a bug in Phobos.

extern(C):

    /**
     * Dummy functions for initialising the frontend function struct.
     */
    void DummyEffectNotify(int Who, int Type, int Power)
    {
    }

    void DummyPlayCardPostAnimation(int CardPlace)
    {
    }

    void DummyPlayCardAnimation(int CardPlace, char bDiscarded, char bSameTurn)
    {
    }

    /**
     * The main initialisation function. This needs to be called from the
     * frontend to initialise the game.
     *
     * Note: Do not forget to call rt_init() if interfacing from C.
     *
     * Authors: GreatEmerald
     */
    void InitArcomage()
    {
        D_LinuxInit();
        FrontendFunctions.EffectNotify = &DummyEffectNotify; //GE: Init all the frontend functions to empty ones. Frontends may overwrite later.
        FrontendFunctions.PlayCardPostAnimation = &DummyPlayCardPostAnimation;
        FrontendFunctions.PlayCardAnimation = &DummyPlayCardAnimation;
        initLua();
    }

    void D_LinuxInit() //GE: Special Linux initialisation.
    {
        version (linux) version (clibrary) //GE: Only enabled on Linux and when using the -version=clibrary compiler option, because it's a workaround that shouldn't normally be here.
            main();
    }
