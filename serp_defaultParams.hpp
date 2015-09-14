	class timeOfDay {
		title = "$STR_SerP_timeOfDay";
		values[] = {0,1,2,3,4,5,6,7,8};
		texts[] = {$STR_SerP_timeOfDay_Option0,$STR_SerP_timeOfDay_Option1,$STR_SerP_timeOfDay_Option2,$STR_SerP_timeOfDay_Option3,$STR_SerP_timeOfDay_Option4,$STR_SerP_timeOfDay_Option5,$STR_SerP_timeOfDay_Option6,$STR_SerP_timeOfDay_Option7,$STR_SerP_timeOfDay_Option8};
		default = 8;
		code = "SerP_timeOfDay = %1";
	};
	class weather {
		title = "$STR_SerP_weather";
		values[] = {0,1,2,3,4,5};
		texts[] = {$STR_SerP_weather_Option0,$STR_SerP_weather_Option1,$STR_SerP_weather_Option2,$STR_SerP_weather_Option3,$STR_SerP_weather_Option4,$STR_SerP_weather_Option5};
		default = 5;
		code = "SerP_weather = %1";
	};
	class briefing_mode {
		title = "$STR_SerP_briefing_mode";
		values[] = {0,1,2,3};
		texts[] = {$STR_SerP_briefing_mode_Option0,$STR_SerP_briefing_mode_Option1,$STR_SerP_briefing_mode_Option2,$STR_SerP_briefing_mode_Option3};
		default = 1;
		code = "SerP_briefingMode = %1; diag_log 'params'; diag_log SerP_briefingMode";
	};
	class loading {
		title = "$STR_SerP_loading";
		values[] = {0,1,2};
		texts[] = {$STR_SerP_loading_Option0,$STR_SerP_loading_Option1,$STR_SerP_loading_Option2};
		default = 1;
		code = "SerP_loading = %1";
	};
	class endMission {
		title = "$STR_SerP_endMission";
		values[] = {1,0};
		texts[] = {$STR_SerP_On,$STR_SerP_Off};
		default = 1;
		code = "SerP_endMissionToggle = %1";
	};
	class spectator {
		title = "$STR_SerP_SpectatorLimitations";
		values[] = {1,0};
		texts[] = {$STR_SerP_On,$STR_SerP_Off};
		default = 1;
		code = "SerP_spectatorLimitations = %1";
	};
	class debug {
		title = "$STR_SerP_debug";
		values[] = {1,0};
		texts[] = {$STR_SerP_On,$STR_SerP_Off};
		default = 0;
		code = "SerP_debugToggle = %1";
	};
