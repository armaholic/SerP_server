private ["_timeOfDay","_weather","_MissionOvercast","_MissionFog"];

if (time<300) then {//time will be automatically synchronised during JIP
	_defDate = date;
	switch (SerP_timeOfDay) do	{
		case 0:	{
			setDate [_defDate select 0, _defDate select 1, _defDate select 2, 4, 50];
		};
		case 1:	{
			setDate [_defDate select 0, _defDate select 1, _defDate select 2, 5, 50];
		};
		case 2:	{
			setDate [_defDate select 0, _defDate select 1, _defDate select 2, 9, 00];
		};
		case 3:	{
			setDate [_defDate select 0, _defDate select 1, _defDate select 2, 12, 0];
		};
		case 4:	{
			setDate [_defDate select 0, _defDate select 1, _defDate select 2, 15, 00];
		};
		case 5:	{
			setDate [_defDate select 0, _defDate select 1, _defDate select 2, 17, 50];
		};
		case 6:	{
			setDate [_defDate select 0, _defDate select 1, _defDate select 2, 18, 50];
		};
		case 7:	{
			setDate [_defDate select 0, _defDate select 1, _defDate select 2, 0, 0];
		};
		default	{};
	};
	_MissionOvercast = 00.00;
	_MissionFog = 00.00;
	
	_changeWeather = true;
	switch (SerP_weather) do	{
	// Clear
		case 0: {
			_MissionOvercast = 00.00;
			_MissionFog = 00.00;
		};
	// Overcast
		case 1: {
			_MissionOvercast = 00.60;
			_MissionFog = 00.10;
		};
	// Light Fog
		case 2: {
			_MissionOvercast = 00.60;
			_MissionFog = 00.20;
		};
	// Heavy Fog
		case 3: {
			_MissionOvercast = 00.60;
			_MissionFog = 00.30;
		};
	// Storm
		case 4: {
			_MissionOvercast = 01.00;
			_MissionFog = 00.20;

		};
	//default
		default {_changeWeather = false;};
	};
	if (_changeWeather && isServer) then {
		0 setOvercast _MissionOvercast;
		0 setFog _MissionFog;
		simulWeatherSync;
		skiptime 1;
		simulWeatherSync;
		setDate _defDate;
	}
};
