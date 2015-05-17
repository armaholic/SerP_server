#include "_main.hpp"

createDialog "SerpMod_BuildSys_FortTypeDialog";

PV(_tbp) = (group player) getVariable [GROUP_BP_POINTS_VARIABLE, 0];

{
	PV(_t) = format["%1  /  %2  (x%3)", FDA_COST(_x), _tbp, floor (_tbp / FDA_COST(_x))];
	
	if (FDA_LANDONLY(_x)) then
	{
		_t = _t + " (L)";
	};
	
	
	PV(_t2) = toArray(_t);
	// add padding
	for "_i" from (count _t2) to 30 do
	{
		_t = _t + " ";
	};
	

	lbAdd [1,  _t + FDA_TITLE(_x)];
	
} forEach GVAR(AvFortList);