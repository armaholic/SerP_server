
SerP_getZones = {//{fnc that return size of zone}
	_getZoneSize = _this;
	_zones = [];//[_pos,_size,_unitsInZone,_side]
	{
		_unitPos = getPos vehicle(_x);
		_unit = _x;
		_side = side _x;
		_size = _side call _getZoneSize;
		_teleportTo = [];
		if (waypointDescription(waypoints(group _unit) select 1)=="teleport") then {
			{
				if (waypointDescription(_x)=="teleport") then {
					_teleportTo = _teleportTo + [waypointPosition(_x)];
				};
			} forEach waypoints(group _unit);
			while {(waypointDescription(waypoints(group _unit) select 1)=="teleport")} do {
				deleteWaypoint (waypoints(group _unit) select 1);
			};
		};
		_outOfZone = true;
		{
			_zonePos = _x select 0;
			_zoneSize = _x select 1;
			_unitsInZone = _x select 2;
			_zoneSide = _x select 3;
			_units = _x select 4;
			_zonesToTeleport = _x select 5;
			_dist = (_unitPos distance _zonePos);
			if ((_dist < (_size + _zoneSize))&&(_side==_zoneSide)) exitWith {//zone concat
				_unitmod = 1/_unitsInZone;
				_sizemod = (_unitsInZone-1)/_unitsInZone;
				_pos = [(_unitPos select 0)*_unitmod+(_zonePos select 0)*_sizemod,(_unitPos select 1)*_unitmod+(_zonePos select 1)*_sizemod,0];
				_zoneSize = (_size+_dist) max _zoneSize;
				_zones set [_forEachIndex,[_pos,_zoneSize,_unitsInZone+1,_zoneSide,_units + [_unit],_zonesToTeleport+_teleportTo]];
				_outOfZone = false;
			};
		} forEach _zones;
		if (_outOfZone) then {
			_zones set [count _zones,[_unitPos,_size,1,_side,[_x],_teleportTo]]
		};
		_x setVariable ["SerP_isPlayer",(isPlayer _x)];
	} forEach playableUnits;
	_exit = false;
	while {!_exit} do {
		_exit = true;
		{
			_zonePos1 = _x select 0;
			_size1 = _x select 1;
			_unitsInZone1 = _x select 2;
			_zoneSide1 = _x select 3;
			_units1 = _x select 4;
			_zoneToTeleport1 = _x select 5;
			_i = _forEachIndex;
			{
				_zonePos2 = _x select 0;
				_size2 = _x select 1;
				_unitsInZone2 = _x select 2;
				_zoneSide2 = _x select 3;
				_units2 = _x select 4;
				_zoneToTeleport2 = _x select 5;
				_j = _forEachIndex;
				if ((_i!=_j)&&(_zonePos1 distance _zonePos2)<(_size1+_size2)&&(_zoneSide1==_zoneSide2)) exitWith {
					_pos = [((_zonePos1 select 0)+(_zonePos2 select 0))/2,((_zonePos1 select 1)+(_zonePos2 select 1))/2,0];
					_size = ((_zonePos1 distance _zonePos2)/2 + _size1 max _size2);
					_zones set [_i,[_pos,_size,_unitsInZone1+_unitsInZone2,_zoneSide1,_units1+_units2,_zoneToTeleport1+_zoneToTeleport2]];
					_zones set [_j,-1];
					_zones = _zones - [-1];
					_exit = false;
				};
			} forEach _zones;
			if (!_exit) exitWith {};
		} forEach _zones;
	};
	_zones;
};

SerP_getTeleportList = {//[_zones, _zoneSelector]
	_zones = _this select 0;
	_zoneSelector = _this select 1;
	_teleportList = [];
	{
		_zone = _x;
		_zonePos = _x select 0;
		_size = _x select 1;
		_zoneSide = _x select 3;
		_units = _x select 4;
		_zonesToTeleport = _x select 5;
		_teleportTo = switch true do {
			case (count(_zonesToTeleport)==0): {0};
			case (SerP_synchronizedRespawn!=0): {(SerP_startSeed%(count(_zonesToTeleport)+1))};
			case (SerP_synchronizedRespawn==0): {round(random(1000+({isPlayer(_x)} count playableUnits)))%(count(_zonesToTeleport)+1)};
			default {0};
		};
		if (_teleportTo>0) then {
			if (_teleportTo>0) then {//0 means that units stay still
				_newZonePos = _zonesToTeleport select(_teleportTo-1);
				_zone set [0,_newZonePos];
				{
					_unitpos = getPosASL _x;
					_diff = [((_unitpos select 0) - (_zonePos select 0)),((_unitpos select 1) - (_zonePos select 1)),0];
					_newPos = [((_newZonePos select 0)+(_diff select 0)),((_newZonePos select 1)+(_diff select 1)),0];
					if (vehicle(_x) == _x) then {
						_teleportList set [count _teleportList,[_x,_newPos]];
						_x setVariable ["SerP_startPos",_newPos,true];
					};
					if (_x == leader(group _x)) then {
						[_zoneSide,["SerP_startposMarker"+str(group _x),_newPos,"mil_start",[1,1],str(group _x),"ColorGreen",1,"SOLID","ICON"]] call SerP_addMarker; //РёСЃРїСЂР°РІРёР» РєР»Р°СЃСЃ РјР°СЂРєРµСЂР° - bn_
					};
				} forEach _units;
				{
					if (((_x distance _zonePos)<SerP_hintzonesize+_size)&&locked(_x)<2) then {		// Р±С‹Р»Рѕ:  &&!locked(_x)
						_unitpos = getPosASL _x;
						_diff = [((_unitpos select 0) - (_zonePos select 0)),((_unitpos select 1) - (_zonePos select 1)),0];
						_newPos = [((_newZonePos select 0)+(_diff select 0)),((_newZonePos select 1)+(_diff select 1)),0];
						_teleportList set [count _teleportList,[_x,_newPos]];
						[_zoneSide,["",_newPos,"mil_box",[1,1],getText(configFile >> "CfgVehicles" >> typeOf(_x) >> "displayName"),"ColorWhite",1,"SOLID","ICON"]] call SerP_addMarker;
					};
				} forEach _objectList;
			};
			[_zoneSide,["",_x select 0,"mil_dot",[_size,_size],"","ColorGreen",1,"SOLID","Ellipse"]] call SerP_addMarker;
		}else{
			{
				if (_x == leader group _x) then {
					[_zoneSide,[SerP_startposMarkerPrefix+str(group _x),getPos _x,"mil_start",[1,1],"","ColorGreen",1,"SOLID","ICON"]] call SerP_addMarker;
				};
				_x setVariable ["SerP_startPos",getPos _x,true];
			} forEach _units;
			{
				if (((_x distance _zonePos)<SerP_hintzonesize+_size)&&locked(_x)<2) then {
					[_zoneSide,["",getPos _x,"mil_box",[1,1],getText(configFile >> "CfgVehicles" >> typeOf(_x) >> "displayName"),"ColorWhite",1,"SOLID","ICON"]] call SerP_addMarker;
				};
			} forEach _objectList;
			[_zoneSide,["",_zonePos,"mil_dot",[_size,_size],"","ColorGreen",1,"SOLID","Ellipse"]] call SerP_addMarker;
		};
	} forEach _zones;
	[_zones,_teleportList];
};

SerP_toggleReady = {
	if (player != leader group player) exitWith {};
	_sideIndex = 2;
	_side = side player;
	switch (side player) do {
		case (SerP_sideREDFOR): {_sideIndex = 1;_side = "REDFOR";};
		case (SerP_sideBLUEFOR): {_sideIndex = 0;_side = "BLUEFOR";};
	};
	if (SerP_readyArray select _sideIndex) then {
		SerP_readyArray set [_sideIndex, false];
		publicVariable "SerP_readyArray";
		[_side+" not ready ("+name player+")"] call SerP_msg;
	} else {
		SerP_readyArray set [_sideIndex, true];
		publicVariable "SerP_readyArray";
		[_side+" ready ("+name player+")"] call SerP_msg;
	};	
};

call SerP_addSeparatorToMenu;

_isEndBriefingCommanderAvailable = {
	((player == leader group player) && SerP_warbegins == 0)
};
["End briefong", 0, {call SerP_toggleReady}, _isEndBriefingCommanderAvailable, _isEndBriefingCommanderAvailable] call SerP_addToMenu;

call SerP_addSeparatorToMenu;
_isEndBriefingAdminAvailable = {
	(((serverCommandAvailable "#kick")||isServer) && SerP_warbegins == 0)
};
_endBriefingAdmin = {
	["All ready ("+name player+")"] call SerP_msg;
	SerP_warbegins=1;
	publicVariable "SerP_warbegins";
};

["End briefong(Admin)", 0, _endBriefingAdmin, _isEndBriefingAdminAvailable, _isEndBriefingAdminAvailable] call SerP_addToMenu;

SerP_blocker = {
	while _this do {
		_veh = vehicle player;
		_firedEH = _veh addEventHandler ["fired", {deleteVehicle (_this select 6)}];
		waitUntil {sleep .1;(_veh != (vehicle player)) || !([] call _this)};
		_veh removeEventHandler ["fired", _firedEH];
	};
};
