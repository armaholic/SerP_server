if (isServer) then {
	[] call compile preprocessFileLineNumbers "SerP\modules\freeztime\startmission_server.sqf";
};

if (!isDedicated) then {
	[] spawn compile preprocessFileLineNumbers "SerP\modules\freeztime\startmission_client.sqf";
};