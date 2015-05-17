private ["_fromEH","_vehicle","_vehicleRole","_unitToCheck","_typeToCheck","_allowedCrew","_warningMsg"];

_fromEH = _this select 0;
_vehicle = _fromEH select 0;
_vehicleRole = _fromEH select 1;
_unitToCheck = _fromEH select 2;
if !(local _unitToCheck) exitWith {};
_allowedPilot = _this select 1;
_allowedGunner = _this select 2;
_warningMsg = localize "STR_SerP_UnauthorisedCrew";
_typeToCheck = typeOf _unitToCheck;
if ((_vehicleRole == "driver")&&!(_typeToCheck in _allowedPilot)) then {
		hint format ["%1",_warningMsg];
		_unitToCheck action ["GetOut",_vehicle];
};
if ((_vehicleRole == "gunner")&&!(_typeToCheck in _allowedGunner)) then {
		hint format ["%1",_warningMsg];
		_unitToCheck action ["GetOut",_vehicle];
};

//this addEventHandler ["GetIn","[_this,['USMC_Soldier_Pilot'],['USMC_Soldier_Pilot','USMC_Soldier_SL','USMC_Soldier_TL','USMC_Soldier_AR']] call SerP_isPilot"];