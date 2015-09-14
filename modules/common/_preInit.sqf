
SerP_isCrew = compile preprocessFileLineNumbers "SerP\modules\common\isCrew.sqf";

call compile preprocessFileLineNumbers "SerP\modules\common\markers.sqf";
call compile preprocessFileLineNumbers "SerP\modules\common\message.sqf";

call compile preprocessFileLineNumbers "SerP\modules\common\menu.sqf";

//костыль против версии 1.44, работоспособность не гарантирую - bn_
if (!isNil "paramsArray") then {
	call compile preprocessFileLineNumbers "SerP\modules\common\setMissionConditions.sqf";
	diag_log "!isNil paramsArray";
} else {
	diag_log "isNil paramsArray";
	[]spawn {
		waitUntil {sleep 0.1; !isNil "paramsArray"};
		diag_log "waitUntil !isNil paramsArray";
		if (isServer) then {call SerP_processParams;};
		call compile preprocessFileLineNumbers "SerP\modules\common\setMissionConditions.sqf";
	}
};

