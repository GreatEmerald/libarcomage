#include "common.h"

#if defined(linux) || defined(__APPLE__) || defined(__DMC__)	// LINUX AND MACOS CODE BEGIN

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>

void FatalError(char *fmt,...)
{
	va_list args;
	va_start(args,fmt);
	printf(fmt);
	vfprintf(stderr,fmt,args);
	fprintf(stderr,"\n");
	va_end(args);
	exit(3);
}

void OpenWebLink(char *web)
{
	char cmdline[128];
	snprintf(cmdline,128,"./browser %s",web);
	system(cmdline);
}

//#endif	// LINUX CODE END

#elif defined(WIN32)	// WINDOWS CODE BEGIN

#include <stdio.h>
#include <stdarg.h>
#include <windows.h>

void FatalError(char *fmt,...)
{
	static char buf[1024];
	va_list args;
	va_start(args,fmt);
	vsnprintf(buf,1023,fmt,args);
	MessageBox(NULL,buf,"Error",MB_OK|MB_ICONEXCLAMATION);
	va_end(args);
	exit(3);
}

void OpenWebLink(char *web)
{
	ShellExecute(0,"open",web,NULL,NULL,SW_SHOWNORMAL);
}

#endif	// WINDOWS CODE END
