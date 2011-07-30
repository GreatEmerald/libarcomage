#ifndef _NETWORK_H_
#define _NETWORK_H_ 1

void Network_Init();
void Network_Quit();
int CreateServer();
unsigned long WaitForClient(int i,char **name);
char *ConnectToServer(char *host);
int Send(char *data,int len,int to);
int Recv(char **data,int from);

#endif
