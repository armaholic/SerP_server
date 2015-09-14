#include "serp_gui.hpp"
#include "modules\buildsys\config.hpp"

class CfgFunctions
{
	class SerP
	{
		class Init
		{
			file = "SerP";
			class preInit {
				preInit = 1;
				postInit = 0;
				recompile = 1;
			};
			class postInit {
				preInit = 0;
				postInit = 1;
				recompile = 1;
			};
		};
	};
};
class CfgDebriefingSections
{
	class SerP_statistics
	{
		title = "Statistics";
		variable = "SerP_statistics";
	};
};