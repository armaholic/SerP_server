if (!(call compile preprocessFileLineNumbers "SerP\serp_launchCondition.sqf")) exitWith {};

if (!isDedicated) then {call SerP_processParams;};//paramsArray only available on postInit on client
"postInit start" call SerP_debug;
{
	("postInit " + _x + " start") call SerP_debug;
	call compile preprocessFileLineNumbers ("SerP\modules\" + _x + "\_postInit.sqf");
	("postInit " + _x + " end") call SerP_debug;
} forEach SerP_modules;

_AI_processor = {
	_this setBehaviour "CARELESS";
	_this allowFleeing 0;
	_this disableAI "AUTOTARGET";
	_this disableAI "PATHPLAN";
	//_this setCombatMode "BLUE";
	_this doWatch objNull;
	_this disableAI "MOVE";
	_this stop true;
	_this setVariable ["BIS_noCoreConversations", false];
};

{
	_x call _AI_processor;
} forEach playableUnits;
