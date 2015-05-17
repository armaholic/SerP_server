//[marker, capturetime, defender, callback] spawn SerP_endMissionCapture;
if (!isServer) exitWith {};

_marker = _this select 0;
_captureTime = (_this select 1)*60;
_defender = if (count _this > 2) then {_this select 2} else {civilian};
_winCallback = if (count _this > 3) then {_this select 3} else {{}};

sleep 10;

_pos = markerPos _marker;
_dir = markerDir _marker;
_size = getMarkerSize _marker;
_shape = markerShape _marker;

_rectangele = (_shape == "RECTANGLE");
_trigger = createTrigger["EmptyDetector",_pos];
_trigger setTriggerActivation ["ANY", "PRESENT", true];
_trigger setTriggerArea [_size select 0, _size select 1, _dir, _rectangele];
_trigger setTriggerStatements[
"",
"",
""
];

_sides = [[west,0],[east,0],[resistance,0]];
_counter = 0;
_startTime = diag_ticktime;
_capturer = civilian;
_loop = true;
while {_loop} do {
	sleep 5;


	_currentCapturer = civilian;
	_sidesInZone = 0;
	_maxCountSide = 0;
	{
		_side = _x select 0;
		_countSide = {isPlayer _x && side _x == _side} count list _trigger;
		_sides set [_forEachIndex,[_side,_countSide]];
		if (_countSide>0) then {
			_currentCapturer = _side;
			_sidesInZone = _sidesInZone + 1;
		};
	} forEach _sides;
	if (_sidesInZone>1) then {
		_currentCapturer = civilian;
	};

	switch true do {
		case (_currentCapturer==civilian&&_capturer!=civilian): {
			["Р—РѕРЅР° РЅРµР№С‚СЂР°Р»СЊРЅР°"] call SerP_msg;
			_capturer = civilian;
			_startTime = diag_ticktime;
		};
		case (_currentCapturer==civilian&&_capturer==civilian): {};
		case (_sidesInZone==1&&_capturer!=_currentCapturer): {
			[format ["%1 РєРѕРЅС‚СЂРѕР»РёСЂСѓСЋС‚ Р·РѕРЅСѓ",_currentCapturer]] call SerP_msg;
			_startTime = diag_ticktime;
			_capturer = _currentCapturer;
			_counter = 0;
		};
		case (_currentCapturer!=_defender&&_sidesInZone==1&&_capturer==_currentCapturer&&diag_ticktime>_startTime+_captureTime): {
		if (count _this > 3) then  {
				_currentCapturer call _winCallback;
				_loop = false;
			} else {
				[format ["%1 Р·Р°С…РІР°С‚РёР»Рё Р·РѕРЅСѓ",_currentCapturer]] call SerP_endmission;
			}
		};
		case (_currentCapturer!=_defender&&_sidesInZone==1&&_capturer==_currentCapturer&&diag_ticktime>_startTime+_counter*60): {
			_min = round((_captureTime-_counter*60)/60);
			_end = switch (true) do {
				case (_min==1): {"Р°"};
				case (_min<5): {"С‹"};
				default {""};
			};
			[format ["Р”Рѕ Р·Р°С…РІР°С‚Р° Р·РѕРЅС‹ СЃС‚РѕСЂРѕРЅРѕР№ %1 РѕСЃС‚Р°Р»РѕСЃСЊ %2 РјРёРЅСѓС‚%3",_currentCapturer,_min,_end]] call SerP_msg;
			_counter = _counter+1;
		};
		default {};
	};
};