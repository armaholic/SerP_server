#include "_main.hpp"
#define DEFAULT_DIST 2

GVAR(AllForts) =
[
    // title name, object name, cost, on land only, min distance, initial damage
	["Мешки с песком", "Land_BagFence_Long_F", 1, false, DEFAULT_DIST, 0],
	["Мешки с песком (короткий)", "Land_BagFence_Short_F", 0.5, false, DEFAULT_DIST, 0],
	["Мешки с песком (полукруг)", "Land_BagFence_Round_F", 1, false, DEFAULT_DIST, 0],
//	["Мешки с песком (концевой)", "Land_BagFence_End_F", 0.3, false, DEFAULT_DIST, 0],
	["Большой бункер", "Land_BagBunker_Large_F", 24, true, 8, 0],
	["Маленький бункер", "Land_BagBunker_Small_F", 3.5, true, 4, 0],
	["Сторожевая башня", "Land_BagBunker_Tower_F", 32, true, 8, 0],	
//	["Противотанковые препятствия", "Hhedgehog_concreteBig", 12, true, 4, 0],	
//	["Земляной вал", "MAP_fort_rampart", 5, true, 4, 0.91],
//	["Земляной вал (полукруг)", "Land_fort_artillery_nest_EP1", 12, true, 10, 0],
	["H-барьер 5", "Land_HBarrier_5_F", 3.5, false, 3, 0],
	["H-барьер 3", "Land_HBarrier_3_F", 2.2, false, 3, 0],
	["H-барьер 1", "Land_HBarrier_1_F", 1, false, 3, 0]
//	["H-барьер большой", "Land_HBarrier_large", 7, true, 3, 0],
//	["Колючая проволока", "Fort_RazorWire", 1, false, DEFAULT_DIST, 0]
//	["Камуфляжная сеть (полузакрытая)", "Land_CamoNet_EAST_EP1", 4, false, 10, 0],
//	["Камуфляжная сеть (открытая)", "Land_CamoNetVar_EAST_EP1", 3.5, false, 10, 0],
//	["Камуфляжная сеть (закрытая)", "Land_CamoNetB_EAST_EP1", 5, false, 10, 0]
	





];





GVAR(SideList) = [];

{
	GVAR(SideList) = GVAR(SideList) +
		[[_x,
			"Мешки с песком",
			"Мешки с песком (короткий)",
			"Мешки с песком (полукруг)",
			"Большой бункер",
			"Маленький бункер",
			"H-барьер 5",
			"H-барьер 3",
			"H-барьер 1"
		]];
} forEach [west, east, resistance, civilian];