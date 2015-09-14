#include "_main.hpp"

if (GVAR(AdjustingElevation)) then
{
	GVAR(AdjustingElevation) = false;

	player removeAction GVAR(MDist);
	player removeAction GVAR(MElev);
	
	GVAR(MDist) = player addAction [localize "STR_DBS_AMDist",
		_PREFIX_ + "_act_switch_distance.sqf", [], BASE_ACTION_PRIORITY + 8];
	GVAR(MElev) = player addAction [localize "STR_DBS_AMElev",
		_PREFIX_ + "_act_switch_elevation.sqf", [], BASE_ACTION_PRIORITY + 9];
}
else
{
	GVAR(AdjustingElevation) = true;

	GVAR(AE_BegEl) = GVAR(Elevation);
	GVAR(AE_BegArc) = ((player weaponDirection "") select 2) * GVAR(FortDistance);
	
	player removeAction GVAR(MDist);
	player removeAction GVAR(MElev);
	
	GVAR(MElev) = player addAction [localize "STR_DBS_AMElev_Stop",
		_PREFIX_ + "_act_switch_elevation.sqf", [], BASE_ACTION_PRIORITY + 19];
};