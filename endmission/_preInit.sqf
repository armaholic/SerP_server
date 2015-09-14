SerP_processorEND = {
	SerP_endMission = {};
	_message = _this select 0;
	["SerP_message",["",_message]] call BIS_fnc_showNotification;
	_toRPT = [];
	{_toRPT set [count _toRPT,format ["Alive at side %1: %2",_x,_x countSide playableUnits]]} forEach [east,west,resistance,civilian];
	_toRPT set [count _toRPT,"SerP Group states:"];
	{
		_group = _x select 0;
		_units = _x select 1;
		_alive = {alive (_x select 1);} count _units;
		_toRPT set [count _toRPT,format ["%1 (%2/%3)",_group, _alive,count _units]];
	} forEach SerP_allUnits;
	_toRPT set [count _toRPT,"SerP Unit states:"];
	{
		_toRPT set [count _toRPT,format ["Group: %1",_x select 0]];
		_toRPT set [count _toRPT,"Name:			Lifestate:	Weapons:"];
		{
			_wpnStr = "";
			{
				_weapon = (configFile >> "cfgWeapons" >> _x);
				if ((getNumber(_weapon >> "type") in [1,4,5])&&!isNil{(getArray(_weapon >> "magazines") select  0)}) then {
					_wpnStr = _wpnStr + _x + " ";
				};
			} forEach weapons(_x select 1);
			_toRPT set [count _toRPT, format ['%1		%2		%3', _x select 0,lifeState(_x select 1),_wpnStr]];
		} forEach (_x select 1);
	} forEach SerP_allUnits;
	_toRPT set [count _toRPT, "Vehicles:"];
	_toRPT set [count _toRPT,"Type:	Position:	Damage:	Crew:"];
	{
		_pos = getPos _x; _pos = [round(_pos select 0),round(_pos select 1),round(_pos select 2)];
		_crew = crew _x;
		{_crew set [_forEachIndex,name _x]} forEach _crew;
		_toRPT set [count _toRPT, format ['%1		%2		%3		%4',getText(configFile >> "cfgVehicles" >> typeOf(_x) >> "DisplayName"),_pos,damage _x, _crew]];
	} forEach (allMissionObjects "Plane")+(allMissionObjects "LandVehicle")+(allMissionObjects "Helicopter")+(allMissionObjects "Ship");
	[_message,_toRPT] spawn {
		_message = _this select 0;
		_toRpt = _this select 1;
		_toDebriefing = "";
		{
			_x call SerP_log;
			_toDebriefing = _toDebriefing + _x + "<br />";
		} forEach _toRpt;
		missionNamespace setVariable ["SerP_statistics",_toDebriefing];
		(vehicle player) enableSimulation false;
		"" call BIS_fnc_endMission;
	};
};

SerP_endMission = {
	_title = _this select 0;
	if (count(_this)==1) then {
		SerP_end = [_title,true];
		publicVariable "SerP_end";
	};
	_title = switch toLower(_title) do {
		case "redfor_win": {format [localize "STR_SerP_winCall", SerP_titleREDFOR]};
		case "bluefor_win": {format [localize "STR_SerP_winCall", SerP_titleBLUEFOR]};
		case "redfor_retreat": {format [localize "STR_SerP_deadCall", SerP_titleREDFOR]};
		case "bluefor_retreat": {format [localize "STR_SerP_deadCall", SerP_titleBLUEFOR]};
		case "end_admin": {localize "STR_SerP_missionEndAdmin"};
		default {_title};
	};
	tu_log_mission_message pushback _title;
	[_title] call SerP_processorEND;
	tu_log_endMission = true;
};


_isEndMissionAdminAvailable = {
	(((serverCommandAvailable "#kick")||isServer) && SerP_warbegins == 1)
};
["End mission (Admin)", 0, {["end_admin"] call SerP_endMission;},_isEndMissionAdminAvailable, _isEndMissionAdminAvailable] call SerP_addToMenu;

SerP_endMissionCapture = compile preprocessFileLineNumbers "SerP\endmission\capture.sqf";

