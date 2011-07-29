#ifndef _COMMON_H_
#define _COMMON_H_ 1

#define CPUWAIT 10
#define ARCOVER "0.4.0"

#ifdef MSVC
	#define vsnprintf _vsnprintf
	#define inline __inline
#endif

#ifdef __DMC__ //GE: Digital Mars C compiler support.
    #define snprintf _snprintf
#endif

	void FatalError(char *fmt,...);
	void OpenWebLink(char *web);

  enum SoundTypes
  {
    Shuffle,
    Damage,
    ResB_Up,
    ResB_Down,
    ResS_Up,
    ResS_Down,
    Tower_Up,
    Wall_Up
  };

  struct FrontendFunctions
  {
    void (*Sound_Play)(enum SoundTypes);
    void (*RedrawScreenFull)();
  }FrontendFunctions;
  
  void DecoySoundPlay(enum SoundTypes);

#ifdef linux
	#define OPERATINGSYSTEM 1
	#define CONFIGFILE "arcomage.cfg"
	#define ARCODATADIR "data/"
	//#define CONFIGFILE "~/.config/arcomage.cfg"
	//#define ARCODATADIR "/usr/share/arcomage/"
#endif

#ifdef WIN32
	#define OPERATINGSYSTEM 2
	#define CONFIGFILE ".\\arcomage.cfg"
	#define ARCODATADIR "data/"
#endif

#ifdef __APPLE__
	#define OPERATINGSYSTEM 3
	#define CONFIGFILE "~/.config/arcomage.cfg"
	#define ARCODATADIR "data/"
#endif

#if !defined(linux) && !defined(WIN32) && !defined(__APPLE__)

#error Arcomage has been compiled and tested only under Windows, Linux and Mac OS
#error It would take some effort to compile on other platforms

#endif

#endif
