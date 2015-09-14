
if (isNil{SerP_endMissionToggle}) then {SerP_endMissionToggle = 1;};
if (SerP_endMissionToggle==0) exitWith {};
//инициализируем функции

sleep 10;
//админ может завершить миссию досрочно нажав комбинацию клавиш ctrl+alt+shift+end
if ((serverCommandAvailable "#kick")||isServer) then {
	(findDisplay 46) displayAddEventHandler ["KeyDown", '
		_ctrl = _this select 0;
		_dikCode = _this select 1;
		_shift = _this select 2;
		_ctrlKey = _this select 3;
		_alt = _this select 4;
		_handled = false;
		if ((_dikCode == 207) && _shift && _ctrlKey && _alt) then {
			["end_admin"] call SerP_endMission
		};
	'];
};

//ждем пока не закончится фризтайм
waitUntil {sleep 1; !isNil{Serp_warbegins} && {Serp_warbegins == 1}};

if isNil{SerP_end} then {
	SerP_end = ['', false];
} else {
	if (SerP_end select 1) then {
		SerP_end call SerP_endMission
	};
};

if (!isDedicated && isServer) then {//костыль для тестов
	_trigger = createTrigger["EmptyDetector",[0,0]];
	_trigger setTriggerActivation ["ANY", "PRESENT", true];
	_trigger setTriggerStatements[
		"SerP_end select 1",
		"SerP_end call SerP_endMission",
		""
	];
}else{//завершение
	"SerP_end" addPublicVariableEventHandler {
		if ((_this select 1) select 1) then {
			(_this select 1) call SerP_endMission
		};
	};
};


SerP_allUnits = []; //собираем список юнитов в начале игры потому-что узнать имя мертвого игрока нельзя
{
	_show = false;
	_unitsInGroup = [];
	{
		if isPlayer(_x) then {
			_show = true;
			_unitsInGroup set [count _unitsInGroup, [name _x, _x]];
		};
	} forEach (units _x);
	if _show then {
		SerP_allUnits set [count SerP_allUnits, [_x, _unitsInGroup]];
	};
} forEach allGroups;

_initRFCount = {(isPlayer _x) && (alive _x) && (side _x == SerP_sideREDFOR)} count playableUnits;
_initBFCount = {(isPlayer _x) && (alive _x) && (side _x == SerP_sideBLUEFOR)} count playableUnits;

while {true} do {
	sleep 10;
	_RFCount = {(alive _x) && (side _x == SerP_sideREDFOR)} count playableUnits;
	_BFCount = {(alive _x) && (side _x == SerP_sideBLUEFOR)} count playableUnits;
	//REDFOR retreat
	if ((_RFCount < _initRFCount * SerP_RFRetreat) && (_RFCount * SerP_domiMult < _BFCount)) exitWith {
		["redfor_retreat"] call SerP_endMission;
	};
	//BLUEFOR retreat
	if ((_BFCount < _initBFCount * SerP_BFRetreat) && (_BFCount * SerP_domiMult < _RFCount)) exitWith {
		["bluefor_retreat"] call SerP_endMission;
	};
};
