SerP_menuCode = [];

SerP_addToMenuRaw = {
	SerP_menuCode set [count SerP_menuCode, _this];
};
SerP_addToMenu = {
	_getMenuItem = {
		_title = _this select 0;
		_hotkey = _this select 1;
		_callback = _this select 2;
		_showCondition = _this select 3;
		_activationCondition = _this select 4;
		_boolToNumber = {
			_bool = call _this;
			if (_bool) then {"1"} else {"0"};
		};
		[
			_title,
			[_hotkey],
			"",
			-5,
			[["expression", "if (call "+str _activationCondition+") then {call "+str _callback+";};"]],
			_showCondition call _boolToNumber,
			_activationCondition call _boolToNumber
		]
	};
	compile(str(_this) + "call "+ str _getMenuItem) call SerP_addToMenuRaw;
};

SerP_addSeparatorToMenu = {
	["(separator)",[3], "",-1, [["expression", ""]], "1", "1"] call SerP_addToMenuRaw;
};


_isLockAvailable = {
	_veh = vehicle player;
	_role = assignedVehicleRole _veh;
	_isCargo = if (count(_role)==0) then {true}else{"Cargo"==(_role select 0)};
	(_veh!=player&&!_isCargo&&locked(_veh)<2)
};
["Lock", 2,{(vehicle player) lock true},_isLockAvailable,_isLockAvailable] call SerP_addToMenu;


_isUnLockAvailable = {
	_veh = vehicle player;
	_role = assignedVehicleRole _veh;
	_isCargo = if (count(_role)==0) then {true}else{"Cargo"==(_role select 0)};
	(_veh!=player&&!_isCargo&&locked(_veh)>1)
};
["Unlock", 2, {(vehicle player) lock false}, _isUnlockAvailable, _isUnlockAvailable] call SerP_addToMenu;


_isTryUnlockAvailable = {
	_target = cursortarget;
	(((_target distance player)<5)&&(_target isKindOf "LandVehicle" || _target isKindOf "Helicopter" || _target isKindOf "Plane" || _target isKindOf "Ship" || _target isKindOf "StaticWeapon")
	&&(locked(_target)>1))
};
_tryUnlock = {
	_target = cursortarget;
	_max = switch true do {
		case (_target isKindOf "Wheeled_APC"): {1000};
		case (_target isKindOf "Tank"): {2000};
		case (_target isKindOf "Helicopter"): {500};
		case (_target isKindOf "Plane"): {500};
		case (_target isKindOf "Ship"): {500};
		case (_target isKindOf "StaticWeapon"): {100};
		case (_target isKindOf "LandVehicle"): {500};
		default {1000};
	};
	_r = floor(random(_max));
	if (_r<2) then {
		_target lock false;
		hint "Success";
	}else{
		hintSilent format ["Fail (%1/%2)",_max-_r, _max];
	};
};
["Try unlock", 2, _tryUnlock, _isTryUnlockAvailable, _isTryUnlockAvailable] call SerP_addToMenu;

SerP_showMenu = { 
	SerP_menu = [["SerP menu",false]];
	{
		switch (typeName(_x)) do
		{
		    case "ARRAY":
		    {
				SerP_menu set [count SerP_menu, _x];
		    };
		    case "CODE":
		    {
				SerP_menu set [count SerP_menu, call _x];
		    };
		    default {["wrong entry in SerP menu",typeName(_x), _x] call SerP_debug};
		};
	} forEach SerP_menuCode;

	_separator = ["(separator)", [0], "",-1, [["expression", ""]], "1", "1"];
	_close = ["Close", [0], "",-3, [["expression", ""]], "1", "1"];
	SerP_menu set [count SerP_menu, _separator];
	SerP_menu set [count SerP_menu, _close];
	showCommandingMenu "#USER:SerP_menu";
};

[] spawn {
	sleep 1;
	_keyhandler = (findDisplay 46) displayAddEventHandler ["keyDown", 'if (!(_this select 2)&&(_this select 3)&&!(_this select 4)&&((_this select 1) == 221)) then {call SerP_showMenu;}'];
};
