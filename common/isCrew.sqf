/*
	Функция контроля экипажа техники.
	Автор: Dimon UA
	
	Параметры:
		0. _this - по умолчанию
		1. - места что блокируются 
			"driver"
			"gunner"
			"commander" - блокировка места командира - разрешено только для arrRelCommander
			"crew" - блокировка всей техники (вкл. пассажиров) разрешено только для arrRelCrew
		2. - "east"/"west"/"guer"/"civ"/"" - проверка игрока на сторону (опционально)
	
	Примеры запуска в ините
		_=[this,"driver","gunner"] execvm "SerP\isCrew.sqf";
		_=[this,"driver","gunner"] execvm "SerP\isCrew.sqf";
		_=[this,"driver","gunner","commander"] execvm "SerP\isCrew.sqf";
		_=[this,"driver","gunner","commander"] execvm "SerP\isCrew.sqf";
		_=[this,"driver","gunner","commander",weST] execvm "SerP\isCrew.sqf";
		_=[this,"driver","gunner","commander","east"] execvm "SerP\isCrew.sqf";
	
*/

#define Cfgman (configFile >> "CfgVehicles" >>(typeOf _unitToCheck) >> "_generalmacro")
#define allCrew (typeOf _unitToCheck) in arrRelCrew
#define isCrew (_vehicle isKindOf "landvehicle" && (toLower(getText Cfgman) find "crew" > -1 || toLower(getText Cfgman) find "driver" > -1 || ((typeOf _unitToCheck) in arrRelCommander)) || (_vehicle isKindOf "air" && toLower(getText Cfgman) find "pilot" > -1) || allCrew )

//======================= функция сканирования действий игрока внутри техники =====================//
fnc_CrewControl = {
	private ["_typeIn", "_place", "_veh", "_move", "_warningMsgPlace"];

	if (crewIndex) exitWith {};
	crewIndex = true;  //переменная на случай двойного запуска скрипта
	_typeIn = _this select 0;
	_place = "";
	_veh = (vehicle player); //фикисируем технику
	_move=false;
	_index = -1;
	_warningMsgPlace = localize "STR_SerP_UnauthorisedPlace";

	//цикл работает пока игрок жив и в технике
	while {alive player && {player in _veh}} do {
		call {
			if (player == commander _veh) exitWith {_place = "commander"};
			if (player == gunner _veh) exitWith {_place = "gunner"};
			if (player == driver _veh) exitWith {_place = "driver"};
			_place="cargo";
			_index=_veh getCargoIndex player;
		};
		sleep 1;
		_move = (player == driver _veh && {_typeIn in [0,2,3,5]})
		|| {(player == gunner _veh && {_typeIn in [1,2,4,5]})}
		|| {(player == commander _veh && {_typeIn in [3,4,5,6]})};
		// если переменая _move активна то запускаем возврат игрока на предыдущее место.
		if _move then {
			if (_place != "cargo") then {
				player action [format ["moveTo%1", _place], _veh]
			} else {
				player action ["moveTocargo", _veh,_index]};
				_move = false;
				hint format ["%1", _warningMsgPlace];
			};
	};
	crewIndex = false;
};
//================= функция запускаемая при входе в технику ========================//
fnc_inCrewFilter = {
	private ["_fromEH", "_type", "_vehicle", "_unitToCheck", "_side", "_warningMsgCrew", "_warningMsgSide", "_state"];

	_fromEH = _this select 0;
	_type = _this select 1;
	_vehicle = _fromEH select 0;
	_unitToCheck = _fromEH select 2;
	_side = _this select 2;
	_exit = false;
	if (isnil {_vehicle getVariable "CREW_GETININDEX"}) then { _vehicle setVariable ["CREW_GETININDEX",_type,true];};

	if !(local _unitToCheck) exitWith {};
	_warningMsgCrew = localize "STR_SerP_UnauthorisedCrew";
	_warningMsgSide = localize "STR_SerP_UnauthorisedSide";

	//если необходимо то делаем проверку на сторону
	if (count (_side)>0 && {!(toLower (str (side (group _unitToCheck))) in _side)}) exitWith {
		moveOut _unitToCheck;
		hint format ["%1",_warningMsgSide];
	};

	//====================================================================
	call {
		if ((_type != 7 && isCrew) || {(_type == 7 && {allCrew})}) exitWith {}; // если игрок подошел заданным параметрам то выходим из скрипта

		_exit = ((_unitToCheck == driver _vehicle || _unitToCheck == _vehicle turretUnit [0]) && {_type in [0,2,3,5]})
		|| {_unitToCheck == gunner _vehicle && {_type in [1,2,4,5]}}
		|| {_unitToCheck == commander _vehicle && {_type in [3,4,5,6]}}
		|| {_unitToCheck in (crew _vehicle) && {_type == 7}};
		
		if _exit exitWith {
			moveOut _unitToCheck;
			hint format ["%1", _warningMsgCrew];
			_exit = false;
		};
		[_type] spawn fnc_CrewControl; // если игрок занял не запретное место запускаем цикл с проверкой его перемещений в технике во время нахождения в этой технике
	};
};
//============= функция форматирования переменных ================//
fnc_format = {
	private ["_array"];
	_array = [];
	{
		If (!([_x,_this select 0] call KK_fnc_isEqual)) then 
		{ 
			if (typeName _x != "STRING") then { _x = str _x};
			_array pushBack  toLower (_x);
		};
	} foreach _this;
	_array
};
//=================== функция сравнения массивов ================//
KK_fnc_isEqual = {
	switch (_this select 0) do 
	{
		case (_this select 1) : {true};
		default {false};
	};
};
//================== определение запроса ==========================//
private ["_object", "_closepos", "_result", "_side"];

_object = _this select 0; //фиксируем обьект
_closepos= objnull;

_this = _this call fnc_format; //проверяем/форматируем, отсеиваем _object
_pos = [_this, {_this in ["driver","gunner","commander","crew"]}] call CBA_fnc_select;//_result = [[1,2,3], {_this in [2,3]}] call CBA_fnc_select; _result = [2,3];
call {
	if (count (_pos) > 2) exitWith {_closepos = 5};
	if (count (_pos) == 2) exitWith 
	{ 
		call {
			if ({if(!(_x in ["gunner","commander"])) exitWith {1};} count (_pos) == 0) exitWith {_closepos = 4};
			if ({if(!(_x in ["driver","commander"])) exitWith {1};} count (_pos) == 0) exitWith {_closepos = 3};
			if ({if(!(_x in ["driver","gunner"])) exitWith {1};} count (_pos) == 0) exitWith {_closepos = 2};
		};
	};
	if (count (_pos) == 1) exitWith 
	{ 
		call {
			if ((_pos select 0) == "commander") exitWith {_closepos = 6};
			if ((_pos select 0) == "gunner") exitWith {_closepos = 1};
			if ((_pos select 0) == "driver") exitWith {_closepos = 0};
			if ((_pos select 0) == "crew") exitWith {_closepos = 7};
		};
	};
	if (count (_pos) == 0) exitWith {_closepos = 8};
};

_side = [_this, {_this in ["west","east","guer","civ"]}] call CBA_fnc_select;
_recoil = [_this, {_this in ["recoil"]}] call CBA_fnc_select;

_object setVariable ["BLOCKPOS", _closepos, true];
_object setVariable ["TRUESIDE", _side, true];

_object addEventHandler ["GetIn", {[_this, (_this select 0) getVariable "BLOCKPOS" , (_this select 0) getVariable "TRUESIDE"] call fnc_inCrewFilter}];
//MBT Recoil autor: Killzone_Kid
if (!isnil "_recoil") then {
	_object addEventHandler ["Fired", format ["
		if (_this select 1 == '%1') then { 
			_this = _this select 0;
			_recv = %2 vectorDiff ((
				_this worldToModelVisual (_this weaponDirection '%1') 
				vectorDiff (_this worldToModelVisual [0, 0, 0])
			) vectorMultiply 1.2);
			_recv set [2, %3];
			_this setCenterOfMass _recv;
			if (player in _this && cameraView == 'GUNNER') then {
				addCamShake [5, 0.5, 25];
			};  
			_this spawn {
				uiSleep 0.2; 
				_this setCenterOfMass %2;
			};
		}", 
		_object weaponsTurret [0] select 0, 
		getCenterOfMass _object,
		getCenterOfMass _object select 2
	]];
};
_object addEventHandler ["killed", {_this removeAllEventHandlers "Getin"; _this removeAllEventHandlers "Fired"; _this removeAllEventHandlers "killed"}];