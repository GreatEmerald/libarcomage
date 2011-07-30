/**
 * The main class of Arcomage.
 * Initialisation, configuration, input loop, card play event loop and certain
 * other important functions are here. Scheduled for elimination - code should
 * be put into config.c/graphics.c/input.c.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
//#include <SDL.h>
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
#include "common.h"
#include "config.h"
//#include "graphics.h"
//#include "input.h"
#include "network.h"
#include "minIni.h"
//#include "sound.h"
#include "cards.h"

//SDL_Event event; ///< Event placeholder.
lua_State *L; ///< Lua support, main state.

void DecoySoundPlay(enum SoundTypes SoundTypes)
{
}

int main() //GE: For compilers.
{
    return 0;
}

/**
 * Dumps the contents of the Lua stack.
 *
 * Usually used for debugging. Should never be called in the release version.
 *
 * Authors: GreatEmerald.
 */
void StackDump (lua_State *L)
{
    int a;
    int top = lua_gettop(L);
    for (a = 1; a <= top; a++)  /* repeat for each level */
    {
        int t = lua_type(L, -a);
        printf("%d: ", -a);
        switch (t) {

          case LUA_TSTRING:  /* strings */
            printf("`%s'", lua_tostring(L, -a));
            break;

          case LUA_TBOOLEAN:  /* booleans */
            printf(lua_toboolean(L, -a) ? "true" : "false");
            break;

          case LUA_TNUMBER:  /* numbers */
            printf("%g", lua_tonumber(L, -a));
            break;

          default:  /* other values */
            printf("%s", lua_typename(L, t));
            break;

        }
        printf(", ");
    }
    getchar();
    printf("\n");
}

/**
 * Error handling.
 *
 * Dumps the Lua stack, writes information into the error file and halts the
 * program so the user could see what happened.
 *
 * Authors: GreatEmerald.
 *
 * \param fmt Reason for error.
 */
void error (lua_State *L, const char *fmt, ...)
{
    StackDump(L); //GE: Dump the stack so we'd know what the hell is going on
    va_list argp;
    va_start(argp, fmt);
    vfprintf(stderr, fmt, argp);
    va_end(argp);
    lua_close(L);
    getchar();
    exit(EXIT_FAILURE);
}

/**
 * Lua initialisation.
 *
 * Authors: GreatEmerald.
 */
void InitLua()
{
    L = lua_open();
    luaL_openlibs(L);
    if (luaL_loadfile(L,"lua/CardPools.lua"))
      error(L, "Could not access card pool!");
    if (lua_pcall(L, 0, 0, 0))
        error(L, "Protected call failed!");

    lua_register(L, "Damage", L_Damage);
    lua_register(L, "RemoveBricks", L_RemoveBricks);
    lua_register(L, "RemoveGems", L_RemoveGems);
    lua_register(L, "RemoveRecruits", L_RemoveRecruits);
    lua_register(L, "RemoveWall", L_RemoveWall);
    lua_register(L, "RemoveTower", L_RemoveTower);
    lua_register(L, "RemoveQuarry", L_RemoveQuarry);
    lua_register(L, "RemoveDungeon", L_RemoveDungeon);
    lua_register(L, "RemoveMagic", L_RemoveMagic);
    lua_register(L, "AddBricks", L_AddBricks);
    lua_register(L, "AddGems", L_AddGems);
    lua_register(L, "AddRecruits", L_AddRecruits);
    lua_register(L, "AddWall", L_AddWall);
    lua_register(L, "AddTower", L_AddTower);
    lua_register(L, "AddQuarry", L_AddQuarry);
    lua_register(L, "AddMagic", L_AddMagic);
    lua_register(L, "AddDungeon", L_AddDungeon);
    lua_register(L, "SetQuarry", L_SetQuarry);
    lua_register(L, "SetWall", L_SetWall);
    lua_register(L, "SetMagic", L_SetMagic);
    lua_register(L, "GetWall", L_GetWall);
    lua_register(L, "GetQuarry", L_GetQuarry);
    lua_register(L, "GetDungeon", L_GetDungeon);
    lua_register(L, "GetMagic", L_GetMagic);
    lua_register(L, "GetTower", L_GetTower);
    lua_register(L, "GetGems", L_GetGems);
    lua_register(L, "GetBricks", L_GetBricks);
    lua_register(L, "GetRecruits", L_GetRecruits);
}

/// D initialisation.
/// Authors: GreatEmerald.
void InitD()
{
  rt_init();
  D_LinuxInit();
}

/// Main initialisation.
/// Authors: GreatEmerald, STiCK.
void Init()
{
    aiplayer=-1;
    netplayer=-1;
    FrontendFunctions.Sound_Play = &DecoySoundPlay;
    
    InitLua();
    InitD();

    ReadConfig();

    //atexit(SDL_Quit); //GE: What is this for?
    //if (soundenabled) Sound_Init();
    //Graphics_Init(fullscreen);
}

/// Exit sequence.
/// Authors: GreatEmerald, STiCK.
void Quit()
{
    //Graphics_Quit();
    //Sound_Quit();
    lua_close(L); //GE: Close Lua
    rt_term(); //GE: Terminate D
}

/**
 * Artificial intelligence support.
 *
 * Bugs: Picks random cards, should be transferred to Lua.
 *
 * Authors: GreatEmerald, STiCK.
 */
void AIPlay(int *t,int *d)
{
    extern int req[3][35];
    float fuzzy[6],maxf=-10000.0;
    int max=0,i,c;
    for (i=0;i<6;i++)
    {
        c=Player[turn].Hand[i];
        if (Requisite(&Player[turn],i) && !bSpecialTurn)
            fuzzy[i]=(float) ( (req[c>>8][c&0xFF]+1) ); //GE: AI wants to play this?
        else
            fuzzy[i]=(float) ( (req[c>>8][c&0xFF]+1)-100.0 );
    }
    for (i=0;i<5;i++)
        if (fuzzy[i]>maxf)
        {
            maxf=fuzzy[i];
            max=i;
        }
    *t=max;
    *d=(maxf<0);
}

/**
 * Initialisation before the card game begins.
 *
 * Includes getting the first cards and setting up initial conditions.
 *
 * Authors: GreatEmerald, STiCK.
 */
void InitGame()
{
    int i;

    turn=0;
    if (netplayer==-1)
        InitDeck();
    for (i=0;i<6;i++)
    {
        Player[0].Hand[i]=GetCard();
        Player[1].Hand[i]=GetCard();
    }
    for (i=0;i<2;i++)//GE: Set up conditions here.
    {
        Player[i].b=BrickQuantities;Player[i].g=GemQuantities;Player[i].r=RecruitQuantities;
        Player[i].q=QuarryLevels;Player[i].m=MagicLevels;Player[i].d=DungeonLevels;
        Player[i].t=TowerLevels;Player[i].w=WallLevels;
    }
}

///Remote play.
///Authors: STiCK.
int NetRemPlay(int *t,int *d)
{
    /*char *s;
    int r;

    r=Recv(&s,0);
    *t=s[0];*d=s[1];

    return r;*/
    printf("ERROR: Network play is no longer supported! Please use an earlier version of the program or wait for a new implementation.");
    return 0;
}

/// Net Local Play.
/// Authors: STiCK.
void NetLocPlay(int t,int d,int card)
{
    /*char s[5];
    s[0]=t;s[1]=d;s[2]=turn;
    s[3]=card >> 8;
    s[4]=card & 0xFF;
    Send(s,5,0);*/
    printf("ERROR: Network play is no longer supported! Please use an earlier version of the program or wait for a new implementation.");
}

/// Network game support.
/// Authors: STiCK.
void DoNetwork()
{
    /*char *host,*str,*name,remname[17];
    int i,deck[102];

    host=DialogBox(DLGNETWORK,"Connect to server:");

    if (!host) return;

    name = DialogBox(DLGNETWORK,"Your Name");
    if (!name) return;
    name[16]=0;

    DialogBox(DLGMSG,"Connecting to '%s'...",host);
    str=ConnectToServer(host);
    if (str)
    {
        DialogBox(DLGERROR,str);
        WaitForInput();
        Network_Quit();
        return;
    }

    Recv(&str,0);
    if (strncmp(str,"ARCOMAGE v",10))
    {
        DialogBox(DLGERROR,"Unknown Arcomage version\nor\nserver is not Arcomage server!");
        WaitForInput();
        return;
    }
    if (strncmp(str,"ARCOMAGE v" ARCOVER,15))
    {
        DialogBox(DLGERROR,"Versions doesn't match!");
        WaitForInput();
    }
    DialogBox(DLGMSG,"Waiting for Game Start ...");
    Send(name,17,0);

    Recv(&str,0);
    for (i=0;i<102;i++)
        deck[i]=str[i]-1;
    SetDeck(deck);
    netplayer=!(str[102]-1);
    Recv(&str,0);
    strcpy(remname,str);

    Player[ netplayer ].Name = remname;
    Player[ !netplayer ].Name = name;

    DoGame();*/
}

/**
 * Argument parsing.
 *
 * Deprecated: Use minIni instead.
 *
 * Authors: STiCK.
 */
void ParseArgs(int argc,char *argv[])
{
    int i;
    for (i=0;i<argc;i++)
    {
        if (argv[i][0]!='-') continue;
        if (!strcmp(argv[i],"-f")||!strcmp(argv[i],"--fullscreen")) fullscreen=1;
        if (!strcmp(argv[i],"-nosound")||!strcmp(argv[i],"--disable-sound")) soundenabled=0;
    }
}
