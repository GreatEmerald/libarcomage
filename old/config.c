/**
 * Configuration support handling.
 * This class should interface directly with minIni. Scheduled to be replaced
 * by D code and integrated into libarcomage.
 */

#include "common.h"

int /*config*/ fullscreen=0; ///< Fullscreen configuration, handled by minIni.
int /*config*/ soundenabled=1; ///< Sound configuration, handled by minIni.
int /*config*/ TowerLevels=20; ///< Starting tower levels, handled by minIni.
int /*config*/ WallLevels=10; ///< Starting wall levels, handled by minIni.
int /*config*/ QuarryLevels=1; ///< Starting quarry levels, handled by minIni.
int /*config*/ MagicLevels=1; ///< Starting magic levels, handled by minIni.
int /*config*/ DungeonLevels=1; ///< Starting dungeon levels, handled by minIni.
int /*config*/ BrickQuantities=15;///< Starting brick amount, handled by minIni.
int /*config*/ GemQuantities=15; ///< Starting gem amount, handled by minIni.
int /*config*/ RecruitQuantities=15; ///< Starting recruit amount, handled by minIni.
int /*config*/ TowerVictory=200; ///< Tower victory condition, handled by minIni.
int /*config*/ ResourceVictory=500; ///< Resource victory condition, handled by minIni.
int /*config*/ bOneResourceVictory=0;///< Allow victory for getting only one of the resources to required level, handled by minIni.
int /*config*/ CardTranslucency=64;///< Controls the level of alpha channel on the inactive cards, handled by minIni.

/**
 * minIni initialisation.
 *
 * Bugs: Does not read long lines.
 *
 * Authors: GreatEmerald.
 */
void ReadConfig()
{
    fullscreen=ini_getl("Engine", "Fullscreen", 0, CONFIGFILE);
    soundenabled=ini_getl("Engine", "SoundEnabled", 1, CONFIGFILE);

    TowerLevels=ini_getl("StartingConditions", "TowerLevels", 20, CONFIGFILE);
    WallLevels=ini_getl("StartingConditions", "WallLevels", 10, CONFIGFILE);
    QuarryLevels=ini_getl("StartingConditions", "QuarryLevels", 1, CONFIGFILE);
    MagicLevels=ini_getl("StartingConditions", "MagicLevels", 1, CONFIGFILE);
    DungeonLevels=ini_getl("StartingConditions", "DungeonLevels", 1, CONFIGFILE);
    BrickQuantities=ini_getl("StartingConditions", "BrickQuantities", 15, CONFIGFILE);
    GemQuantities=ini_getl("StartingConditions", "GemQuantities", 15, CONFIGFILE);
    RecruitQuantities=ini_getl("StartingConditions", "RecruitQuantities", 15, CONFIGFILE);
    TowerVictory=ini_getl("VictoryConditions", "TowerVictory", 200, CONFIGFILE);
    ResourceVictory=ini_getl("VictoryConditions", "ResourceVictory", 500, CONFIGFILE);
    bOneResourceVictory=ini_getl("VictoryConditions", "bOneResourceVictory", 0, CONFIGFILE);

    CardTranslucency=ini_getl("Graphics", "CardTranslucency", 64, CONFIGFILE);
}
