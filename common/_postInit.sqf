if (!isDedicated) then {	
	call compile format["'SerP_markers_%1' addPublicVariableEventHandler {(_this select 1) call SerP_updateMarkers}; if (count(SerP_markers_%1 select 1)>0) then {SerP_markers_%1 call SerP_updateMarkers}", side group player];

	crewIndex = false;
    arrRelCrew = [];
    arrRelCommander = [];
    if (!isnil{relCrew}) then { arrRelCrew = arrRelCrew + relCrew; };
    if (!isnil{relCommander}) then { arrRelCommander = arrRelCommander + relCommander; };
    if (vehicle player != player && {!isnil {(vehicle player) getVariable "CREW_GETININDEX"}}) then { [[(vehicle player), "", player], (vehicle player) getVariable "CREW_GETININDEX"] call fnc_inCrew};

	if (SerP_debugToggle == 1) then {
		call SerP_addSeparatorToMenu;
		["Teleport", 0, {
			hint "Click on map to teleport";
			onMapSingleClick "vehicle player setPos [_pos select 0,_pos select 1,0]; openMap false;onMapSingleClick '';";
			openMap true;
			closeDialog 0;
		}, {SerP_debugToggle == 1}, {SerP_debugToggle == 1}] call SerP_addToMenu;
	}
};