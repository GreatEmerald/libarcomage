#include <stdlib.h>
#include <stdio.h>
#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>
#include "cards.h"
#include "config.h"
#include "common.h"
//#include "sound.h"

int req[3][35] = {
	{0,0,0,1,3,4,7,2,5,2,3,2,3,7,8,0,5,4,6,0,8,9,9,11,13,15,16,18,24,7,1,6,10,14,17},
	{0,1,2,2,3,2,5,4,6,2,3,4,3,7,7,6,9,8,7,10,5,13,4,12,14,16,15,17,21,8,0,0,5,11,18},
	{0,0,1,1,3,2,3,4,6,3,5,6,7,8,0,5,6,6,5,8,9,11,9,10,14,11,12,15,17,25,2,2,4,13,18}
};

#define CARDS 102
//struct CardInfo CardDB[CARDS]; //GE: Scheduled deprecation. Use D functions to access this instead!
//int TidyQ[CARDS];
int *Q;//GE: Queue?
int Qs=0,Qe=0;
int DeckTotal; //GE: The total card number in the deck.
int bInitComplete=0;
int bSpecialTurn=0; ///< Used for determining whether or not this is a discarding turn.
int turn=0; ///< Number of the player whose turn it is.
int nextturn=0; ///< Number of the player who will go next.
int lastturn=0; ///< Number of the player whose turn ended before.

int bUseOriginalCards; //GE: From graphics.h

lua_State *L;
struct Stats Player[2];
int turn; //GE: This is an absolute value. Player[turn] is always the current player.
          //Note that Lua returns relative values (0 is current, 1 is next), so use GetAbsolutePlayer() to match those.
void ShuffleQ();

int GetCard()//GE: Returns next card in the Q array.
{
	int i;
	i=Q[Qs];
	if (Qs+1 < DeckTotal)
	   Qs++;
	else
	{
      ShuffleQ();
      Qs=0;
  }
	return i;
}

void PutCard(int c)
{
	Qe=(Qe+1)%DeckTotal;
	Q[Qe]=c;
}

void InitCardDB()
{
    int i, card, pool;
    int X,Y,W,H;
    const char* InitFunction;
    
    
    //GE: NEW - use Lua
    
    //GE: Copyright settings. Send bUseOriginalCards to Lua.
    lua_pushboolean(L, bUseOriginalCards);
    lua_setglobal(L, "bUseOriginalCards");
    
    lua_getglobal(L, "PoolInfo"); //GE: We get the whole PoolInfo here.
    if (!lua_istable(L, -1))
        error(L, "This is not a table. =GPF72=");
    
    //GE: Get the name of the pools and the functions for them.
    for (pool = 0; pool < lua_objlen(L, -1); pool++)
    {
        lua_pushnumber(L, pool+1);
        lua_gettable(L, -2); //GE: Here we have PoolInfo cell on the stack.
        if (!lua_istable(L, -1))
            error(L, "This is not a table. =GPF80=");
            
            lua_getfield(L, -1, "Name"); //GE: Get PoolInfo.cell.Name on the stack.
            if (!lua_isstring(L, -1))
            error(L, "This is not a string. =GPF84=");
                D_setPoolName(pool, lua_tostring(L, -1)); //GE: Send the name to D.
            lua_pop(L, 1);//GE: Get rid of the name.
            lua_getfield(L, -1, "InitFunction"); //GE: Get InitFunction.
            if (!lua_isstring(L, -1))
            error(L, "This is not a string. =GPF89=");
                InitFunction = lua_tostring(L, -1); //GE: Set it as a variable.
        
        lua_getglobal(L, InitFunction); //GE: Ask Lua to put the ArcomageInit function into the stack.
        //GE: Added a function. STACK: -1: function
        if (!lua_isfunction(L, -1)) //GE: Sanity check
            error(L, "This is not a function.");
        lua_pcall(L, 0, 1, 0); //GE: Call ArcomageInit(). Expect to get two return values, passing no parameters.
        //GE: Got results. STACK: -1: table
        if (!lua_istable(L, -1)) //GE: Sanity check
                error(L, "This is not a table.");

        for (card = 0; card < lua_objlen(L, -1); card++)
        {
            lua_pushnumber(L, card+1); //GE: Read the first element from the CardDB table.
            //GE: Added a number. STACK: -1: number, -2: table
            lua_gettable(L, -2); //GE: Put CardDB[1] onto the stack. It's CardInfo{}. Note that lua_gettable means "get from table", not "get a table" - the fact that we got a table is coincidence.
            //GE: Replaced the key with a table. STACK: -1: table, -2: table

            if (!lua_istable(L, -1)) //GE: Sanity check
                error(L, "This is not a table.");
            lua_getfield(L, -1, "ID"); //GE: Put CardInfo.ID onto the stack. It's a number.
            //GE: Received an element. STACK: -1: number, -2: table, -3: table
            if (!lua_isnumber(L, -1)) //GE: Sanity check
                error(L, "This is not a number.");
            D_setID(0,card,(int)lua_tonumber(L, -1));
            //CardDB[card].ID = (int)lua_tonumber(L, -1); //GE: Assign the number.
            //printf("Snagged ID: %d", CardDB[0].ID);
            lua_pop(L, 1); //GE: Removed one element from the stack, counting from the top.
            //GE: Removed an element. STACK: -1: table, -2: table
            //StackDump(L);

            if (!lua_istable(L, -1)) //GE: Sanity check
                error(L, "This is not a table.");
            lua_getfield(L, -1, "Frequency"); //GE: Put CardInfo.Frequncy onto the stack. It's a number.
            //GE: Replaced the key with the table. STACK: -1: number, -2: table, -3: table
            if (!lua_isnumber(L, -1)) //GE: Sanity check
                error(L, "This is not a number.");
            D_setFrequency(0,card,(int)lua_tonumber(L, -1));
            //CardDB[card].Frequency = (int)lua_tonumber(L, -1); //GE: Assign the number.
            lua_pop(L, 1); //GE: Removed one element from the stack, counting from the top.
            //GE: Removed an element. STACK: -1: table, -2: table

            if (!lua_istable(L, -1)) //GE: Sanity check
                error(L, "This is not a table.");
            lua_getfield(L, -1, "Name"); //GE: Put CardInfo.Name onto the stack. It's a string.
            //GE: Replaced the key with the table. STACK: -1: string, -2: table, -3: table
            if (!lua_isstring(L, -1)) //GE: Sanity check
                error(L, "This is not a string.");
            printf("Received string: %s\n", lua_tostring(L, -1));
            D_setName(0, card, lua_tostring(L, -1));
            D_printCardDB();
            //strcpy(CardDB[0].Name, lua_tostring(L, -1)); //GE: Assign the string. It gets garbage'd, so make sure we copy it instead of pointing at it. Also, what kind of logic is destination, source anyway?!
            //printf("Snagged Name: %s", CardDB[0].Name);
            lua_pop(L, 1); //GE: Removed one element from the stack, counting from the top.
            //GE: Removed an element. STACK: -1: table, -2: table

            if (!lua_istable(L, -1)) //GE: Sanity check
                error(L, "This is not a table.");
            lua_getfield(L, -1, "Description"); //GE: Put CardInfo.Name onto the stack. It's a string.
            //GE: Replaced the key with the table. STACK: -1: string, -2: table, -3: table
            if (!lua_isstring(L, -1)) //GE: Sanity check
                error(L, "This is not a string.");
            D_setDescription(0, card, lua_tostring(L, -1));
            D_printCardDB();
            //strcpy(CardDB[0].Description, lua_tostring(L, -1)); //GE: Assign the string. It gets garbage'd, so make sure we copy it instead of pointing at it. Also, what kind of logic is destination, source anyway?!
            lua_pop(L, 1); //GE: Removed one element from the stack, counting from the top.
            //GE: Removed an element. STACK: -1: table, -2: table

            if (!lua_istable(L, -1)) //GE: Sanity check
                error(L, "This is not a table.");
            lua_getfield(L, -1, "BrickCost"); //GE: Put CardInfo.Frequncy onto the stack. It's a number.
            //GE: Replaced the key with the table. STACK: -1: number, -2: table, -3: table
            if (!lua_isnumber(L, -1)) //GE: Sanity check
                error(L, "This is not a number.");
            D_setBrickCost(0,card,(int)lua_tonumber(L, -1));
            //CardDB[card].BrickCost = (int)lua_tonumber(L, -1); //GE: Assign the number.
            lua_pop(L, 1); //GE: Removed one element from the stack, counting from the top.
            //GE: Removed an element. STACK: -1: table, -2: table

            if (!lua_istable(L, -1)) //GE: Sanity check
                error(L, "This is not a table.");
            lua_getfield(L, -1, "GemCost"); //GE: Put CardInfo.Frequncy onto the stack. It's a number.
            //GE: Replaced the key with the table. STACK: -1: number, -2: table, -3: table
            if (!lua_isnumber(L, -1)) //GE: Sanity check
                error(L, "This is not a number.");
            D_setGemCost(0,card,(int)lua_tonumber(L, -1));
            //CardDB[card].GemCost = (int)lua_tonumber(L, -1); //GE: Assign the number.
            lua_pop(L, 1); //GE: Removed one element from the stack, counting from the top.
            //GE: Removed an element. STACK: -1: table, -2: table

            if (!lua_istable(L, -1)) //GE: Sanity check
                error(L, "This is not a table.");
            lua_getfield(L, -1, "RecruitCost"); //GE: Put CardInfo.Frequncy onto the stack. It's a number.
            //GE: Replaced the key with the table. STACK: -1: number, -2: table, -3: table
            if (!lua_isnumber(L, -1)) //GE: Sanity check
                error(L, "This is not a number.");
            D_setRecruitCost(0,card,(int)lua_tonumber(L, -1));
            //CardDB[card].RecruitCost = (int)lua_tonumber(L, -1); //GE: Assign the number.
            lua_pop(L, 1); //GE: Removed one element from the stack, counting from the top.
            //GE: Removed an element. STACK: -1: table, -2: table

            if (!lua_istable(L, -1)) //GE: Sanity check
                error(L, "This is not a table.");
            lua_getfield(L, -1, "Cursed"); //GE: Put CardInfo.Name onto the stack. It's a string.
            //GE: Replaced the key with the table. STACK: -1: boolean, -2: table, -3: table
            if (!lua_isboolean(L, -1))// && !lua_isnil(L, -1)) //GE: Sanity check
                error(L, "This is neither a boolean nor nil.");
            D_setCursed(0, card, lua_toboolean(L, -1));
            lua_pop(L, 1); //GE: Removed one element from the stack, counting from the top.
            //GE: Removed an element. STACK: -1: table, -2: table

            if (!lua_istable(L, -1)) //GE: Sanity check
                error(L, "This is not a table.");
            lua_getfield(L, -1, "Colour"); //GE: Put CardInfo.Name onto the stack. It's a string.
            //GE: Replaced the key with the table. STACK: -1: string, -2: table, -3: table
            if (!lua_isstring(L, -1)) //GE: Sanity check
                error(L, "This is not a string.");
            D_setColour(0, card, lua_tostring(L, -1));
            lua_pop(L, 1); //GE: Removed one element from the stack, counting from the top.
            //GE: Removed an element. STACK: -1: table, -2: table

    	    if (!lua_istable(L, -1)) //GE: Sanity check
    		error(L, "This is not a table.");
    	    lua_getfield(L, -1, "Picture"); //GE: Put CardInfo.Name onto the stack. It's a table.
    	    //GE: Replaced the key with the table. STACK: -1: table, -2: table, -3: table

                /*
                 * GE: What we do here is as follows: we get the filename as a string
                 * from Lua, then store it in D. After that's done, we ask D for the
                 * length of the SDL_Surface array and to return the needed strings.
                 * From that information we load all of the surfaces, and when
                 * rendering, we ask D for the filename, which we use to find the
                 * right file. And then we get the coordinates.
                 */

                if (!lua_istable(L, -1)) //GE: Sanity check
                    error(L, "This is not a table.");
                lua_getfield(L, -1, "File"); //GE: Put CardInfo.Picture.File onto the stack. It's a string.
                //GE: Replaced the key with the table. STACK: -1: string, -2: table, -3: table, -4: table
                if (!lua_isstring(L, -1)) //GE: Sanity check
                    error(L, "This is not a string.");
                printf("Currently held string is: %s\n", lua_tostring(L, -1));
                if (lua_objlen(L, -1) != 0) //GE: Don't load this in memory if it's empty.
                    PrecacheCard(lua_tostring(L, -1), lua_objlen(L, -1)); //GE: Put this into the linked list and load the image in memory.
                D_setPictureFile(0, card, lua_tostring(L, -1));
                lua_pop(L, 1); //GE: Removed one element from the stack, counting from the top.
                //GE: Removed an element. STACK: -1: table, -2: table, -3: table

                if (!lua_istable(L, -1)) //GE: Sanity check
                    error(L, "This is not a table.");
                lua_getfield(L, -1, "X"); //GE: Put CardInfo.Picture.X onto the stack. It's a number.
                //GE: Replaced the key with the table. STACK: -1: number, -2: table, -3: table, -4: table
                if (!lua_isnumber(L, -1)) //GE: Sanity check
                    error(L, "This is not a number.");
                X = (int)lua_tonumber(L, -1);
                lua_pop(L, 1); //GE: Removed one element from the stack, counting from the top.
                //GE: Removed an element. STACK: -1: table, -2: table, -3: table

                if (!lua_istable(L, -1)) //GE: Sanity check
                    error(L, "This is not a table.");
                lua_getfield(L, -1, "Y"); //GE: Put CardInfo.Picture.Y onto the stack. It's a number.
                //GE: Replaced the key with the table. STACK: -1: number, -2: table, -3: table, -4: table
                if (!lua_isnumber(L, -1)) //GE: Sanity check
                    error(L, "This is not a number.");
                Y = (int)lua_tonumber(L, -1);
                lua_pop(L, 1); //GE: Removed one element from the stack, counting from the top.
                //GE: Removed an element. STACK: -1: table, -2: table, -3: table

                if (!lua_istable(L, -1)) //GE: Sanity check
                    error(L, "This is not a table.");
                lua_getfield(L, -1, "W"); //GE: Put CardInfo.Picture.W onto the stack. It's a number.
                //GE: Replaced the key with the table. STACK: -1: number, -2: table, -3: table, -4: table
                if (!lua_isnumber(L, -1)) //GE: Sanity check
                    error(L, "This is not a number.");
                W = (int)lua_tonumber(L, -1);
                lua_pop(L, 1); //GE: Removed one element from the stack, counting from the top.
                //GE: Removed an element. STACK: -1: table, -2: table, -3: table

                if (!lua_istable(L, -1)) //GE: Sanity check
                    error(L, "This is not a table.");
                lua_getfield(L, -1, "H"); //GE: Put CardInfo.Picture.H onto the stack. It's a number.
                //GE: Replaced the key with the table. STACK: -1: number, -2: table, -3: table, -4: table
                if (!lua_isnumber(L, -1)) //GE: Sanity check
                    error(L, "This is not a number.");
                H = (int)lua_tonumber(L, -1);
                lua_pop(L, 1); //GE: Removed one element from the stack, counting from the top.
                //GE: Removed an element. STACK: -1: table, -2: table, -3: table
                D_setPictureCoords(0,card,X,Y,W,H); //GE: Send the coordinates to D.

    	    lua_pop(L, 1); //GE: Removed one element from the stack, counting from the top.
    	    //GE: Removed an element. STACK: -1: table, -2: table

    	if (!lua_istable(L, -1)) //GE: Sanity check
                error(L, "This is not a table.");
            lua_getfield(L, -1, "LuaFunction"); //GE: Put CardInfo.LuaFunction onto the stack. It's a string.
            //GE: Replaced the key with the string. STACK: -1: string, -2: table, -3: table
            if (!lua_isstring(L, -1)) //GE: Sanity check
                error(L, "This is not a string.");
            D_setLuaFunction(0, card, lua_tostring(L, -1));
            lua_pop(L, 1); //GE: Removed one element from the stack, counting from the top.
            //GE: Removed an element. STACK: -1: table, -2: table

            lua_pop(L, 1); //GE: Removed one element from the stack, counting from the top.
            //GE: Removed an element. STACK: -1: table
        }

        lua_pop(L, 1); //GE: Clear the stack. Finished dealing with the function.
        printf("Finished setting up the CardDB!");
        
        lua_pop(L, 2);//GE: Get rid of the InitFunction and cell.
        
        
    }
    lua_pop(L, 1);//GE: Get rid of the PoolInfo.
    
    
    
    DeckTotal++;
    for (i=0; i<CARDS; i++)
    {
        //CardDB[i].ID = TidyQ[i]; //GE: [At this time?], TidyQ is neatly made. Let's use this to our advantage.
        //strcpy(CardDB[i].Name, CardName(CardDB[i].ID));
        //CardDB[i].Frequency = CardFrequencies(i);
        DeckTotal += D_getFrequency(0, i);//CardDB[i].Frequency;
    } 
    
}

void ShuffleQ()
{
  int i,a,b,t;
  /*printf("DeckTotal before: %d\n", DeckTotal);
  for (i=0; i<DeckTotal; i++)
	{
      printf("Before: Q[%d]=%d\n", i, Q[i]);
  } */
  for (i=0;i<65535;i++) //GE: A ludicrous way to randomise the Q array.
	{
		a=rand()%DeckTotal;
		b=rand()%DeckTotal;
		t=Q[a];Q[a]=Q[b];Q[b]=t;
	}
	/*printf("DeckTotal after: %d\n", DeckTotal);
  for (i=0; i<DeckTotal; i++)
	{
      printf("After: Q[%d]=%d\n", i, Q[i]);
  } */
	FrontendFunctions.Sound_Play(Shuffle);
}

void InitDeck()
{
	int i, i2=0, i3=0;
	Qs=0;
	Qe=0;
	//struct CardInfo LastEntry;
	//free(Q);
	//printf("Init complete: %d\n", bInitComplete);
  if (bInitComplete)
	{
      ShuffleQ();
      return;
  }
	
  //for (i=0;i<CARDS/*/3*/;i++) //GE: Creates a neat array of cards.
	//{
		//TidyQ[i]=i+1;
    /*TidyQ[i          ]=i+1;
		TidyQ[i+  CARDS/3]=i+1+(1<<8);
		TidyQ[i+2*CARDS/3]=i+1+(2<<8);*/
/*		printf("%d\n", Q[i]);
		printf("%d\n", Q[i+  CARDS/3]);
		printf("%d\n", Q[i+2*CARDS/3]);*/
	//}
	InitCardDB();
	Q = (int*) malloc((sizeof (int)) * DeckTotal); //GE: Make Q as big as we want it to be.
	//printf("DeckTotal: %d\n", DeckTotal);
	//GE: We need Q set up as a tidy array with card IDs depending on their frequency.
	for (i=0; i<CARDS; i++) //GE: Go through every card.
	{
	   for( i2 = 0; i2 < D_getFrequency(0,i); i2++, i3++) //GE: Iterate though the frequency settings and set them
	   {
        Q[i3] = i; //GE: i3 doesn't get reset, unlike i2.
        //printf("Q[%d]: %d\n", i3, CardDB[i].ID);
     }   
  }
  bInitComplete = 1;
  ShuffleQ();
}

void SetDeck(int *d)
{
	int i;
	for (i=0;i<CARDS;i++)
		Q[i]=d[i];
}

void normalize(struct Stats *s)
{
	if (s->q<1) s->q=1;
	if (s->m<1) s->m=1;
	if (s->d<1) s->d=1;
	if (s->q>99) s->q=99;
	if (s->m>99) s->m=99;
	if (s->d>99) s->d=99;

	if (s->b<0) s->b=0;
	if (s->g<0) s->g=0;
	if (s->r<0) s->r=0;
	if (s->b>999) s->b=999;
	if (s->g>999) s->g=999;
	if (s->r>999) s->r=999;

	if (s->t<0) s->t=0;
	if (s->w<0) s->w=0;
	if (s->t>200) s->t=200;
	if (s->w>200) s->w=200;
}

void damage(struct Stats *s,int how)
{
	if (s->w>=how) s->w-=how;
	else {
		s->t-=(how-s->w);
		s->w=0;
	}
}

int Requisite(struct Stats *s,int card)
{
	//printf("Requisition: Card requires %d/%d/%d, we have %d bricks, %d gems, %d recruits\n", D_getBrickCost(0,s->Hand[card]), D_getGemCost(0,s->Hand[card]), D_getRecruitCost(0,s->Hand[card]), s->b, s->g, s->r);
	if ( D_getBrickCost(0,s->Hand[card]) > s->b ) return 0;
	if ( D_getGemCost(0,s->Hand[card]) > s->g ) return 0;
	if ( D_getRecruitCost(0,s->Hand[card]) > s->r ) return 0;
	return 1;
}

void Require(struct Stats *s1, int bricks, int gems, int recruits)
{
	s1->b-=bricks;
	s1->g-=gems;
	s1->r-=recruits;
}

int GetAbsolutePlayer(int Relative)
{
    if (Relative == 1) //GE: If the player is 1, that means we set it up as the enemy.
	return !turn;
    else if (Relative == 0) //GE: If not, then player is 0, which means the guy whose turn it is.
	return turn;
    else //GE: If it's an unknown value, don't do anything. This is useful for discarding round.
	return Relative;
}

/*
 * GE: Use 'next=-1;' to indicate cards that initiate a "discard turn".
 * Use 'next=turn;' to indicate cards that don't cost a turn.
 */
int Deck(struct Stats *s1,struct Stats *s2,int card,int turn)
{
	/*
	 * GE: Lua reform: We get the name of the lua function from D, then send all
	 * the parameters there to Lua, from where we get the updated information,
	 * which we apply.
	 * All of the processing is done either here in C or in D, Lua only has control
	 * over the functions it calls.
	 *
	 * Contract: this function here expects the basic statistics of both players,
	 * the ID of the played card and the number of the player whose turn it is.
	 * It returns the turn of the new player, that's how you get additional turns.
	 * After the reform, this should only call Lua, and Lua should then handle
	 * things on its side, returning the needed turn.
   */
  
	int next=!turn;
	int x;

	//GE: Get the function name from D and call it through the stack.
	//if (D_getLuaFunctionSize(0,card) > 2)//GE: FIXME, this should not be needed under proper Lua coding
	//{
	    lua_getfield( L, LUA_GLOBALSINDEX, D_getLuaFunction(0, card) ); //GE: Push a function to the stack. STACK: -1: function
	    if (!lua_isfunction(L, -1)) //GE: Sanity check.
		error(L, "Failed to get the function from Lua. Returning.");
	    lua_call(L, 0, 1); //GE: Call the function, sending no arguments, expecting one result. STACK: -1: int
	    if (!lua_isnumber(L, -1))
		error(L, "Failed to get a return value from the function. Please review the Lua code.");
	    next = (int) lua_tonumber(L, -1); //GE: This is temporary - next is relative here.
	    next = GetAbsolutePlayer(next); //GE: Make the player absolute again.
	    lua_pop(L, 1); //GE: Clean the stack. STACK: Empty
	    
	    //GE: Consume resources.
	    Require(s1, D_getBrickCost(0,card), D_getGemCost(0,card), D_getRecruitCost(0,card));
	//}
	
	
	
  /*switch (card)
	{
		case 0:		// Brick Shortage
			s1->b-=8;
			s2->b-=8;
			Sound_Play(RESS_DOWN);
			break;
		case 1:		// Lucky Cache
			s1->b+=2;
			s1->g+=2;
			Sound_Play(RESS_UP);
			next=turn;
			break;
		case 2:		// Friendly Terrain
			Require(s1, 1, 0, 0);
			s1->w++;
			Sound_Play(WALL_UP);
			next=turn;
			break;
		case 3:		// Miners
			Require(s1, 3, 0, 0);
			s1->q++;
			Sound_Play(RESB_UP);
			break;
		case 4:		// Mother Lode
			Require(s1, 4, 0, 0);
			if (s1->q<s2->q) s1->q++;
			s1->q++;
			Sound_Play(RESB_UP);
			break;
		case 5:		// Dwarven Miners
			Require(s1, 7, 0, 0);
			s1->w+=4;
			s1->q++;
			Sound_Play(WALL_UP);
			Sound_Play(RESB_UP);
			break;
		case 6:		// Work Overtime
			Require(s1, 2, 0, 0);
			s1->w+=5;
			s1->g-=6;
			Sound_Play(WALL_UP);
			Sound_Play(RESS_DOWN);
			break;
		case 7:		// Copping the Tech
			Require(s1, 5, 0, 0);
			if (s1->q<s2->q)
			{
				s1->q=s2->q;
				Sound_Play(RESB_UP);
			}
			break;
		case 8:		// Basic Wall
			Require(s1, 2, 0, 0);
			s1->w+=3;
			Sound_Play(WALL_UP);
			break;
		case 9:		// Sturdy Wall
			Require(s1, 3, 0, 0);
			s1->w+=4;
			Sound_Play(WALL_UP);
			break;
		case 10:		// Innovations
			Require(s1, 2, 0, 0);
			s1->q++;
			s2->q++;
			s1->g+=4;
			Sound_Play(RESB_UP);
			Sound_Play(RESS_UP);
			break;
		case 11:		// Foundations
			Require(s1, 3, 0, 0);
			if (!s1->w)
				s1->w+=6;
			else
				s1->w+=3;
			Sound_Play(WALL_UP);
			break;
		case 12:		// Tremors
			Require(s1, 7, 0, 0);
			s1->w-=5;
			s2->w-=5;
			Sound_Play(DAMAGE);
			next=turn;
			break;
		case 13:		// Secret Room
			Require(s1, 8, 0, 0);
			s1->m++;
			Sound_Play(RESB_UP);
			next=turn;
			break;
		case 14:		// Earthquake
			s1->q--;
			s2->q--;
			Sound_Play(RESB_DOWN);
			break;
		case 15:		// Big Wall
			Require(s1, 5, 0, 0);
			s1->w+=6;
			Sound_Play(WALL_UP);
			break;
		case 16:		// Collapse
			Require(s1, 4, 0, 0);
			s2->q--;
			Sound_Play(RESB_DOWN);
			break;
		case 17:		// New Equipment
			Require(s1, 6, 0, 0);
			s1->q+=2;
			Sound_Play(RESB_UP);
			break;
		case 18:		// Strip Mine
			s1->q--;
			s1->w+=10;
			s1->g+=5;
			Sound_Play(WALL_UP);
			Sound_Play(RESB_DOWN);
			Sound_Play(RESS_UP);
			break;
		case 19:		// Reinforced Wall
			Require(s1, 8, 0, 0);
			s1->w+=8;
			Sound_Play(WALL_UP);
			break;
		case 20:		// Porticulus
			Require(s1, 9, 0, 0);
			s1->w+=5;
			s1->d++;
			Sound_Play(WALL_UP);
			Sound_Play(RESB_UP);
			break;
		case 21:		// Crystal Rocks
			Require(s1, 9, 0, 0);
			s1->w+=7;
			s1->g+=7;
			Sound_Play(WALL_UP);
			Sound_Play(RESS_UP);
			break;
		case 22:		// Harmonic Ore
			Require(s1, 11, 0, 0);
			s1->w+=6;
			s1->t+=3;
			Sound_Play(TOWER_UP);
			Sound_Play(WALL_UP);
			break;
		case 23:		// MondoWall
			Require(s1, 13, 0, 0);
			s1->w+=12;
			Sound_Play(WALL_UP);
			break;
		case 24:		// Focused Designs
			Require(s1, 15, 0, 0);
			s1->w+=8;
			s1->t+=5;
			Sound_Play(TOWER_UP);
			Sound_Play(WALL_UP);
			break;
		case 25:		// Great Wall
			Require(s1, 16, 0, 0);
			s1->w+=15;
			Sound_Play(WALL_UP);
			break;
		case 26:		// Rock Launcher
			Require(s1, 18, 0, 0);
			s1->w+=6;
			Sound_Play(DAMAGE);
			Sound_Play(WALL_UP);
			damage(s2,10);
			break;
		case 27:		// Dragon's Heart
			Require(s1, 1, 24, 0);
			s1->w+=20;
			s1->t+=8;
			Sound_Play(TOWER_UP);
			Sound_Play(WALL_UP);
			break;
		case 28:		// Forced Labor
			Require(s1, 7, 0, 0);
			s1->w+=9;
			s1->r-=5;
			Sound_Play(WALL_UP);
			Sound_Play(RESS_DOWN);
			break;
		case 29:		// Rock Garden
			Require(s1, 1, 0, 0);
			s1->w++;
			s1->t++;
			s1->r+=2;
			Sound_Play(TOWER_UP);
			Sound_Play(WALL_UP);
			Sound_Play(RESS_UP);
			break;
		case 30:		// Flood Water
			Require(s1, 6, 0, 0);
			if (s1->w<s2->w)
			{
				s1->d--;
				s1->t-=2;
			} else {	//GE: Originally it's beneficial
				s2->d--;
				s2->t-=2;
			}
			Sound_Play(DAMAGE);
			Sound_Play(RESB_DOWN);
			break;
		case 31:		// Barracks
			Require(s1, 10, 0, 0);
			s1->r+=6;
			s1->w+=6;
			Sound_Play(WALL_UP);
			Sound_Play(RESS_UP);
			if (s1->d<s2->d)
			{
				s1->d++;
				Sound_Play(RESB_UP);
			}
			break;
		case 32:		// Battlements
			Require(s1, 14, 0, 0);
			s1->w+=7;
			Sound_Play(DAMAGE);
			Sound_Play(WALL_UP);
			damage(s2,6);
			break;
		case 33:		// Shift
			Require(s1, 17, 0, 0);
			if (s1->w!=s2->w)
			{
				Sound_Play(DAMAGE);
				Sound_Play(WALL_UP);
			}
			x=s1->w;
			s1->w=s2->w;
			s2->w=x;
			break;
		case 34:	// Quartz
			Require(s1, 0, 1, 0);
			s1->t++;
			Sound_Play(TOWER_UP);
			next=turn;
			break;
		case 35:	// Smoky Quartz
			Require(s1, 0, 2, 0);
			Sound_Play(DAMAGE);
			s2->t--;
			next=turn;
			break;
		case 36:	// Amethyst
			Require(s1, 0, 2, 0);
			s1->t+=3;
			Sound_Play(TOWER_UP);
			break;
		case 37:	// Spell Weavers
			Require(s1, 0, 3, 0);
			s1->m++;
			Sound_Play(RESB_UP);
			break;
		case 38:	// Prism
			Require(s1, 0, 2, 0);
			next=-1;
			break;
		case 39:	// Lodestone
			Require(s1, 0, 5, 0);
			s1->t+=3;
			Sound_Play(TOWER_UP);
			break;
		case 40:	// Solar Flare
			Require(s1, 0, 4, 0);
			s1->t+=2;
			s2->t-=2;
			Sound_Play(TOWER_UP);
			Sound_Play(DAMAGE);
			break;
		case 41:	// Crystal Matrix
			Require(s1, 0, 6, 0);
			s1->m++;
			s1->t+=3;
			s2->t++;
			Sound_Play(TOWER_UP);
			Sound_Play(RESB_UP);
			break;
		case 42:	// Gemstone Flaw
			Require(s1, 0, 2, 0);
			s2->t-=3;
			Sound_Play(DAMAGE);
			break;
		case 43:	// Ruby
			Require(s1, 0, 3, 0);
			s1->t+=5;
			Sound_Play(TOWER_UP);
			break;
		case 44:	// Gem Spear
			Require(s1, 0, 4, 0);
			s2->t-=5;
			Sound_Play(DAMAGE);
			break;
		case 45:	// Power Burn
			Require(s1, 0, 3, 0);
			s1->t-=5;
			s1->m+=2;
			Sound_Play(RESB_UP);
			Sound_Play(DAMAGE);
			break;
		case 46:	// Harmonic Vibe
			Require(s1, 0, 7, 0);
			s1->m++;
			s1->t+=3;
			s1->w+=3;
			Sound_Play(TOWER_UP);
			Sound_Play(WALL_UP);
			Sound_Play(RESB_UP);
			break;
		case 47:	// Parity
			Require(s1, 0, 7, 0);
			if (s2->m>s1->m)
			{
				s1->m=s2->m;
				Sound_Play(RESB_UP);
			}
			else if (s2->m<s1->m)
			{
				s2->m=s1->m;
				Sound_Play(RESB_UP);
			}
			break;
		case 48:	// Emerald
			Require(s1, 0, 6, 0);
			s1->t+=8;
			Sound_Play(TOWER_UP);
			break;
		case 49:	// Pearl of Wisdom
			Require(s1, 0, 9, 0);
			s1->t+=5;
			s1->m++;
			Sound_Play(TOWER_UP);
			Sound_Play(RESB_UP);
			break;
		case 50:	// Shatterer
			Require(s1, 0, 8, 0);
			s1->m--;
			s2->t-=9;
			Sound_Play(DAMAGE);
			Sound_Play(RESB_DOWN);
			break;
		case 51:	// Crumblestone
			Require(s1, 0, 7, 0);
			s1->t+=5;
			s2->b-=6;
			Sound_Play(TOWER_UP);
			Sound_Play(RESS_DOWN);
			break;
		case 52:	// Sapphire
			Require(s1, 0, 10, 0);
			s1->t+=11;
			Sound_Play(TOWER_UP);
			break;
		case 53:	// Discord
			Require(s1, 0, 5, 0);
			s1->t-=7;
			s2->t-=7;
			s1->m--;
			s2->m--;
			Sound_Play(DAMAGE);
			Sound_Play(RESB_DOWN);
			break;
		case 54:	// Fire Ruby
			Require(s1, 0, 13, 0);
			s1->t+=6;
			s2->t-=4;
			Sound_Play(TOWER_UP);
			Sound_Play(DAMAGE);
			break;
		case 55:	// Quarry's Help
			Require(s1, 0, 4, 0);
			s1->t+=7;
			s1->b-=10;
			Sound_Play(TOWER_UP);
			Sound_Play(RESS_DOWN);
			break;
		case 56:	// Crystal Shield
			Require(s1, 0, 12, 0);
			s1->t+=8;
			s1->w+=3;
			Sound_Play(TOWER_UP);
			Sound_Play(WALL_UP);
			break;
		case 57:	// Empathy Gem
			Require(s1, 0, 14, 0);
			s1->t+=8;
			s1->d++;
			Sound_Play(TOWER_UP);
			Sound_Play(RESB_UP);
			break;
		case 58:	// Diamond
			Require(s1, 0, 16, 0);
			s1->t+=15;
			Sound_Play(TOWER_UP);
			break;
		case 59:	// sanctuary
			Require(s1, 0, 15, 0);
			s1->t+=10;
			s1->w+=5;
			s1->r+=5;
			Sound_Play(TOWER_UP);
			Sound_Play(RESS_UP);
			Sound_Play(WALL_UP);
			break;
		case 60:	// Lava Jewel
			Require(s1, 0, 17, 0);
			s1->t+=12;
			damage(s2,6);
			Sound_Play(TOWER_UP);
			Sound_Play(DAMAGE);
			break;
		case 61:	// Dragon's Eye
			Require(s1, 0, 21, 0);
			s1->t+=20;
			Sound_Play(TOWER_UP);
			break;
		case 62:	// Crystallize
			Require(s1, 0, 8, 0);
			s1->t+=11;
			s1->w-=6;
			Sound_Play(TOWER_UP);
			Sound_Play(DAMAGE);
			break;
		case 63:	// Bag of Baubles
			if (s1->t<s2->t) s1->t++;
			s1->t++;
			Sound_Play(TOWER_UP);
			break;
		case 64:	// Rainbow
			s1->t++;
			s2->t++;
			s1->g+=3;
			Sound_Play(TOWER_UP);
			Sound_Play(RESS_UP);
			break;
		case 65:	// Apprentice
			Require(s1, 0, 5, 0);
			s1->t+=4;
			s1->r-=3;
			s2->t-=2;
			Sound_Play(TOWER_UP);
			Sound_Play(RESS_DOWN);
			Sound_Play(DAMAGE);
			break;
		case 66:	// Lightning Shard
			Require(s1, 0, 11, 0);
			if (s1->t>s2->w)
				s2->t-=8;
			else
				damage(s2,8);
			Sound_Play(DAMAGE);
			break;
		case 67:	// Phase Jewel
			Require(s1, 0, 18, 0);
			s1->t+=13;
			s1->r+=6;
			s1->b+=6;
			Sound_Play(TOWER_UP);
			Sound_Play(RESS_UP);
			break;
		case 68:	// Mad Cow Disease
			s1->r-=6;
			s2->r-=6;
			Sound_Play(RESS_DOWN);
			break;
		case 69:	// Faerie
			Require(s1, 0, 0, 1);
			Sound_Play(DAMAGE);
			damage(s2,2);
			next=turn;
			break;
		case 70:	// Moody Goblins
			Require(s1, 0, 0, 1);
			Sound_Play(DAMAGE);
			Sound_Play(RESS_DOWN);
			damage(s2,4);
			s1->g-=3;
			break;
		case 71:	// Minotaur
			Require(s1, 0, 0, 3);
			s1->d++;
			Sound_Play(RESB_UP);
			break;
		case 72:	// Elven Scout
			Require(s1, 0, 0, 2);
			next=-1;
			break;
		case 73:	// Goblin Mob
			Require(s1, 0, 0, 3);
			Sound_Play(DAMAGE);
			damage(s2,6);
			damage(s1,3);
			break;
		case 74:	// Goblin Archers
			Require(s1, 0, 0, 4);
			s2->t-=3;
			Sound_Play(DAMAGE);
			damage(s1,1);
			break;
		case 75:	// Shadow Faerie
			Require(s1, 0, 0, 6);
			Sound_Play(DAMAGE);
			s2->t-=2;
			next=turn;
			break;
		case 76:	// Orc
			Require(s1, 0, 0, 3);
			Sound_Play(DAMAGE);
			damage(s2,5);
			break;
		case 77:	// Dwarves
			Require(s1, 0, 0, 5);
			Sound_Play(DAMAGE);
			Sound_Play(WALL_UP);
			damage(s2,4);
			s1->w+=3;
			break;
		case 78:	// Little Snakes
			Require(s1, 0, 0, 6);
			Sound_Play(DAMAGE);
			s2->t-=4;
			break;
		case 79:	// Troll Trainer
			Require(s1, 0, 0, 7);
			s1->d+=2;
			Sound_Play(RESB_UP);
			break;
		case 80:	// Tower Gremlin
			Require(s1, 0, 0, 8);
			s1->w+=4;
			s1->t+=2;
			Sound_Play(TOWER_UP);
			Sound_Play(DAMAGE);
			Sound_Play(WALL_UP);
			damage(s2,2);
			break;
		case 81:	// Full Moon
			s1->d++;
			s2->d++;
			s1->r+=3;
			Sound_Play(RESB_UP);
			Sound_Play(RESS_UP);
			break;
		case 82:	// Slasher
			Require(s1, 0, 0, 5);
			Sound_Play(DAMAGE);
			damage(s2,6);
			break;
		case 83:	// Ogre
			Require(s1, 0, 0, 6);
			Sound_Play(DAMAGE);
			damage(s2,7);
			break;
		case 84:	// Rabid Sheep
			Require(s1, 0, 0, 6);
			Sound_Play(DAMAGE);
			Sound_Play(RESS_DOWN);
			damage(s2,6);
			s2->r-=3;
			break;
		case 85:	// Imp
			Require(s1, 0, 0, 5);
			Sound_Play(DAMAGE);
			Sound_Play(RESS_DOWN);
			damage(s2,6);
			s1->b-=5;
			s2->b-=5;
			s1->g-=5;
			s2->g-=5;
			s1->r-=5;
			s2->r-=5;
			break;
		case 86:	// Spizzer
			Require(s1, 0, 0, 8);
			Sound_Play(DAMAGE);
			if (!s2->w)
				damage(s2,10);
			else
				damage(s2,6);
			break;
		case 87:	// Werewolf
			Require(s1, 0, 0, 9);
			Sound_Play(DAMAGE);
			damage(s2,9);
			break;
		case 88:	// Corrosion Cloud
			Require(s1, 0, 0, 11);
			Sound_Play(DAMAGE);
			if (s2->w)
				damage(s2,10);
			else
				damage(s2,7);
			break;
		case 89:	// Unicorn
			Require(s1, 0, 0, 9);
			Sound_Play(DAMAGE);
			if (s1->m>s2->m)
				damage(s2,12);
			else
				damage(s2,8);
		case 90:	// Elven Archers
			Require(s1, 0, 0, 10);
			Sound_Play(DAMAGE);
			if (s1->w>s2->w)
				s2->t-=6;
			else
				damage(s2,6);
			break;
		case 91:	// Succubus
			Require(s1, 0, 0, 14);
			Sound_Play(DAMAGE);
			Sound_Play(RESS_DOWN);
			s2->t-=5;
			s2->r-=8;
			break;
		case 92:	// Rock Stompers
			Require(s1, 0, 0, 11);
			Sound_Play(DAMAGE);
			Sound_Play(RESB_DOWN);
			damage(s2,8);
			s2->q--;
			break;
		case 93:	// Thief
			Require(s1, 0, 0, 12);
			Sound_Play(RESS_UP);
			Sound_Play(RESS_DOWN);
			if (s2->g>=10)
			{
				s2->g-=10;
				s1->g+=5;
			} else {
				s1->g+=(s2->g+1)/2;
				s2->g=0;
			}
			if (s2->b>=5)
			{
				s2->b-=5;
				s1->b+=3;
			} else {
				s1->b+=(s2->b+1)/2;
				s2->b=0;
			}
			break;
		case 94:	// Stone Giant
			Require(s1, 0, 0, 15);
			Sound_Play(DAMAGE);
			Sound_Play(WALL_UP);
			damage(s2,10);
			s1->w+=4;
			break;
		case 95:	// Vampire
			Require(s1, 0, 0, 17);
			Sound_Play(DAMAGE);
			Sound_Play(RESB_DOWN);
			damage(s2,10);
			s2->r-=5;
			s2->d--;
			break;
		case 96:	// Dragon
			Require(s1, 0, 0, 25);
			Sound_Play(DAMAGE);
			Sound_Play(RESB_DOWN);
			damage(s2,20);
			s2->g-=10;
			s2->d--;
			break;
		case 97:	// Spearman
			Require(s1, 0, 0, 2);
			Sound_Play(DAMAGE);
			if (s1->w>s2->w)
				damage(s2,3);
			else
				damage(s2,2);
			break;
		case 98:	// Gnome
			Require(s1, 0, 0, 2);
			Sound_Play(DAMAGE);
			Sound_Play(RESS_UP);
			damage(s2,3);
			s1->g++;
			break;
		case 99:	// Berserker
			Require(s1, 0, 0, 4);
			Sound_Play(DAMAGE);
			damage(s2,8);
			s1->t-=3;
			break;
		case 100:	// Warlord
			Require(s1, 0, 0, 13);
			Sound_Play(DAMAGE);
			Sound_Play(RESS_DOWN);
			damage(s2,13);
			s1->g-=3;
			break;
		case 101:	// Pegasus Lancer
			Require(s1, 0, 0, 18);
			Sound_Play(DAMAGE);
			s2->t-=12;
			break;
	}*/

	return next;
}

//void Damage(int Who, int Amount);
int L_Damage (lua_State *L)
{
    if (!lua_isnumber(L, -1) || !lua_isnumber(L, -2))
	error(L, "Damage: Received a call with faulty parameters.");
    int Who = lua_tonumber(L, -2);
    int Amount = lua_tonumber(L, -1);
    
    Who = GetAbsolutePlayer(Who); //GE: Relative to absolute conversion.
    
    if (Player[Who].w >= Amount)
	Player[Who].w -= Amount;
    else
    {
	Player[Who].t -= (Amount - Player[Who].w);
	Player[Who].w = 0;
    }
    FrontendFunctions.Sound_Play(Damage);
    
    return 0;
}

//void AddQuarry(int Who, int Amount);
int L_AddQuarry (lua_State *L)
{
    if (!lua_isnumber(L, -1) || !lua_isnumber(L, -2))
	error(L, "AddQuarry: Received a call with faulty parameters.");
    int Who = lua_tonumber(L, -2);
    int Amount = lua_tonumber(L, -1);
    
    Who = GetAbsolutePlayer(Who); //GE: Relative to absolute conversion.
    
    if (Player[Who].q < 99)
    {
	Player[Who].q += Amount;
	FrontendFunctions.Sound_Play(ResB_Up);
    }
    
    return 0;
}

//void AddMagic(int Who, int Amount);
int L_AddMagic (lua_State *L)
{
    if (!lua_isnumber(L, -1) || !lua_isnumber(L, -2))
	error(L, "AddMagic: Received a call with faulty parameters.");
    int Who = lua_tonumber(L, -2);
    int Amount = lua_tonumber(L, -1);
    
    Who = GetAbsolutePlayer(Who); //GE: Relative to absolute conversion.
    
    if (Player[Who].m < 99)
    {
	Player[Who].m += Amount;
	FrontendFunctions.Sound_Play(ResB_Up);
    }
    
    return 0;
}

//void AddDungeon(int Who, int Amount);
int L_AddDungeon (lua_State *L)
{
    if (!lua_isnumber(L, -1) || !lua_isnumber(L, -2))
	error(L, "AddDungeon: Received a call with faulty parameters.");
    int Who = lua_tonumber(L, -2);
    int Amount = lua_tonumber(L, -1);
    
    Who = GetAbsolutePlayer(Who); //GE: Relative to absolute conversion.
    
    if (Player[Who].d < 99)
    {
	Player[Who].d += Amount;
	FrontendFunctions.Sound_Play(ResB_Up);
    }
    
    return 0;
}

//void AddBricks(int Who, int Amount);
int L_AddBricks (lua_State *L)
{
    if (!lua_isnumber(L, -1) || !lua_isnumber(L, -2))
	error(L, "AddBricks: Received a call with faulty parameters.");
    int Who = lua_tonumber(L, -2);
    int Amount = lua_tonumber(L, -1);
    
    Who = GetAbsolutePlayer(Who); //GE: Relative to absolute conversion.
    
    if (Player[Who].b < 999)
    {
	Player[Who].b += Amount;
	FrontendFunctions.Sound_Play(ResS_Up );
    }
    
    return 0;
}

//void AddGems(int Who, int Amount);
int L_AddGems (lua_State *L)
{
    if (!lua_isnumber(L, -1) || !lua_isnumber(L, -2))
	error(L, "AddGems: Received a call with faulty parameters.");
    int Who = lua_tonumber(L, -2);
    int Amount = lua_tonumber(L, -1);
    
    Who = GetAbsolutePlayer(Who); //GE: Relative to absolute conversion.
    
    if (Player[Who].g < 999)
    {
	Player[Who].g += Amount;
	FrontendFunctions.Sound_Play(ResS_Up);
    }
    
    return 0;
}

//void AddRecruits(int Who, int Amount);
int L_AddRecruits (lua_State *L)
{
    if (!lua_isnumber(L, -1) || !lua_isnumber(L, -2))
	error(L, "AddRecruits: Received a call with faulty parameters.");
    int Who = lua_tonumber(L, -2);
    int Amount = lua_tonumber(L, -1);
    
    Who = GetAbsolutePlayer(Who); //GE: Relative to absolute conversion.
    
    if (Player[Who].r < 999)
    {
	Player[Who].r += Amount;
	FrontendFunctions.Sound_Play(ResS_Up);
    }
    
    return 0;
}

//void AddTower(int Who, int Amount);
int L_AddTower (lua_State *L)
{
    if (!lua_isnumber(L, -1) || !lua_isnumber(L, -2))
	error(L, "AddTower: Received a call with faulty parameters.");
    int Who = lua_tonumber(L, -2);
    int Amount = lua_tonumber(L, -1);
    
    Who = GetAbsolutePlayer(Who); //GE: Relative to absolute conversion.
    
    if (Player[Who].t < 200)
    {
	Player[Who].t += Amount;
	FrontendFunctions.Sound_Play(Tower_Up);
    }
    
    return 0;
}

//void AddWall(int Who, int Amount);
int L_AddWall (lua_State *L)
{
    if (!lua_isnumber(L, -1) || !lua_isnumber(L, -2))
	error(L, "AddWall: Received a call with faulty parameters.");
    int Who = lua_tonumber(L, -2);
    int Amount = lua_tonumber(L, -1);
    
    Who = GetAbsolutePlayer(Who); //GE: Relative to absolute conversion.
    
    if (Player[Who].w < 200)
    {
	Player[Who].w += Amount;
	FrontendFunctions.Sound_Play(Wall_Up);
    }
    
    return 0;
}

//void RemoveQuarry(int Who, int Amount);
int L_RemoveQuarry (lua_State *L)
{
    if (!lua_isnumber(L, -1) || !lua_isnumber(L, -2))
	error(L, "RemoveQuarry: Received a call with faulty parameters.");
    int Who = lua_tonumber(L, -2);
    int Amount = lua_tonumber(L, -1);
    
    Who = GetAbsolutePlayer(Who); //GE: Relative to absolute conversion.
    
    if (Player[Who].q > 1)
    {
	Player[Who].q -= Amount;
	FrontendFunctions.Sound_Play(ResB_Down);
    }
    
    return 0;
}

//void RemoveMagic(int Who, int Amount);
int L_RemoveMagic (lua_State *L)
{
    if (!lua_isnumber(L, -1) || !lua_isnumber(L, -2))
	error(L, "RemoveMagic: Received a call with faulty parameters.");
    int Who = lua_tonumber(L, -2);
    int Amount = lua_tonumber(L, -1);
    
    Who = GetAbsolutePlayer(Who); //GE: Relative to absolute conversion.
    
    if (Player[Who].m > 1)
    {
	Player[Who].m -= Amount;
	FrontendFunctions.Sound_Play(ResB_Down);
    }
    
    return 0;
}

//void RemoveDungeon(int Who, int Amount);
int L_RemoveDungeon (lua_State *L)
{
    if (!lua_isnumber(L, -1) || !lua_isnumber(L, -2))
	error(L, "RemoveDungeon: Received a call with faulty parameters.");
    int Who = lua_tonumber(L, -2);
    int Amount = lua_tonumber(L, -1);
    
    Who = GetAbsolutePlayer(Who); //GE: Relative to absolute conversion.
    
    if (Player[Who].d > 1)
    {
	Player[Who].d -= Amount;
	FrontendFunctions.Sound_Play(ResB_Down);
    }
    
    return 0;
}

//void RemoveBricks(int Who, int Amount);
int L_RemoveBricks (lua_State *L)
{
    if (!lua_isnumber(L, -1) || !lua_isnumber(L, -2))
	error(L, "RemoveBricks: Received a call with faulty parameters.");
    int Who = lua_tonumber(L, -2);
    int Amount = lua_tonumber(L, -1);
    
    Who = GetAbsolutePlayer(Who); //GE: Relative to absolute conversion.
    
    if (Player[Who].b > 0)
    {
	Player[Who].b -= Amount;
	FrontendFunctions.Sound_Play(ResS_Down);
    }
    
    return 0;
}

//void RemoveGems(int Who, int Amount);
int L_RemoveGems (lua_State *L)
{
    if (!lua_isnumber(L, -1) || !lua_isnumber(L, -2))
	error(L, "RemoveGems: Received a call with faulty parameters.");
    int Who = lua_tonumber(L, -2);
    int Amount = lua_tonumber(L, -1);
    
    Who = GetAbsolutePlayer(Who); //GE: Relative to absolute conversion.
    
    if (Player[Who].g > 0)
    {
	Player[Who].g -= Amount;
	FrontendFunctions.Sound_Play(ResS_Down);
    }
    
    return 0;
}

//void RemoveRecruits(int Who, int Amount);
int L_RemoveRecruits (lua_State *L)
{
    if (!lua_isnumber(L, -1) || !lua_isnumber(L, -2))
	error(L, "RemoveRecruits: Received a call with faulty parameters.");
    int Who = lua_tonumber(L, -2);
    int Amount = lua_tonumber(L, -1);
    
    Who = GetAbsolutePlayer(Who); //GE: Relative to absolute conversion.
    
    if (Player[Who].r > 0)
    {
	Player[Who].r -= Amount;
	FrontendFunctions.Sound_Play(ResS_Down);
    }
    
    return 0;
}

//void RemoveTower(int Who, int Amount);
int L_RemoveTower (lua_State *L)
{
    if (!lua_isnumber(L, -1) || !lua_isnumber(L, -2))
	error(L, "RemoveTower: Received a call with faulty parameters.");
    int Who = lua_tonumber(L, -2);
    int Amount = lua_tonumber(L, -1);
    
    Who = GetAbsolutePlayer(Who); //GE: Relative to absolute conversion.
    
    Player[Who].t -= Amount;
    FrontendFunctions.Sound_Play(Damage);
    
    return 0;
}

//void RemoveWall(int Who, int Amount);
int L_RemoveWall (lua_State *L)
{
    if (!lua_isnumber(L, -1) || !lua_isnumber(L, -2))
	error(L, "RemoveWall: Received a call with faulty parameters.");
    int Who = lua_tonumber(L, -2);
    int Amount = lua_tonumber(L, -1);
    
    Who = GetAbsolutePlayer(Who); //GE: Relative to absolute conversion.
    
    if (Player[Who].w > 0)
    {
	Player[Who].w -= Amount;
	FrontendFunctions.Sound_Play(Damage);
    }
    
    return 0;
}

//int GetQuarry(int Who);
int L_GetQuarry (lua_State *L)
{
    if (!lua_isnumber(L, -1))
	error(L, "GetQuarry: Received a call with faulty parameters.");
    int Who = lua_tonumber(L, -1);
    
    Who = GetAbsolutePlayer(Who); //GE: Relative to absolute conversion.
    
    lua_pushnumber(L, Player[Who].q);
    
    return 1;
}

//int GetMagic(int Who);
int L_GetMagic (lua_State *L)
{
    if (!lua_isnumber(L, -1))
	error(L, "GetMagic: Received a call with faulty parameters.");
    int Who = lua_tonumber(L, -1);
    
    Who = GetAbsolutePlayer(Who); //GE: Relative to absolute conversion.
    
    lua_pushnumber(L, Player[Who].m);
    
    return 1;
}

//int GetDungeon(int Who);
int L_GetDungeon (lua_State *L)
{
    if (!lua_isnumber(L, -1))
	error(L, "GetDungeon: Received a call with faulty parameters.");
    int Who = lua_tonumber(L, -1);
    
    Who = GetAbsolutePlayer(Who); //GE: Relative to absolute conversion.
    
    lua_pushnumber(L, Player[Who].d);
    
    return 1;
}

//int GetBricks(int Who);
int L_GetBricks (lua_State *L)
{
    if (!lua_isnumber(L, -1))
	error(L, "GetBricks: Received a call with faulty parameters.");
    int Who = lua_tonumber(L, -1);

    Who = GetAbsolutePlayer(Who); //GE: Relative to absolute conversion.

    lua_pushnumber(L, Player[Who].b);

    return 1;
}

//int GetGems(int Who);
int L_GetGems (lua_State *L)
{
    if (!lua_isnumber(L, -1))
	error(L, "GetGems: Received a call with faulty parameters.");
    int Who = lua_tonumber(L, -1);

    Who = GetAbsolutePlayer(Who); //GE: Relative to absolute conversion.

    lua_pushnumber(L, Player[Who].g);

    return 1;
}

//int GetRecruits(int Who);
int L_GetRecruits (lua_State *L)
{
    if (!lua_isnumber(L, -1))
	error(L, "GetRecruits: Received a call with faulty parameters.");
    int Who = lua_tonumber(L, -1);

    Who = GetAbsolutePlayer(Who); //GE: Relative to absolute conversion.

    lua_pushnumber(L, Player[Who].r);

    return 1;
}

//int GetTower(int Who);
int L_GetTower (lua_State *L)
{
    if (!lua_isnumber(L, -1))
	error(L, "GetTower: Received a call with faulty parameters.");
    int Who = lua_tonumber(L, -1);
    
    Who = GetAbsolutePlayer(Who); //GE: Relative to absolute conversion.
    
    lua_pushnumber(L, Player[Who].t);
    
    return 1;
}

//int GetWall(int Who);
int L_GetWall (lua_State *L)
{
    if (!lua_isnumber(L, -1))
	error(L, "GetWall: Received a call with faulty parameters.");
    int Who = lua_tonumber(L, -1);
    
    Who = GetAbsolutePlayer(Who); //GE: Relative to absolute conversion.
    
    lua_pushnumber(L, Player[Who].w);
    
    return 1;
}

//void SetQuarry(int Who, int Amount);
int L_SetQuarry (lua_State *L)
{
    if (!lua_isnumber(L, -1) || !lua_isnumber(L, -2))
	error(L, "SetQuarry: Received a call with faulty parameters.");
    int Who = lua_tonumber(L, -2);
    int Amount = lua_tonumber(L, -1);
    
    Who = GetAbsolutePlayer(Who); //GE: Relative to absolute conversion.
    
    if (Player[Who].q < Amount)
	FrontendFunctions.Sound_Play(ResB_Up);
    else if (Player[Who].q > Amount)
	FrontendFunctions.Sound_Play(ResB_Down);
    
    Player[Who].q = Amount;
    
    return 0;
}

//void SetMagic(int Who, int Amount);
int L_SetMagic (lua_State *L)
{
    if (!lua_isnumber(L, -1) || !lua_isnumber(L, -2))
	error(L, "SetMagic: Received a call with faulty parameters.");
    int Who = lua_tonumber(L, -2);
    int Amount = lua_tonumber(L, -1);
    
    Who = GetAbsolutePlayer(Who); //GE: Relative to absolute conversion.
    
    if (Player[Who].m < Amount)
	FrontendFunctions.Sound_Play(ResB_Up);
    else if (Player[Who].m > Amount)
	FrontendFunctions.Sound_Play(ResB_Down);
    
    Player[Who].m = Amount;
    
    return 0;
}

//void SetWall(int Who, int Amount);
int L_SetWall (lua_State *L)
{
    if (!lua_isnumber(L, -1) || !lua_isnumber(L, -2))
	error(L, "SetWall: Received a call with faulty parameters.");
    int Who = lua_tonumber(L, -2);
    int Amount = lua_tonumber(L, -1);
    
    Who = GetAbsolutePlayer(Who); //GE: Relative to absolute conversion.
    
    if (Player[Who].w < Amount)
	FrontendFunctions.Sound_Play(Wall_Up);
    else if (Player[Who].w > Amount)
	FrontendFunctions.Sound_Play(Damage);
    
    Player[Who].w = Amount;
    
    return 0;
}

/**
 * Check whether the card the payer is attempting to play is playable.
 */ 
int CanPlayCard(int c, int bDiscarded)
{
    if (bDiscarded && D_getCursed(0,Player[turn].Hand[c]))
        return 0;     // Cursed cards like LodeStone can't be discarded

    if (bSpecialTurn && !bDiscarded) //GE: You're trying to play a card during a discard round. Bad.
       return 0;
       
    return 1;
}

/**
 * Functionality when playing a card.
 *
 * Plays the animation, handles the turn sequence, distributes resources
 *
 * Bugs: Should be split to different functions for readability.
 *
 * Authors: GreatEmerald, STiCK.
 * \param c Card ID.
 * \param discrd Whether to discard the card. It's used as a boolean.
 */
void PlayCard(int c,int discrd)
{
    int sound;
    int bGiveResources=0, i;

    //GE: You get resources when you use a card and next up is the enemy's turn.

    if (!CanPlayCard(c, discrd))
        return;

    sound=-1; //GE: What's this?..
    if (discrd)
    {
        if (!bSpecialTurn)
            nextturn=!turn;
        else
        {
            nextturn=turn;
            bSpecialTurn=0;
        }
    }
    else
        nextturn=Turn(&Player[turn],&Player[!turn],Player[turn].Hand[c],turn);
    if (nextturn == -1) //GE: If the card inits a discard turn.
    {
        bSpecialTurn=1;
        nextturn=turn;
    }
    if (turn != nextturn)
        bGiveResources = 1;
    
    PutCard(Player[turn].Hand[c]);
    if (bGiveResources) //GE: if you didn't put a play again card or you have discarded
    {
        Player[nextturn].b+=Player[nextturn].q; //GE: The enemy gets resources.
        Player[nextturn].g+=Player[nextturn].m;
        Player[nextturn].r+=Player[nextturn].d;
    }
    Player[turn].Hand[c]=GetCard();
    printf("We received a card: %d\n", Player[turn].Hand[c]); //GE: DEBUG
    lastturn=turn;
    turn=nextturn;

    RedrawScreenFull();
}

int Turn(struct Stats *s1,struct Stats *s2,int card,int turn)
{
	int next=!turn;

/*	switch (s1->Hand[card]>>8)
	{
		case 0:s1->b-=req[0][s1->Hand[card]&0xFF];break;
		case 1:s1->g-=req[1][s1->Hand[card]&0xFF];break;
		case 2:s1->r-=req[2][s1->Hand[card]&0xFF];break;
	}*/
	next=Deck(s1, s2, card, turn);

	normalize(s1);
	normalize(s2);
	return next;
}

/**
 * Evaluate game victory conditions.
 *
 * Authors: GreatEmerald, STiCK.
 *
 * \param a Player number.
 * \return An int that indicates whether the player in question has won the game.
 */
int Winner(int a)
{
    if (bOneResourceVictory)
        return (Player[a].t>=TowerVictory)||(Player[!a].t<=0)||
            (Player[a].b>=ResourceVictory)||(Player[a].g>=ResourceVictory)||(Player[a].r>=ResourceVictory);
    else
        return (Player[a].t>=TowerVictory)||(Player[!a].t<=0)||
            ((Player[a].b>=ResourceVictory)&&(Player[a].g>=ResourceVictory)&&(Player[a].r>=ResourceVictory));
}

char* CardName(int card)
{
	switch (card)
	{
		case 1:			return "Brick Shortage";
		case 2:			return "Lucky Cache";
		case 3:			return "Friendly Terrain";
		case 4:			return "Miners";
		case 5:			return "Mother Lode";
		case 6:			return "Dwarven Miners";
		case 7:			return "Work Overtime";
		case 8:			return "Copping the Tech";
		case 9:			return "Basic Wall";
		case 10:		return "Sturdy Wall";
		case 11:		return "Innovations";
		case 12:		return "Foundations";
		case 13:		return "Tremors";
		case 14:		return "Secret Room";
		case 15:		return "Earthquake";
		case 16:		return "Big Wall";
		case 17:		return "Collapse";
		case 18:		return "New Equipment";
		case 19:		return "Strip Mine";
		case 20:		return "Reinforced Wall";
		case 21:		return "Porticulus";
		case 22:		return "Crystal Rocks";
		case 23:		return "Harmonic Ore";
		case 24:		return "MondoWall";
		case 25:		return "Focused Designs";
		case 26:		return "Great Wall";
		case 27:		return "Rock Launcher";
		case 28:		return "Dragon's Heart";
		case 29:		return "Forced Labor";
		case 30:		return "Rock Garden";
		case 31:		return "Flood Water";
		case 32:		return "Barracks";
		case 33:		return "Battlements";
		case 34:		return "Shift";
		case (34)+1:	return "Quartz";
		case (34)+2:	return "Smoky Quartz";
		case (34)+3:	return "Amethys";
		case (34)+4:	return "Spell Weavers";
		case (34)+5:	return "Prism";
		case (34)+6:	return "Lodestone";
		case (34)+7:	return "Solar Flare";
		case (34)+8:	return "Crystal Matrix";
		case (34)+9:	return "Gemstone Flaw";
		case (34)+10:	return "Ruby";
		case (34)+11:	return "Gem Spear";
		case (34)+12:	return "Power Burn";
		case (34)+13:	return "Harmonic Vibe";
		case (34)+14:	return "Parity";
		case (34)+15:	return "Emerald";
		case (34)+16:	return "Pearl of Wisdom";
		case (34)+17:	return "Shatterer";
		case (34)+18:	return "Crumblestone";
		case (34)+19:	return "Sapphire";
		case (34)+20:	return "Discord";
		case (34)+21:	return "Fire Ruby";
		case (34)+22:	return "Quarry's Help";
		case (34)+23:	return "Crystal Shield";
		case (34)+24:	return "Empathy Gem";
		case (34)+25:	return "Diamond";
		case (34)+26:	return "Sanctuary";
		case (34)+27:	return "Lava Jewel";
		case (34)+28:	return "Dragon's Eye";
		case (34)+29:	return "Crystalize";
		case (34)+30:	return "Bag of Baubles";
		case (34)+31:	return "Rainbow";
		case (34)+32:	return "Apprentice";
		case (34)+33:	return "Lightning Shard";
		case (34)+34:	return "Phase Jewel";
		case (68)+1:	return "Mad Cow Disease";
		case (68)+2:	return "Faerie";
		case (68)+3:	return "Moody Goblins";
		case (68)+4:	return "Minotaur";
		case (68)+5:	return "Elven Scout";
		case (68)+6:	return "Goblin Mob";
		case (68)+7:	return "Goblin Archers";
		case (68)+8:	return "Shadow Faerie";
		case (68)+9:	return "Orc";
		case (68)+10:	return "Dwarves";
		case (68)+11:	return "Little Snakes";
		case (68)+12:	return "Troll Trainer";
		case (68)+13:	return "Tower Gremlin";
		case (68)+14:	return "Full Moon";
		case (68)+15:	return "Slasher";
		case (68)+16:	return "Ogre";
		case (68)+17:	return "Rabid Sheep";
		case (68)+18:	return "Imp";
		case (68)+19:	return "Spizzer";
		case (68)+20:	return "Werewolf";
		case (68)+21:	return "Corrosion Cloud";
		case (68)+22:	return "Unicorn";
		case (68)+23:	return "Elven Archers";
		case (68)+24:	return "Succubus";
		case (68)+25:	return "Rock Stompers";
		case (68)+26:	return "Thief";
		case (68)+27:	return "Stone Giant";
		case (68)+28:	return "Vampire";
		case (68)+29:	return "Dragon";
		case (68)+30:	return "Spearman";
		case (68)+31:	return "Gnome";
		case (68)+32:	return "Berserker";
		case (68)+33:	return "Warlord";
		case (68)+34:	return "Pegasus Lancer";
		default:		return "";
	}
}
