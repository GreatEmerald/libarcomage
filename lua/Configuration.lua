--[[ This is the configuration file for Arcomage Clone. You can think of it as
     an INI file, but with commenting capabilities! Please note that in case you
     invalidate options, you will have to download this file anew from the
     Arcomage Clone Git repository or the binary release.
--]]

Fullscreen = false -- Whether the program is running in fullscreen or windowed mode.
SoundEnabled = true -- Whether the sound system is enabled. This might not be relevant to certain frontends.
CardTranslucency = 64 -- The amount of translucency applied to inactive cards. The range is 0-255.

TowerLevels = 20 -- The height of the tower and wall that the players start out with.
WallLevels = 10

QuarryLevels = 1 -- The amount of facilities that the players start out with.
MagicLevels = 1
DungeonLevels = 1

BrickQuantities = 15 -- The amount of resources that the players start out with.
GemQuantities = 15
RecruitQuantities = 15

TowerVictory = 200 -- The height of the tower a player must reach to win.
ResourceVictory = 500 -- The amount of resources a player must gather to win.
OneResourceVictory = false -- Whether to allow victory for getting only one of the resources to the amount indicated above.
