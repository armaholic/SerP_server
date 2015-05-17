#include "_main.hpp"

if (GVAR(AdjustingDistance)) then
{
	GVAR(AdjustingDistance) = false;

	player removeAction GVAR(MDist);
	player removeAction GVAR(MElev);
	
	GVAR(MDist) = player addAction [localize "STR_DBS_AMDist",
		_PREFIX_ + "_act_switch_distance.sqf", [], BASE_ACTION_PRIORITY + 8];
	GVAR(MElev) = player addAction [localize "STR_DBS_AMElev",
		_PREFIX_ + "_act_switch_elevation.sqf", [], BASE_ACTION_PRIORITY + 9];}
else
{
	GVAR(AdjustingDistance) = true;

	GVAR(AD_BegD) = GVAR(FortDistance);
	GVAR(AD_BegArc) =  ( asin ((player weaponDirection "") select 2) )
		* ADJUST_DISTANCE_MULT;

		
		
		
	player removeAction GVAR(MDist);
	player removeAction GVAR(MElev);
	
	GVAR(MDist) = player addAction [localize "STR_DBS_AMDist_Stop",
		_PREFIX_ + "_act_switch_distance.sqf", [], BASE_ACTION_PRIORITY + 18];
};