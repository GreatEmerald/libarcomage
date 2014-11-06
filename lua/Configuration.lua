--[[ This is the configuration file for Arcomage Clone. You can think of it as
     an INI file, but with commenting capabilities! Please note that in case you
     invalidate options, you will have to download this file anew from the
     Arcomage Clone Git repository or the binary release.
--]]

math.randomseed( os.time() ) -- Keep this line if you want to use math.random()

Fullscreen = false -- Whether the program is running in fullscreen or windowed mode.
ResolutionX = 800 -- Window resolution. Relevant only to graphical frontends.
ResolutionY = 600 -- Window resolution. Relevant only to graphical frontends.
FontMin = 9 -- Minimum font size for cards. Set to 0 to not set one.
FrameDelay = 16 -- Time to wait between frames, in ms. FPS = 1000/FrameDelay. More saves energy, less is smoother.
SoundEnabled = true -- Whether the sound system is enabled. This might not be relevant to certain frontends.
CardTranslucency = 96 -- The amount of translucency applied to inactive cards. The range is 0-255.
CardsInHand = 6 -- The amount of cards each player gets at the start of the game. The sane range is 4-8 (more works, but may not fit).
HiddenCards = true -- Whether the opponent cards should be visible or not.

TowerLevels = math.random(10, 50) -- The height of the tower and wall that the players start out with.
WallLevels = math.random(5, 50)

QuarryLevels = math.random(1, 5) -- The amount of facilities that the players start out with.
MagicLevels = math.random(1, 5)
DungeonLevels = math.random(1, 5)

BrickQuantities = math.random(5, 25) -- The amount of resources that the players start out with.
GemQuantities = math.random(5, 25)
RecruitQuantities = math.random(5, 25)

MaxWall = 200 -- The maximum allowed wall height.
TowerVictory = math.max(TowerLevels+10, math.random(30, 200)) -- The height of the tower a player must reach to win.
ResourceVictory = math.random(100, 500) -- The amount of resources a player must gather to win.
OneResourceVictory = false -- Whether to allow victory for getting only one of the resources to the amount indicated above.

UseOriginalMenu = false -- Whether to use the original Arcomage menu appearance. You need to own the original Arcomage for this.
UseOriginalCards = false -- Whether to use the original Arcomage card appearance. You need to own the original Arcomage or one of the Might and Magic games for this.

DataDir = "" -- Path to the Arcomage image and sound data directory. This is relative to the path of the frontend executable. If empty, assumed '../data/'. Only relevant to GUIs.
