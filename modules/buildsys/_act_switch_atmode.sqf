#include "_main.hpp"

if (GVAR(AtLandMode)) then
{
	GVAR(AtLandMode) = false;
	GVAR(Elevation) = 0;
	
	
	player removeAction GVAR(MLand);
	GVAR(MLand) = player addAction [localize 'STR_DBS_AMLand_LM',
		_PREFIX_ + "_act_switch_atmode.sqf", [], BASE_ACTION_PRIORITY + 7];	
}
else
{
	GVAR(AtLandMode) = true;
        GVAR(Elevation) = 0;
	
	player removeAction GVAR(MLand);
	GVAR(MLand) = player addAction [localize 'STR_DBS_AMLand_BM',
		_PREFIX_ + "_act_switch_atmode.sqf", [], BASE_ACTION_PRIORITY + 7];
};