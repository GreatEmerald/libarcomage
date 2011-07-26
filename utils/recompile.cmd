@ECHO OFF
cd ..\d\utils
call compileD.cmd
cd ..\..\src
dmc minIni.c arco.c common.c cards.c graphics.c input.c network.c sound.c BFont.c ..\lib\SDL.lib ..\lib\SDL_image.lib ..\lib\SDL_net.lib ..\lib\SDL_mixer.lib ..\lib\lua51.lib ..\lib\ArcomageD.lib ..\lib\phobos.lib -I..\include -o..\bin\win32\Arcomage.exe
pause
del *.obj
del *.map
echo Rebuild is complete. The new binaries are stored in /bin/win32.
pause