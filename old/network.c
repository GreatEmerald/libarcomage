#include <string.h>
#include <SDL.h>
#include <SDL_net.h>
#include "network.h"
#include "common.h"

#define PORT 0xA0AE // .RC.M.G.

TCPsocket server=NULL,client[2]={NULL,NULL};
IPaddress ip,*rip;

void Network_Init()
{
	SDLNet_Init();
}

void Network_Quit()
{
	if (client[0]) SDLNet_TCP_Close(client[0]);client[0]=NULL;
	if (client[1]) SDLNet_TCP_Close(client[1]);client[1]=NULL;
	if (server) SDLNet_TCP_Close(server);server=NULL;
	SDLNet_Quit();
}

int CreateServer()
{
	if (SDLNet_ResolveHost(&ip,NULL,PORT)==-1) return 0;
	server=SDLNet_TCP_Open(&ip);
	if (!server) return 0;
	return 1;
}

unsigned long WaitForClient(int i,char **name)
{
	char *s,*msg="ARCOMAGE v" ARCOVER;

	if (i!=0 && i!=1) return 0;

	while (!client[i])
	{
		client[i]=SDLNet_TCP_Accept(server);
		SDL_Delay(CPUWAIT*10);
	}
	rip=SDLNet_TCP_GetPeerAddress(client[i]);
	Send(msg,15,i+1);
	Recv(&s,i+1);
	strcpy(*name,s);

	return rip -> host;
}

char *ConnectToServer(char *host)
{
	static char buf[4096];

	if (SDLNet_ResolveHost(&ip,host,PORT)==-1)
	{
		snprintf(buf,4096,"Cannot resolve host '%s' !",host);
		return buf;
	}
	server=SDLNet_TCP_Open(&ip);
	if (!server)
	{
		snprintf(buf,4096,"Cannot connect to\n\n%d.%d.%d.%d:%d",ip.host&0xFF,(ip.host>>8)&0xFF,(ip.host>>16)&0xFF,ip.host>>24,PORT);
		return buf;
	}
	return NULL;
}

int Send(char *data,int len,int to)
{
	static char buf[128];

	memset(buf,0,128);
	if (len>128) len=128;
	memcpy(buf,data,len);
	
	switch (to)
	{
		case 0:
			return (SDLNet_TCP_Send(server,buf,128)==128);
		case 1:
		case 2:
			return (SDLNet_TCP_Send(client[to-1],buf,128)==128);
		default:
			return 0;
	}
}

int Recv(char **data,int from)
{
	int res;
	static char buf[128];

	switch (from)
	{
		case 0:
			res=SDLNet_TCP_Recv(server,buf,128);
			*data=buf;
			return (res>0);
		case 1:
		case 2:
			res=SDLNet_TCP_Recv(client[from-1],buf,128);
			*data=buf;
			return (res>0);
		default:
			return 0;
	}
}
