diag_log "serp fn_preinit";
diag_log paramsArray;
if (!(call compile preprocessFileLineNumbers "SerP\_launchCondition.sqf")) exitWith {};

SerP_debug = { };
SerP_processParams = {	//вот это с версии 1.44 не работает, бисы сломали что-то в параметрах
	diag_log "SerP_processParams";
	for [ { _i = 0 }, { _i < count(paramsArray) }, { _i = _i + 1 } ] do	{
		_paramName =(configName ((missionConfigFile >> "Params") select _i));
		_paramValue = (paramsArray select _i);
		_paramCode = ( getText (missionConfigFile >> "Params" >> _paramName >> "code"));
		call compile format[_paramCode, _paramValue];
	};

	if (SerP_debugToggle == 1) then {
		SerP_debug = { 
			diag_log str _this;
			player createDiaryRecord ["diary", ["SerP - debug",str _this]];
		};
	};
};

SerP_getParamNumber = {
	getNumber(missionConfigFile >> "SerP_const" >> _this);
};
SerP_getParamText = {
	getText(missionConfigFile >> "SerP_const" >> _this);
};
SerP_getParamTextCompile = {
	call compile getText(missionConfigFile >> "SerP_const" >> _this);
};

SerP_zoneSizeDefault = "zoneSizeDefault" call SerP_getParamNumber;
SerP_hintzonesize = "hintzonesize" call SerP_getParamNumber;
SerP_zoneSizeREDFOR = "zoneSizeREDFOR" call SerP_getParamNumber;
SerP_zoneSizeBLUEFOR = "zoneSizeBLUEFOR" call SerP_getParamNumber;
SerP_domiMult = "domiMult" call SerP_getParamNumber;
SerP_RFRetreat = "RFRetreat" call SerP_getParamNumber;
SerP_BFRetreat = "BFRetreat" call SerP_getParamNumber;
SerP_synchronizedRespawn = "synchronizedRespawn" call SerP_getParamNumber;
SerP_viewDistance = ("viewDistance" call SerP_getParamNumber) min 3500;

SerP_sideREDFOR = "sideREDFOR" call SerP_getParamTextCompile;
SerP_sideBLUEFOR = "sideBLUEFOR" call SerP_getParamTextCompile;
SerP_titleREDFOR = "titleREDFOR" call SerP_getParamText;
SerP_titleBLUEFOR = "titleBLUEFOR" call SerP_getParamText;
SerP_vehHolderExludeCondition = "vehHolderExludeCondition" call SerP_getParamText;

SerP_startposMarkerPrefix = "SerP_startposMarker";
SerP_modulesAdd = getArray(missionConfigFile >> "SerP_const" >> "modulesAdd");
SerP_modulesRemove = getArray(missionConfigFile >> "SerP_const" >> "modulesRemove");
SerP_modulesDefault = call compile preprocessFileLineNumbers "SerP\_defaultModules.sqf";
SerP_modules = ["common"]+(SerP_modulesDefault - SerP_modulesRemove + SerP_modulesAdd);

if (isServer) then {call SerP_processParams;};

SerP_log = { diag_log _this;};

enableSaving [false, false];
enableEngineArtillery false;
enableSentences false;

{
	("preInit "+_x+" start") call SerP_debug;
	call compile preprocessFileLineNumbers ("SerP\"+_x+"\_preInit.sqf");
	("preInit "+_x+" end") call SerP_debug;
} forEach SerP_modules;
