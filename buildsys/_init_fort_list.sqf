#include "_main.hpp"

[] call compile preprocessFileLineNumbers (_PREFIX_ + "fortifications_list.sqf");

GVAR(AvFortList) = [];


PV(_i) = 0; 
PV(_j) = 0;

for "_i" from 0 to ((count GVAR(SideList)) - 1) do
{
	PV(_sl) = GVAR(SideList) select _i;
	
	if (_sl select 0 == playerSide) then
	{
	
		for "_j" from 1 to ((count _sl) - 1) do
		{
			{
				if(FDA_TITLE(_x) == (_sl select _j)) exitWith{_sl set [_j, _x];};
			} forEach GVAR(AllForts);	
			
			if (typeName (_sl select _j) != "ARRAY") then
			{
				_sl set [_j, -1];
			};
		};
				
		GVAR(AvFortList)  = (_sl - [-1]) - [playerSide];
	};
};