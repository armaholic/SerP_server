/*
TPW BLEEDOUT
Author: tpw
Version: 1.06
Date: 20130915
Disclaimer: Feel free to use and modify this code, on the proviso that you post back changes and improvements so that everyone can benefit from them, and acknowledge the original author (tpw) in any derivative works. 	

To use: 
1 - Save this script into your mission directory as eg tpw_bleedout.sqf
2 - Call it with 0 = [5,0.4,0.6,0.8] execvm "tpw_bleedout.sqf"; where 5 = damage increment, 0.4 = crouch threshold, 0.6 = prone threshold, 0.8 incapacitation threshold
	
THIS SCRIPT WON'T RUN ON DEDICATED SERVERS
*/

if (isDedicated) exitWith {};
if (count _this  < 4) exitwith {hint "TPW BLEEDOUT incorrect/no config, exiting."};
if !(isnil "tpw_bleedout_active") exitwith {hint "TPW BLEEDOUT already running."};
WaitUntil {!isNull FindDisplay 46};

//VARIABLES
tpw_bleedout_inc = _this select 0 ; // Damage increment. The percentage a bleeding unit's damage will increase by each 10 sec. 1% will take 10+ minutes to bleed out
tpw_bleedout_cthresh = _this select 1; // Damage beyond which a unit will be forced into crouch
tpw_bleedout_pthresh = _this select 2; // Damage beyond which a unit will be forced into prone
tpw_bleedout_ithresh = _this select 3; // Damage beyond which a unit will writhe around incapacitated
tpw_bleedout_inc = tpw_bleedout_inc / 100; // concert percentage damage to 0-1 value
tpw_bleedout_active = true; // global enable/disable
tpw_bleedout_version = "1.06"; // Version string

// Stance arrays for each weapon
tpw_bleedout_standarray = ["AmovPercMstpSrasWnonDnon","AmovPercMstpSrasWpstDnon","AmovPercMstpSrasWrflDnon","AmovPercMstpSrasWlnrDnon"];
tpw_bleedout_croucharray = ["AmovPknlMstpSrasWnonDnon","AmovPknlMstpSrasWpstDnon","AmovPknlMstpSrasWrflDnon","AmovPknlMstpSrasWlnrDnon"];
tpw_bleedout_pronearray = ["AmovPpneMstpSrasWnonDnon","AmovPpneMstpSrasWpstDnon","AmovPpneMstpSrasWrflDnon","AmovPpneMstpSrasWlnrDnon"];

// DETERMINE UNIT'S WEAPON TYPE 
tpw_bleedout_fnc_weptype =
	{
	private["_unit","_weptype","_cw","_hw","_pw","_sw"];
	_unit = _this select 0;	
	
	// Weapon type
	_cw = currentweapon _unit;
	_hw = handgunweapon _unit;
	_pw = primaryweapon _unit;
	_sw = secondaryweapon _unit;
	 switch _cw do
		{
		case "": 
			{
			_weptype = 0;
			};
		case _hw: 
			{
			_weptype = 1;
			};
		case _pw: 
			{
			_weptype = 2;
			};
		case _sw: 
			{
			_weptype = 3;
			};
		default
			{
			_weptype = 0;
			};	
		};
	_unit setvariable ["tpw_bleedout_weptype",_weptype];
	};	

// WRITHING
tpw_bleedout_fnc_writhe = 
	{
	private ["_unit"];
	_unit = _this select 0;
	_unit setunitpos "down";
	sleep 3;
	_unit playmove "AinjPpneMstpSnonWrflDnon_rolltoback";
	sleep 3;
	_unit setvariable ["tpw_bleedout_writhe",1];
	_unit setdir ((getdir _unit) + 145);
	_unit switchmove "acts_InjuredLookingRifle01";
	_unit disableai "anim";
	};	

// STOP WRITHING
tpw_bleedout_fnc_unwrithe = 
	{
	private ["_unit"];
	_unit = _this select 0;		
	_unit setvariable ["tpw_bleedout_writhe",0];
	_unit setdir ((getdir _unit) - 145);
	_unit enableai "anim";
	_unit switchmove "AinjPpneMstpSnonWnonDnon_rolltofront";
	_unit playmove "";
	[_unit] call tpw_bleedout_fnc_weptype;
	_unit playmove (tpw_bleedout_standarray select (_unit getvariable "tpw_bleedout_weptype"));
	_unit setunitpos "auto";
	};	

// MAIN LOOP
while {true} do
	{
		{
		if (alive _x && {isbleeding _x}) then 
			{
			// Has unit used a medkit or been healed? If so, stop the bleeding, injury anims, and restore stance etc
			if ((_x getvariable ["tpw_bleedout_damage",0]) - (damage _x) > 0.1 ) then 
				{
				_x setBleedingRemaining 0; 
				_x setvariable ["tpw_bleedout_damage",damage _x];
				if (_x getvariable ["tpw_bleedout_writhe",0] == 1) then 
					{
					[_x] spawn tpw_bleedout_fnc_unwrithe;
					}
					else
					{
					[_x] call tpw_bleedout_fnc_weptype;
					_x playmove (tpw_bleedout_standarray select (_x getvariable "tpw_bleedout_weptype"));
					_x setunitpos "auto";
					};
				}
				else
				{ 
				// Increase unit damage and fatigue, keep them bleeding
				_x setdamage ((damage _x) + (tpw_bleedout_inc * damage _x));
				_x setfatigue ((damage _x) + (tpw_bleedout_inc * damage _x));
				_x setvariable ["tpw_bleedout_damage",((damage _x) + (tpw_bleedout_inc * damage _x))];
				_x setBleedingRemaining 60; 
				
				// Injured behaviours for AI
				if (_x != player) then 
					{
					if (damage _x > 0.5) then // Stay crouched
						{
						if (stance _x != "PRONE") then 
							{
							_x setunitpos "middle";
							[_x] call tpw_bleedout_fnc_weptype;
							_x playmove (tpw_bleedout_croucharray select (_x getvariable "tpw_bleedout_weptype"));
							};
						_x setSpeedMode "LIMITED";
						};
					if (damage _x > 0.7) then // Stay prone	
						{
						_x setunitpos "down";
						[_x] call tpw_bleedout_fnc_weptype;
						_x playmove (tpw_bleedout_pronearray select (_x getvariable "tpw_bleedout_weptype"));
						_x setSpeedMode "LIMITED";
						};
					if (damage _x > 0.85 && (_x getvariable ["tpw_bleedout_writhe",0] == 0)) then // Writhe around immobile	
						{
						[_x] spawn tpw_bleedout_fnc_writhe; 
						};
					};
				};	
			};
			
		if (alive _x && {!(isbleeding _x) && (_x getvariable ["tpw_bleedout_writhe",0] == 1)}) then 
			{
			[_x] spawn tpw_bleedout_fnc_unwrithe;
			};
		} foreach allunits;
		
		//Stop dead units from writhing	
		{
		if (_x getvariable "tpw_bleedout_writhe" == 1) then 
			{
			_x setdir ((getdir _x) - 145);
			_x switchmove "AinjPpneMstpSnonWrflDnon_rolltofront";
			_x setvariable ["tpw_bleedout_writhe",0];
			};
		} foreach alldead;
		sleep 10;
	};
