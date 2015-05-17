private ["_unitside"];
_unitside = side group player;
_JIP = (time>10);
_version = getNumber(missionConfigFile >> "SerP_version");
if (_version==0) then {
	_version = getText(missionConfigFile >> "SerP_version");
}else{
	_version = "v"+str(_version);
};
_cred = player createDiaryRecord ["diary", [localize "STR_SerP_credits_title",format ["%1 <br/>SerP %2",localize "STR_SerP_credits",_version]]];
//отобразит игроков стороны в отрядах
_grpText = "";
{
	if (side(_x) == _unitside) then {
		_units = units _x;
		_markerName = SerP_startposMarkerPrefix+str _x;
		_tmpText = "<br/>" + (if (_JIP) then {str _x}else{"<marker name = '"+_markerName+"'>"+str _x+"</marker>"});

		{
			if ((alive _x)&&((isPlayer _x)||isServer)) then {
				_tmpText = _tmpText + "<br/>--  " + (name _x);
				{
					_weapon = (configFile >> "cfgWeapons" >> _x);
					if ((getNumber(_weapon >> "type") in [1,4,5])&&!isNil{(getArray(_weapon >> "magazines") select  0)}) then {
						_tmpText = _tmpText + "  -  " + getText(_weapon >> "displayName");
					};
				} forEach weapons(_x);
			};
		} forEach _units;
		if (!_JIP) then {
			_grpText = _grpText + _tmpText + "<br/>";
		};
	};
} forEach allGroups;

_groups = player createDiaryRecord ["diary", [localize "STR_SerP_groups_title",_grpText]];

//условности, одни на всех
if (localize "STR_SerP_convent" != "") then {_cond = player createDiaryRecord ["diary", [localize "STR_SerP_convent_title",localize "STR_SerP_convent"]];};
//погода из настроек миссии

_hour = date select 3;
_time = switch true do {
	case (_hour>=21||_hour<4): {localize "STR_SerP_timeOfDay_Option7"};
	case (_hour<5): {localize "STR_SerP_timeOfDay_Option0"};
	case (_hour<8): {localize "STR_SerP_timeOfDay_Option1"};
	case (_hour<10): {localize "STR_SerP_timeOfDay_Option2"};
	case (_hour<14): {localize "STR_SerP_timeOfDay_Option3"};
	case (_hour<16): {localize "STR_SerP_timeOfDay_Option4"};
	case (_hour<18): {localize "STR_SerP_timeOfDay_Option5"};
	case (_hour<21): {localize "STR_SerP_timeOfDay_Option6"};
	default {localize "STR_SerP_timeOfDay_Option8"};
};

_weather = switch true do {
	case (overcast>0.9): {localize "STR_SerP_weather_Option4"};
	case (overcast<0.1): {localize "STR_SerP_weather_Option0"};
	case (overcast>0.1): {localize "STR_SerP_weather_Option1"};
	case (fog>0.9): {localize "STR_SerP_weather_Option3"};
	case (fog>0.5): {localize "STR_SerP_weather_Option2"};
	default {localize "STR_SerP_weather_Option5"};
};

_weather = player createDiaryRecord ["diary", [localize "STR_SerP_weather",
format [localize "STR_SerP_timeOfDay" + " - %1<br/>" + localize "STR_SerP_weather" + " - %2<br/>" + localize "STR_SerP_viewdistance" + " - %3" ,_time,_weather,SerP_viewDistance]
]];
//задачи, вооружение и брифинги сторон
switch true do {
	case (_unitside == east): {
		{if ((_x select 1)!="") then {
			player createDiaryRecord ["diary", [(_x select 0),(_x select 1)]]
		}} forEach [
			[localize "STR_SerP_machinery_title",(localize "STR_SerP_machinery_rf")],
			[localize "STR_SerP_enemy_title",localize "STR_SerP_enemy_rf"],
			[localize "STR_SerP_execution_title",localize "STR_SerP_execution_rf"],
			[localize "STR_SerP_task_title",localize "STR_SerP_task_rf"],
			[localize "STR_SerP_situation_title",localize "STR_SerP_situation_rf"]
		];
	};
	case (_unitside == west): {
		{if ((_x select 1)!="") then {
			player createDiaryRecord ["diary", [(_x select 0),(_x select 1)]]
		};} forEach [
			[localize "STR_SerP_machinery_title",(localize "STR_SerP_machinery_bf")],
			[localize "STR_SerP_enemy_title",localize "STR_SerP_enemy_bf"],
			[localize "STR_SerP_execution_title",localize "STR_SerP_execution_bf"],
			[localize "STR_SerP_task_title",localize "STR_SerP_task_bf"],
			[localize "STR_SerP_situation_title",localize "STR_SerP_situation_bf"]
		];
	};
	case (_unitside == resistance): {
		{if ((_x select 1)!="") then {
			player createDiaryRecord ["diary", [(_x select 0),(_x select 1)]]
		};} forEach [
			[localize "STR_SerP_machinery_title",(localize "STR_SerP_machinery_guer")],
			[localize "STR_SerP_enemy_title",localize "STR_SerP_enemy_guer"],
			[localize "STR_SerP_execution_title",localize "STR_SerP_execution_guer"],
			[localize "STR_SerP_task_title",localize "STR_SerP_task_guer"],
			[localize "STR_SerP_situation_title",localize "STR_SerP_situation_guer"]
		];
	};
	default {//цивилы
		_mis = player createDiaryRecord ["diary", [localize "STR_SerP_situation_title", localize "STR_SerP_situation_tv"]];
	};
};
