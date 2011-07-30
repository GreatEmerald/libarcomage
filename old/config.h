#ifndef _CONFIG_H_
#define _CONFIG_H_ 1

int /*config*/ fullscreen; ///< Fullscreen configuration, handled by minIni.
int /*config*/ soundenabled; ///< Sound configuration, handled by minIni.
int /*config*/ TowerLevels; ///< Starting tower levels, handled by minIni.
int /*config*/ WallLevels; ///< Starting wall levels, handled by minIni.
int /*config*/ QuarryLevels; ///< Starting quarry levels, handled by minIni.
int /*config*/ MagicLevels; ///< Starting magic levels, handled by minIni.
int /*config*/ DungeonLevels; ///< Starting dungeon levels, handled by minIni.
int /*config*/ BrickQuantities;///< Starting brick amount, handled by minIni.
int /*config*/ GemQuantities; ///< Starting gem amount, handled by minIni.
int /*config*/ RecruitQuantities; ///< Starting recruit amount, handled by minIni.
int /*config*/ TowerVictory; ///< Tower victory condition, handled by minIni.
int /*config*/ ResourceVictory; ///< Resource victory condition, handled by minIni.
int /*config*/ bOneResourceVictory;///< Allow victory for getting only one of the resources to required level, handled by minIni.
int /*config*/ CardTranslucency;///< Controls the level of alpha channel on the inactive cards, handled by minIni.

void ReadConfig();

#endif 
