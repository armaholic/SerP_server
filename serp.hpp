#include "serp_gui.hpp"
#include "modules\buildsys\config.hpp"
//#include "modules\viewdistance\dialog.hpp"

class CfgFunctions
{
	class SerP
	{
		tag = "serp";
		class Init
		{
			class preInit {
				file = "\SerP\serp_preInit.sqf";
				preInit = 1;
				postInit = 0;
				recompile = 1;
			};
			class postInit {
				file = "\SerP\serp_postInit.sqf";
				preInit = 0;
				postInit = 1;
				recompile = 1;
			};
		};
	};
	
	// CH View Distance Script
	// Author: champ-1
	// https://forums.bistudio.com/topic/175554-ch-view-distance-script/
/*	class CHVD
	{
		tag = "viewdistance";
		class script
		{
			file = "\SerP\modules\viewdistance";
			class onCheckedChanged {};
			class onSliderChange {};
			//class onLBSelChanged {};
			class onEBinput {};
			//class onEBterrainInput {};
			//class selTerrainQuality {};
			//class updateTerrain {};
			class updateSettings {};
			class openDialog {};
			class localize {};
			class init {postInit = 1;};
		};
	};*/
};
class CfgDebriefingSections
{
	class SerP_statistics
	{
		title = "Statistics";
		variable = "SerP_statistics";
	};
};
