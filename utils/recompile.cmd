@ECHO OFF
REM cd ..\d\utils
REM call compileD.cmd
REM cd ..\..\src
cd ..\src
dmc -lib minIni.c arco.c common.c cards.c network.c config.c ..\lib\SDL.lib ..\lib\SDL_image.lib ..\lib\SDL_net.lib ..\lib\SDL_mixer.lib ..\lib\lua51.lib ..\lib\ArcomageD.lib ..\lib\phobos.lib -I..\include -o..\lib\arcomage.lib
pause
del *.obj
del *.map
echo Rebuild is complete. The new library is stored in libarcomage/arcomage.lib.
pause