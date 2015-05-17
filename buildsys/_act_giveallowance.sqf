#include "_main.hpp"

createDialog "SerpMod_BuildSys_BuildAllowanceDialog";


GVAR(GADPlayerList) = [];

{
	if ( (group _x == group player) && (_x != player) &&
		(!(_x getVariable [PLAYER_BUILDING_ALLOWANCE_VARIABLE, false])) ) then
	{
		GVAR(GADPlayerList) set [lbAdd [1,  name _x], _x];
	};
} forEach playableUnits;

if ((count GVAR(GADPlayerList)) == 0) then
{
	GVAR(EmptyListForAllowance) = true;
};