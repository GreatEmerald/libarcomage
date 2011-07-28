@ECHO OFF
REM cd ..\d\utils
REM call compileD.cmd
REM cd ..\..\src
cd ..\src
dmc -WD minIni.c arco.c common.c cards.c network.c ..\lib\SDL.lib ..\lib\SDL_image.lib ..\lib\SDL_net.lib ..\lib\SDL_mixer.lib ..\lib\lua51.lib ..\lib\ArcomageD.lib ..\lib\phobos.lib -I..\include -o..\bin\win32\Arcomage.exe
pause
del *.obj
del *.map
echo Rebuild is complete. The new binaries are stored in /bin/win32.
pause