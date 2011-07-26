#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <SDL.h>
#include "cards.h"
#include "network.h"
#include "common.h"

char **names;

int Sound_Play(int which) //GE: Disable sound support for the server.
{
	return which;
}

#ifdef WIN32

#include <windows.h>

#define ID_LISTBOX 101
#define ID_BUTTON 102

HWND hwnd;
DWORD thrd1,thrd2;
HANDLE hThrd1,hThrd2;

void output(const char *fmt,...)
{
	Sound_Play(0);
	va_list args;
	static char buf[4096];

	va_start(args,fmt);
	vsnprintf(buf,4095,fmt,args);
	va_end(args);
	SendDlgItemMessage(hwnd, ID_LISTBOX, LB_ADDSTRING, 0, (LPARAM)buf);
}

LRESULT CALLBACK WndProc(HWND hwnd,UINT msg,WPARAM wParam,LPARAM lParam)
{
	switch (msg)
	{
		case WM_CLOSE:
		{
			PostQuitMessage(0);
			break;
		}
		case WM_COMMAND:
		{
			WORD wID = LOWORD(wParam);
			if (wID == ID_BUTTON)
				SendMessage(hwnd,WM_CLOSE,0,0);
			break;
		}
		
	}
	return DefWindowProc(hwnd,msg,wParam,lParam);
}

void CreateInterface()
{
	WNDCLASS wc;
	HINSTANCE hInstance;

	hInstance = (HINSTANCE)GetModuleHandle(NULL);
	wc.style = CS_HREDRAW | CS_VREDRAW | CS_OWNDC;
	wc.lpfnWndProc = (WNDPROC)WndProc;
	wc.cbClsExtra = 0;
	wc.cbWndExtra = 0;
	wc.hInstance = hInstance;
	wc.hIcon = LoadIcon(NULL, IDI_WINLOGO);
	wc.hCursor = LoadCursor(NULL, IDC_ARROW);
	wc.hbrBackground = (HBRUSH)(COLOR_BTNFACE+1);
	wc.lpszMenuName = NULL;
	wc.lpszClassName = "ArcoSrv";

	if (!RegisterClass(&wc))
	{
		MessageBox(NULL,"Failed To Register The Window Class.","Error",MB_OK|MB_ICONEXCLAMATION);
		return;
	}

	hwnd = CreateWindowEx(0,"ArcoSrv","Arcomage Server",WS_POPUPWINDOW|WS_CAPTION,300,300,400,304,NULL,NULL,hInstance,NULL);
	CreateWindowEx(0,"LISTBOX",0,WS_CHILD|WS_VISIBLE|WS_VSCROLL,8,8,376,224,hwnd,(HMENU)ID_LISTBOX,hInstance,NULL);
	CreateWindowEx(0,"BUTTON","Close",WS_CHILD|WS_VISIBLE,336,240,48,24,hwnd,(HMENU)ID_BUTTON,hInstance,NULL);

	ShowWindow(hwnd, SW_SHOW);
}

#endif

#if defined(linux) || defined(__APPLE__)

void output(const char *fmt,...)
{
	va_list args;
	static char buf[4096];

	va_start(args,fmt);
	vsnprintf(buf,4095,fmt,args);
	va_end(args);
	printf("%s\n",buf);
}

#endif

void QuitProc()
{
	Network_Quit();
	SDL_Quit();
}

void SendMetaData()
{
	char str[256];
	int i;

	InitDeck();

	for (i=0;i<102;i++)
		str[i]=GetCard()+1;
	str[102]=1;Send(str,103,1);
	str[102]=2;Send(str,103,2);
	Send(names[0],17,2);
	Send(names[1],17,1);
}

int DoServerCycle()
{
	char *s=NULL;
	static int p=0,t,d,turn,c;
	int ret;

	s=NULL;
	if (!Recv(&s,p+1)) ret = p+1; else ret = 0;
	t=s[0];d=s[1];turn=s[2];
	c=s[3]*256 + s[4];
	if (d)
		output("Player %d [%s] discards %s",p+1,names[p],CardName(c));
	else
		output("Player %d [%s] plays %s",p+1,names[p],CardName(c));
	Send(s,2,!p+1);
	p=turn;

	return ret;
}

#ifdef WIN32
unsigned long WINAPI DoServer()
#endif
#if defined(linux) || defined(__APPLE__)
int DoServer()
#endif
{
	int drop;
	unsigned long ip;

	output("Arcomage " ARCOVER " Server started");
	output("Waiting for players ...");

	names=(char**)malloc(sizeof(char*)*2);
	names[0]=(char*)malloc(sizeof(char)*17);
	names[1]=(char*)malloc(sizeof(char)*17);

	ip = WaitForClient(0,&names[0]);
	output("Player #1 [%s] connected from %d.%d.%d.%d",names[0],ip&0xFF,(ip>>8)&0xFF,(ip>>16)&0xFF,ip>>24);

	ip = WaitForClient(1,&names[1]);
	output("Player #2 [%s] connected from %d.%d.%d.%d",names[1],ip&0xFF,(ip>>8)&0xFF,(ip>>16)&0xFF,ip>>24);

	output("Game starting ...");

	SendMetaData();

	for (;;)
		if (drop = DoServerCycle())
		{
			output("Player #%d [%s] dropped connection.",drop,names[drop-1]);
			break;
		}

	output("Quitting");

	free(names[0]);
	free(names[1]);
	free(names);

#ifdef WIN32
	TerminateThread(hThrd1,0);
#endif

	return 0;
}

#ifdef WIN32

unsigned long WINAPI DoGUI()
{
	MSG msg;

	CreateInterface();

  	while (GetMessage(&msg,0,0,0))
	{
		if (msg.message==WM_QUIT) break;

		TranslateMessage(&msg);
		DispatchMessage(&msg);
  	}

	return 0;
}

#endif

int main(int argc,char **argv)
{

	atexit(QuitProc);

	srand((unsigned)time(NULL));

	SDL_Init(SDL_INIT_VIDEO|SDL_INIT_NOPARACHUTE);

	Network_Init();

	if (!CreateServer())
	{
		output("Cannot create server ...");
		return -1;
	}

	#ifdef linux

	DoServer();

	#endif

	#ifdef WIN32

	hThrd1 = CreateThread(NULL,0,DoGUI,NULL,0,NULL);
	hThrd2 = CreateThread(NULL,0,DoServer,NULL,0,&thrd2);
	WaitForSingleObject(hThrd1, INFINITE);
	TerminateThread(hThrd2,0);

	#endif

	return 0;

}
