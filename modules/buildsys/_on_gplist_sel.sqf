#include "_main.hpp"

(GVAR(GADPlayerList) select (_this select 1)) setVariable [PLAYER_BUILDING_ALLOWANCE_VARIABLE, true, true];


if ((count GVAR(GADPlayerList)) <= 1) then {
	GVAR(EmptyListForAllowance) = true;
};

closeDialog 0;
