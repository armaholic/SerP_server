#include "_main.hpp"
#include "settings.hpp"

GVAR(FortDistance) = 10;

GVAR(BuildSysEnabled) = true;
GVAR(BuildingMode) = false;
GVAR(CurrentFort) = objNull;
GVAR(FutureFortType) = [];
GVAR(CurrentFortType) = [];
GVAR(AtLandMode) = true;
GVAR(Elevation) = 0;
GVAR(FlipFortDir) = false;

GVAR(AdjustingElevation) = false;
GVAR(AE_BegEl) = 0;
GVAR(AE_BegArc) = 0;

GVAR(AdjustingDistance) = false;
GVAR(AD_BegD) = 0;
GVAR(AD_BegArc) = 0;

FUNC(FortPos) = {
	PV(_pp) = 0;
	PV(_pd) = getDir player;

	GVAR(FortDistance) = (GVAR(FortDistance) max FDA_DIST(GVAR(CurrentFortType))) min
		MAX_FORT_DISTANCE;
	
	if (_this) then
	{
		GVAR(Elevation) = (GVAR(Elevation) max ALM_MIN_ELEVATION) min ALM_MAX_ELEVATION;
	
		_pp = getPosATL player;
		_pp set [2, GVAR(Elevation)];
	}
	else
	{
		GVAR(Elevation) = (GVAR(Elevation) max ABM_MIN_ELEVATION) min ABM_MAX_ELEVATION;
	
		_pp = getPosASL player;
		_pp set [2, (_pp select 2) + GVAR(Elevation)];
	};
		
	_pp set [1, (_pp select 1) + cos(_pd) * GVAR(FortDistance)];
	_pp set [0, (_pp select 0) + sin(_pd) * GVAR(FortDistance)];
	_pp;
};

RC_DEFINE(CRequireBP_Response) = {
	if (_this) then
	{
		GVAR(Response) = 1;
	}
	else
	{
		GVAR(Response) = -1;
	};

};

RC_INIT_EH(CRequireBP_Response);

GVAR(PrevBPCount) = 0;

FUNC(UpdateBuildAction) = {
	GVAR(PrevBPCount) = (group player) getVariable [GROUP_BP_POINTS_VARIABLE, 0];

	player removeAction GVAR(MBuild);
	GVAR(MBuild) = player addAction [format [localize "STR_DBS_AMBuild",
		FDA_COST(GVAR(CurrentFortType)), (group player) getVariable
		[GROUP_BP_POINTS_VARIABLE, 0]],
		_PREFIX_ + "_act_build.sqf", [], BASE_ACTION_PRIORITY + 10];
};


FUNC(PreviewFortType) = {
/*	PV(_itemclass_preview) = getText (configfile >> "CfgVehicles" >> _this >> "ghostpreview");
	
	if (_itemclass_preview == "") then
	{
		_this;
	}
	else
	{
		_itemclass_preview;
	};*/
	
	_this;
};

GVAR(MBuild) = -1;
GVAR(MDist) = -1;
GVAR(MElev) = -1;
GVAR(MLand) = -1;
GVAR(MType) = -1;
GVAR(MFlip) = -1;
		
sleep 0.1;

[] call compile preprocessFileLineNumbers (_PREFIX_ + "_init_fort_list.sqf");

if (count GVAR(AvFortList) > 0) then {
	GVAR(CurrentFortType) = GVAR(AvFortList) select 0;
	GVAR(FutureFortType) = GVAR(CurrentFortType);
	
	GVAR(MinFortCost) = FDA_COST(GVAR(CurrentFortType));
	GVAR(AllFortObjTypes) = [];
	
	{
		if (GVAR(MinFortCost) > FDA_COST(_x)) then {
			GVAR(MinFortCost) = FDA_COST(_x);
		};
		GVAR(AllFortObjTypes) set [count GVAR(AllFortObjTypes), FDA_OBJ(_x)];
	} forEach GVAR(AvFortList);
	

	GVAR(PlayerShieldEHIndex) = player addEventHandler ["HandleDamage", {
			PV(_res) = _this select 2;
			
			if ((_this select 3) == player  &&  (_this select 4) == "") then {
				//PV(_objs) = lineIntersectsWith [getPosASL player, eyePos player,
				//	player];
				
				if (count (nearestObjects [player, GVAR(AllFortObjTypes), 1.5]) > 0) then {
					_res = 0;
				};
				
//				{
//					if ((typeOf _x) in GVAR(AllFortObjTypes)) 
//						exitWith {_res = 0;};
//				} forEach _objs;
			};
			
//			if (_res > 0) then
//			{
//				hint format["%1 === %2", _this, _res];
//			};
			_res;
		}];

	/////////////////
	// tushino specific
	///////////////
	
	[] spawn {
		waitUntil {
			sleep 1;
			(!isNil 'GVAR(BuildSysTimeout)') && {GVAR(BuildSysTimeout)}
		};
	
		GVAR(BuildingMode) = false;
		GVAR(BuildSysEnabled) = false;	
	};
	
	//////////////////

	waitUntil
	{
		sleep 0.25;
		if ((isNull player) || {(group player) getVariable [GROUP_BP_POINTS_VARIABLE, 0] < GVAR(MinFortCost)}) then {
				GVAR(BuildSysEnabled) = false;
				GVAR(BuildingMode) = false;
			};
		
		(!GVAR(BuildSysEnabled)) || {(leader player == player) || player getVariable [PLAYER_BUILDING_ALLOWANCE_VARIABLE, false]}
	};
	
//	player addAction ["Switch building mode", _PREFIX_ + "_act_switch_buildingmode.sqf"];


waitUntil {!isNil "SerP_addToMenu" || time > 10};

[] call SerP_addSeparatorToMenu;

_serp_menu_cond1 = {GVAR(BuildSysEnabled)};

[localize "STR_DBS_SIMBuildingMode", 0, {[] call compile preprocessFile (_PREFIX_ + "_act_switch_buildingmode.sqf")}, _serp_menu_cond1, _serp_menu_cond1] call SerP_addToMenu;		

_serp_menu_cond2 = {((!isNull player) && {GVAR(BuildSysEnabled) && (leader player == player) && (isNil 'misBuildSys_EmptyListForAllowance')})};

[localize "STR_DBS_SIMAllowance", 0, {[] call compile preprocessFile (_PREFIX_ + "_act_giveallowance.sqf")}, _serp_menu_cond2, _serp_menu_cond2] call SerP_addToMenu;		
		
	// hotkeys
	//////////////////////////////////////////////////////////////////////////

	GVAR(HK_ChangeElevation) = 0;
	GVAR(HK_ChangeDistance) = 0;

	FUNC(Hotkeys_Keyupdown_EH) = {
			private["_handled", "_ctrl", "_dikCode", "_shift", "_ctrlKey", "_alt", "_t", "_down"];
			_down = _this select 1;

			_t = _this select 0;
			_ctrl = _t select 0;
			_dikCode = _t select 1;
			_shift = _t select 2;
			_ctrlKey = _t select 3;
			_alt = _t select 4;	

			_handled = false;

			if (!_ctrlKey && !_shift && !_alt && GVAR(BuildingMode)) then
			{
				// 1
				if (_dikCode == 2) then
				{
					if (_down) then
					{
						GVAR(HK_ChangeElevation) = -1;
					} else {
						GVAR(HK_ChangeElevation) = 0;
					};
					_handled = true;
				};
				// 2
				if (_dikCode == 3) then
				{
					if (_down) then
					{
						GVAR(HK_ChangeElevation) = 1;
					} else {
						GVAR(HK_ChangeElevation) = 0;
					};
					_handled = true;
				};
				// 3
				if (_dikCode == 4) then
				{
					if (_down) then
					{
						GVAR(HK_ChangeDistance) = -1;
					} else {
						GVAR(HK_ChangeDistance) = 0;
					};
					_handled = true;
				};
				// 4
				if (_dikCode == 5) then
				{
					if (_down) then
					{
						GVAR(HK_ChangeDistance) = 1;
					} else {
						GVAR(HK_ChangeDistance) = 0;
					};
					_handled = true;
				};
				// 5
				if (_dikCode == 6) then
				{
					if (!_down) then
					{
						[] call compile preprocessFileLineNumbers (_PREFIX_ + "_act_switch_atmode.sqf");
					};
					_handled = true;
				};
				// 6
				if (_dikCode == 7) then
				{
					if (!_down) then
					{
						[] call compile preprocessFileLineNumbers (_PREFIX_ + "_act_forttype.sqf");
					};
					_handled = true;
				};
				// 7
				if (_dikCode == 8) then
				{
					if (!_down) then
					{
						[] call compile preprocessFileLineNumbers (_PREFIX_ + "_act_flip_dir.sqf");
					};
					_handled = true;
				};	
				// 8
				if (_dikCode == 9) then
				{
					if (!_down) then
					{
						[] call compile preprocessFileLineNumbers (_PREFIX_ + "_act_build.sqf");
					};
					_handled = true;
				};
		
			};

			
			// 9
			if (_dikCode == 10 && !_ctrlKey && !_shift && !_alt) then
			{
				if (!_down) then
				{
					[] call compile preprocessFileLineNumbers (_PREFIX_ + "_act_giveallowance.sqf");
				};
				_handled = true;
			};
			
			// 0
			if (_dikCode == 11 && !_ctrlKey && !_shift && !_alt &&
				(player == vehicle player)) then
			{
				if (!_down) then
				{
					if (GVAR(BuildingMode)) then
					{
						GVAR(BuildingMode) = false;
					}
					else
					{
						GVAR(BuildingMode) = true;
					};				
				};
				_handled = true;
			};

			
			
			_handled;
	};


_Hotkeys_Keydown_EHid = (findDisplay 46) displayAddEventHandler ["keyDown", '[_this, true] call FUNC(Hotkeys_Keyupdown_EH);'];	
_Hotkeys_Keyup_EHid = (findDisplay 46) displayAddEventHandler ["keyUp", '[_this, false] call FUNC(Hotkeys_Keyupdown_EH);'];	
			

//////////////////////////////////////////////////////////////////////////
		
GVAR(AtLandMode) = true;	

	while {GVAR(BuildSysEnabled)} do {
		// reset hotkeys
	
		GVAR(HK_ChangeElevation) = 0;
		GVAR(HK_ChangeDistance) = 0;

		waitUntil{
			sleep 0.25;
			if ((isNull player) || {(group player) getVariable [GROUP_BP_POINTS_VARIABLE, 0] <
				GVAR(MinFortCost)} ) then
			{
				GVAR(BuildSysEnabled) = false;
				GVAR(BuildingMode) = false;
			};
			
			GVAR(BuildingMode) || (!GVAR(BuildSysEnabled));
		};
		
		if (!GVAR(BuildSysEnabled)) exitWith {true};
		
		
		// init
		
		if (!isNull GVAR(CurrentFort)) then
		{
			deleteVehicle GVAR(CurrentFort);
		};
		
		GVAR(CurrentFort) = FDA_OBJ(GVAR(CurrentFortType)) call FUNC(PreviewFortType)
			createVehicleLocal [-10000, -10000, 1000];
		GVAR(CurrentFort) enableSimulation false;
		GVAR(CurrentFort) allowDamage false;
		
		
		GVAR(ABuild) = false;
		
		GVAR(AdjustingElevation) = false;
		GVAR(AdjustingDistance) = false;

		
//		GVAR(MBuild) = player addAction [
//			format ["Build (cost %1 of %2 BPs)", FDA_COST(GVAR(CurrentFortType)),
//			(group player) getVariable [GROUP_BP_POINTS_VARIABLE, 0]],
//			_PREFIX_ + "_act_build.sqf", [], BASE_ACTION_PRIORITY + 10];
			
		GVAR(MDist) = player addAction [localize "STR_DBS_AMDist", _PREFIX_ + "_act_switch_distance.sqf", [], BASE_ACTION_PRIORITY + 8];

		GVAR(MElev) = player addAction [localize "STR_DBS_AMElev", _PREFIX_ + "_act_switch_elevation.sqf", [], BASE_ACTION_PRIORITY + 9];
			
		GVAR(MLand) = player addAction [localize 'STR_DBS_AMLand_BM', _PREFIX_ + "_act_switch_atmode.sqf", [], BASE_ACTION_PRIORITY + 7];
				
		GVAR(MType) = player addAction [localize "STR_DBS_AMType", _PREFIX_ + "_act_forttype.sqf", [], BASE_ACTION_PRIORITY + 6];
		
		GVAR(MFlip) = player addAction [localize "STR_DBS_AMFlip", _PREFIX_ + "_act_flip_dir.sqf", [], BASE_ACTION_PRIORITY + 5];
			
/*		GVAR(MExit) = player addAction ["End building",
			_PREFIX_ + "_act_switch_buildingmode.sqf", [], BASE_ACTION_PRIORITY + 1];*/

		[] call FUNC(UpdateBuildAction);
		
		_hk_last_ticktime = diag_tickTime;
		
		waitUntil {
			if ((isNull player) || {(player != vehicle player) || (!alive player)}) then {
				GVAR(BuildingMode) = false;
			} else {
			
			if (GVAR(PrevBPCount) != (group player) getVariable [GROUP_BP_POINTS_VARIABLE, 0]) then {
				[] call FUNC(UpdateBuildAction);
			};
			
			if (FDA_TITLE(GVAR(FutureFortType)) != FDA_TITLE(GVAR(CurrentFortType)) ) then {
				GVAR(CurrentFortType) = GVAR(FutureFortType);
				
				if (!isNull GVAR(CurrentFort)) then {
					deleteVehicle GVAR(CurrentFort);
				};
			
				GVAR(CurrentFort) = FDA_OBJ(GVAR(CurrentFortType)) call FUNC(PreviewFortType)
					createVehicleLocal [-10000, -10000, 1000];
				GVAR(CurrentFort) enableSimulation false;
				GVAR(CurrentFort) allowDamage false;
				
				[] call FUNC(UpdateBuildAction);
			};

			_hk_ticktime_delta = diag_tickTime - _hk_last_ticktime;
			_hk_last_ticktime = diag_tickTime;	

			if (GVAR(HK_ChangeElevation) != 0) then {
				GVAR(Elevation) = GVAR(Elevation) + GVAR(HK_ChangeElevation) * HOTKEY_ELEVATION_CHANGE_RATE * _hk_ticktime_delta;
			};
			
			if (GVAR(HK_ChangeDistance) != 0) then {
				GVAR(FortDistance) = GVAR(FortDistance) + GVAR(HK_ChangeDistance) * HOTKEY_DISTANCE_CHANGE_RATE * _hk_ticktime_delta;
			};
			
			if (GVAR(AdjustingElevation)) then {
				GVAR(Elevation) = GVAR(AE_BegEl) + ((player weaponDirection "") select 2) * GVAR(FortDistance) - GVAR(AE_BegArc);
			};
			
			if (GVAR(AdjustingDistance)) then {
				GVAR(FortDistance) = GVAR(AD_BegD) + (asin ((player weaponDirection "") select 2)) * ADJUST_DISTANCE_MULT - GVAR(AD_BegArc);
			};
			
//			if (GVAR(AtLandMode) && ((getPosATL player) select 2) > SWITCH_TO_ABM_HEIGHT) then
//			{
//				GVAR(AtLandMode) = false;
//			};
			
			if (GVAR(FlipFortDir)) then {
				GVAR(CurrentFort) setDir ((getDir player) + 180);
			} else {
				GVAR(CurrentFort) setDir (getDir player);
			};
		
			PV(_cfpos_asl) = [0, 0, 0];
		
			if (GVAR(AtLandMode)) then {
				_cfpos = (GVAR(AtLandMode) call FUNC(FortPos));
				_cfvup = surfaceNormal _cfpos;
				
				if ((_cfvup select 2) < ALM_MIN_VECTORUP) then {
					___x = _cfvup select 0;
					___y = _cfvup select 1;
					___zn2 = ALM_MIN_VECTORUP * ALM_MIN_VECTORUP;
					_cfvup set [2, sqrt (  ___zn2 / 
						(1 - ___zn2) * (___x*___x + ___y*___y) ) ];
				};

				GVAR(CurrentFort) setPosATL _cfpos;
				_cfpos_asl = getPosASL GVAR(CurrentFort);
				GVAR(CurrentFort) setVectorUp _cfvup;
			} else {
				GVAR(CurrentFort) setPosASL (GVAR(AtLandMode) call FUNC(FortPos));		
				_cfpos_asl = getPosASL GVAR(CurrentFort);
				GVAR(CurrentFort) setVectorUp [0,0,1];
			};


			PV(_validpos) = true;
			
			
			if ( (group player) getVariable [GROUP_BP_POINTS_VARIABLE, 0] < FDA_COST(GVAR(CurrentFortType)) ) then {
				_validpos = false;
				1 cutText [localize "STR_DBS_MNoBPs", "PLAIN DOWN", 0.01];
			};

			if (_validpos && {(!GVAR(AtLandMode)) && FDA_LANDONLY(GVAR(CurrentFortType))} ) then {
				_validpos = false;
				1 cutText [localize 'STR_DBS_MWrongMode', "PLAIN DOWN", 0.01];
			};
				
				
			if (_validpos && {(!GVAR(AtLandMode)) && ((getPosATL GVAR(CurrentFort)) select 2 ) > LINEINTERSECTSWITH_LENGTH}) then {
				PV(_pos) = getPosASL GVAR(CurrentFort);
				PV(_pose) = + _pos;
				_pose set [2, (_pose select 2) - LINEINTERSECTSWITH_LENGTH];
				
				PV(_objs) = lineIntersectsWith [_pos, _pose, GVAR(CurrentFort)];						
				_validpos = (("Building" countType _objs) > 0);
				
				if (!_validpos) then {
					1 cutText [localize "STR_DBS_MWrongPos", "PLAIN DOWN", 0.01];
				};	
			};	
			
			if (_validpos) then {
				PV(_objs) = GVAR(CurrentFort)	nearObjects ["Static", MIN_DISTANCE_TO_ANOTHER_FORT];
				
				PV(_t) = false;
				{
					if (_x getVariable [OWN_FORTS_MARK_VARIABLE, false]) exitWith {_t = true;};
				} forEach _objs;
			
				if (_t) then {
					_validpos = false;
					1 cutText [localize "STR_DBS_MAnotherFort", "PLAIN DOWN", 0.01];
				};
			};

			// player wants to build the fortification
			if (GVAR(ABuild) && _validpos) then {
				GVAR(Response) = 0;

				#define RC_EXEC_ARG [player, FDA_COST(GVAR(CurrentFortType))]
				RC_EXEC_S(SRequireBP);
				
				
				waitUntil {GVAR(Response) != 0};
				
				if (GVAR(Response) < 0) then {
					cutText [localize "STR_DBS_MNoBPs", "PLAIN DOWN", 1];
				} else {
					PV(_t) = FDA_OBJ(GVAR(CurrentFortType)) createVehicle [-10000, -10000, 1000];

					_t setDamage FDA_DAMAGE(GVAR(CurrentFortType));
					_t setDir (getDir GVAR(CurrentFort));						
					_t setPosASL _cfpos_asl;
					_t setVectorUp (vectorUp GVAR(CurrentFort));
					_t setVariable [OWN_FORTS_MARK_VARIABLE, true];
				};
				
				[] call FUNC(UpdateBuildAction);
			};

			GVAR(ABuild) = false;

			if ( (group player) getVariable [GROUP_BP_POINTS_VARIABLE, 0] < GVAR(MinFortCost) ) then {
				GVAR(BuildSysEnabled) = false;
				GVAR(BuildingMode) = false;
			};
			
			};

			!GVAR(BuildingMode);
		};
		
		player removeAction GVAR(MBuild);
		player removeAction GVAR(MDist);
		player removeAction GVAR(MElev);
		player removeAction GVAR(MLand);
		player removeAction GVAR(MType);
		player removeAction GVAR(MFlip);
//		player removeAction GVAR(MExit);

		if (!isNull GVAR(CurrentFort)) then {
			deleteVehicle GVAR(CurrentFort);
			GVAR(CurrentFort) = objNull;
		};
		
	};
	

	(findDisplay 46) displayRemoveEventHandler ["keyDown", _Hotkeys_Keydown_EHid];	
	(findDisplay 46) displayRemoveEventHandler ["keyUp", _Hotkeys_Keyup_EHid];	

	waitUntil
	{
		sleep 1;
		(!isNil 'GVAR(BuildSysTimeout)')
	};
	
	if (!isNull player) then {
		player removeEventHandler ["HandleDamage", GVAR(PlayerShieldEHIndex)];
	};

	
};