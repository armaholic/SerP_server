class CfgNotifications
{
	class SerP_freeztimeCounter
	{
		title = "%1";
		iconPicture = "\A3\UI_F\data\IGUI\Cfg\Actions\settimer_ca.paa";
		iconText = "";
		description = "%2";
		color[] = {1,1,1,1};
		duration = 5;
		priority = 5;
		difficulty[] = {};
	};
	class SerP_message
	{
		title = "%1";
		iconPicture = "\A3\ui_f\data\map\mapcontrol\taskIcon_ca.paa";
		iconText = "";
		description = "%2";
		color[] = {1,1,1,1}; 
		duration = 5;
		priority = 5;
		difficulty[] = {};
	};
	class SerP_warbegins
	{
		title = "%1";
		iconPicture = "\A3\ui_f\data\map\mapcontrol\taskIcon_ca.paa";
		iconText = "";
		description = "%2";
		color[] = {1,0,0,1}; 
		duration = 5;
		priority = 10;
		difficulty[] = {};
		sound = "FD_Course_Active_F";
	};	
	class SerP_alarm
	{
		title = "%1";
		iconPicture = "\A3\ui_f\data\map\mapcontrol\taskIcon_ca.paa";
		iconText = "";
		description = "%2";
		color[] = {1,0,0,1}; 
		duration = 3;
		priority = 10;
		difficulty[] = {};
		sound = "Alarm"; 
	};
};