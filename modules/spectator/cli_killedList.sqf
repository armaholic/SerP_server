a3a_var_cli_killedAllies = [];
a3a_var_cli_killedEnemies = [];

a3a_fnc_cli_onPVKilled = {
	private ["_victim", "_killer", "_victimName", "_ally", "_enemy"];

	_victim = _this select 0;
	_killer = _this select 1;
	
	if (!(isNull _killer) && !(isNull _victim)) then {
		if (_killer isEqualTo player) then {
			_victimName = (_victim getVariable ["PlayerName", [name _victim]]) select 0;
			
			_ally = [];
			_enemy = [];
			/// VICTIM-KILLER SIDE RELATIONS
			if ((side (group _victim)) isEqualTo (side (group _killer))) then {
				a3a_var_cli_killedAllies pushBack _victimName
			} else {
				a3a_var_cli_killedEnemies pushBack _victimName
			};
		};
	};
};

"A3A_var_onPVKilled" addPublicVariableEventHandler { (_this select 1) call a3a_fnc_cli_onPVKilled };

A3A_fnc_cli_onKilled = {
	private ["_victim", "_killer"];
	_victim = _this select 0;
	_killer = _this select 1;
	if (!(isNull _killer) && !(isNull _victim)) then {
		diag_log format["[KILLED EH] Victim: %1 Killer: %2",
			(_victim getVariable ["PlayerName", [name _victim]]) select 0,
			(_killer getVariable ["PlayerName", [name _killer]]) select 0
		];
		if !(_killer isEqualTo _victim) then {
			A3A_var_onPVKilled = _this;
			publicVariable "A3A_var_onPVKilled";
		};
		a3a_var_cli_myKiller = (_killer getVariable ["PlayerName", [name _killer]]) select 0;
	};
};

player addEventHandler ["Killed", { _this call A3A_fnc_cli_onKilled }];