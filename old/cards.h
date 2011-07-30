#ifndef _CARDS_H_
#define _CARDS_H_ 1
#include "lua.h"

struct Stats {
	int b,g,r,q,m,d;	// bricks,gems,recruits,quarry,magic,dungeons
	int t,w;			// tower,wall
	char *Name;			// player's name
	int Hand[6];		// player's hand
};

struct Stats Player[2]; ///< Players. Bugs: Doesn't support more than 2 players.
int aiplayer; ///< Used in AI games.
int netplayer; ///< Used in network games.
int bSpecialTurn; ///< Used for determining whether or not this is a discarding turn.
int turn; ///< Number of the player whose turn it is.
int nextturn; ///< Number of the player who will go next.
int lastturn; ///< Number of the player whose turn ended before.
                            
//GE: The longest names are with 16 characters right now. ...blasted char arrays :\
//GE: Also funny that it's an array of structs of arrays.
int GetCard();
void PutCard(int c);
//int CardFrequencies(int i);
//void InitCardDB();
void InitDeck();
void SetDeck(int *d);
int Requisite(struct Stats *s,int card);
int Turn(struct Stats *s1,struct Stats *s2,int card,int turn);
char* CardName(int card);

//GE: Functions called from Lua code.
int L_Damage (lua_State *L);

int L_AddQuarry (lua_State *L);
int L_AddMagic (lua_State *L);
int L_AddDungeon (lua_State *L);
int L_AddBricks (lua_State *L);
int L_AddGems (lua_State *L);
int L_AddRecruits (lua_State *L);
int L_AddTower (lua_State *L);
int L_AddWall (lua_State *L);

int L_RemoveQuarry (lua_State *L);
int L_RemoveMagic (lua_State *L);
int L_RemoveDungeon (lua_State *L);
int L_RemoveBricks (lua_State *L);
int L_RemoveGems (lua_State *L);
int L_RemoveRecruits (lua_State *L);
int L_RemoveTower (lua_State *L);
int L_RemoveWall (lua_State *L);

int L_GetQuarry (lua_State *L);
int L_GetMagic (lua_State *L);
int L_GetDungeon (lua_State *L);
int L_GetBricks (lua_State *L);
int L_GetGems (lua_State *L);
int L_GetRecruits (lua_State *L);
int L_GetTower (lua_State *L);
int L_GetWall (lua_State *L);

int L_SetQuarry (lua_State *L);
int L_SetMagic (lua_State *L);
int L_SetWall (lua_State *L);

//GE: Functions called in D code.
void D_LinuxInit(); //GE: Special initialisation needed to link the D lib in Linux
int rt_init(); //GE: Initialisation and termination of the D runtime.
int rt_term();

void D_setPoolName(int Pool, const char* Name);
void D_setID(int Pool, int Card, int ID); //GE: These all are responsible for maintaining the Card pools.
void D_setFrequency(int Pool, int Card, int Frequency);
void D_setName(int Pool, int Card, const char* Name);
void D_setDescription(int Pool, int Card, const char* Description);
void D_setBrickCost(int Pool, int Card, int BrickCost);
void D_setGemCost(int Pool, int Card, int GemCost);
void D_setRecruitCost(int Pool, int Card, int RecruitCost);
void D_setCursed(int Pool, int Card, int Cursed);
void D_setColour(int Pool, int Card, const char* Colour);
void D_setPictureFile(int Pool, int Card, const char* File);
void D_setPictureCoords(int Pool, int Card, int X, int Y, int W, int H);
void D_setLuaFunction(int Pool, int Card, const char* LuaFunction);

int D_getFrequency(int Pool, int Card);
int D_getBrickCost(int Pool, int Card);
int D_getGemCost(int Pool, int Card);
int D_getRecruitCost(int Pool, int Card);
int D_getCursed(int Pool, int Card);
char* D_getPictureFile(int Pool, int Card);
size_t D_getPictureFileSize(int Pool, int Card);
struct SDL_Rect D_getPictureCoords(int Pool, int Card);
int D_getPictureCoordX(int Pool, int Card);
int D_getPictureCoordY(int Pool, int Card);
int D_getPictureCoordW(int Pool, int Card);
int D_getPictureCoordH(int Pool, int Card);
char* D_getLuaFunction(int Pool, int Card);
size_t D_getLuaFunctionSize(int Pool, int Card);
void D_printCardDB();

#endif
