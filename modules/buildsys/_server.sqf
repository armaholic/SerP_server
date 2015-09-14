#include "_main.hpp"
#include "settings.hpp"


RC_DEFINE(SRequireBP) = {
	PV(_pl) = _this select 0;
	PV(_bp) = _this select 1;
	PV(_gr) = group _pl;	
	PV(_r) = false;

	if (!isNull _gr) then {
		_gr setVariable [GROUP_BP_POINTS_VARIABLE, (_gr getVariable [GROUP_BP_POINTS_VARIABLE , 0]) - _bp ];
		
		if (_gr getVariable [GROUP_BP_POINTS_VARIABLE , 0] < 0) then {
			_gr setVariable [GROUP_BP_POINTS_VARIABLE, (_gr getVariable [GROUP_BP_POINTS_VARIABLE , 0]) + _bp ];
			_r = false;
		} else {
			_gr setVariable [GROUP_BP_POINTS_VARIABLE, _gr getVariable [GROUP_BP_POINTS_VARIABLE , 0], true];
			_r = true;
		};			
	};

	if (!isDedicated && _pl == player) then {
		_r call RC_FUNC(CRequireBP_Response);
	} else {
		if (owner _pl > 2) then {
			#define RC_EXEC_ARG _r
			RC_EXEC_C(CRequireBP_Response, owner _pl);
		};
	};
};
RC_INIT_EH(SRequireBP);
	
// tushino specific: turn off building after mission begin

[] spawn {
	waitUntil {sleep 1;!isNil{Serp_warbegins}};
	waitUntil {sleep 1;Serp_warbegins==1};
	
	PV(_bt) = diag_tickTime;
	waitUntil {
		sleep 1;
		diag_tickTime > _bt + BS_POST_WARBEGIN_TIMEOUT;// wait additional 3 minutes after warbegins
	};

	GVAR(BuildingMode) = false;
	GVAR(BuildSysEnabled) = false;
	
	GVAR(BuildSysTimeout) = true;
	publicVariable 'GVAR(BuildSysTimeout)';
};