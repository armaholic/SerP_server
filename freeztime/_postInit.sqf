if (isServer) then {
	[] call compile preprocessFileLineNumbers "SerP\freeztime\startmission_server.sqf";
};

if (!isDedicated) then {
	[] spawn compile preprocessFileLineNumbers "SerP\freeztime\startmission_client.sqf";
};