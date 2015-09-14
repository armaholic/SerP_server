
class SerpMod_Buildsys_MyRscListBox  
	{
		type = 5;
		style = 0x00;
		
		x = 0.25 * safezoneW + safezoneX;
		y = 0.25 * safezoneH + safezoneY;
		w = 0.5 * safezoneW;
		h = 0.5 * safezoneH;

		font = "puristaMedium";
		sizeEx = 0.04;
		rowHeight = 0;
		colorText[] = {1,1,1,1};
		colorDisabled[] = {1,1,1,1};
		colorScrollbar[] = {1,1,1,1};
		colorSelect[] = {0,0,0,1};
		colorSelect2[] = {1,0.5,0,1};
		colorSelectBackground[] = {0.6,0.6,0.6,1};
		colorSelectBackground2[] = {0.2,0.2,0.2,1}; 
		colorBackground[] = {0,0,0,0.5};
		maxHistoryDelay = 1.0;
		soundSelect[] = {"",0.1,1};
		period = 1;
		autoScrollSpeed = -1;
		autoScrollDelay = 5; 
		autoScrollRewind = 0;
		arrowEmpty = "#(argb,8,8,3)color(1,1,1,1)"; 
		arrowFull = "#(argb,8,8,3)color(1,1,1,1)";
		shadow = 2;
				
		
		class ListScrollBar 
		{
			color[] = {1,1,1,1};
			autoScrollEnabled = 1;
			
			colorActive[] = {1, 1, 1, 1};
			colorDisabled[] = {1, 1, 1, 0.3};
			thumb = "\A3\ui_f\data\gui\cfg\scrollbar\thumb_ca.paa";
			arrowFull = "\A3\ui_f\data\gui\cfg\scrollbar\arrowFull_ca.paa";
			arrowEmpty = "\A3\ui_f\data\gui\cfg\scrollbar\arrowEmpty_ca.paa";
			border = "\A3\ui_f\data\gui\cfg\scrollbar\border_ca.paa";
		};
		
//		class ScrollBar {
//			color[] = {1,1,1,0.6};
//			colorActive[] = {1,1,1,1};
//			colorDisabled[] = {1,1,1,0.3};
//			thumb = "#(argb,8,8,3)color(1,1,1,1)";
//			arrowEmpty = "#(argb,8,8,3)color(1,1,1,1)";
//			arrowFull = "#(argb,8,8,3)color(1,1,1,1)";
//			border = "#(argb,8,8,3)color(1,1,1,1)"; shadow = 0;
//		};
	 };

class SerpMod_BuildSys_FortTypeDialog
{
	idd = -1;
	movingEnable = false;
	enableSimulation = true;
	controlsBackground[] = { };
	objects[] = { };
	controls[] = { FTList };

	class FTList: SerpMod_Buildsys_MyRscListBox
	{
		idc = 1;
		
		x = 0.25 * safezoneW + safezoneX;
		y = 0.25 * safezoneH + safezoneY;
		w = 0.5 * safezoneW;
		h = 0.5 * safezoneH;
		
		onLBSelChanged = "_this call compile preprocessFileLineNumbers ('Serp\modules\buildsys\_on_ftlist_sel.sqf')";
	 };
};

class SerpMod_BuildSys_BuildAllowanceDialog
{
	idd = -1;
	movingEnable = false;
	enableSimulation = true;
	controlsBackground[] = { };
	objects[] = { };
	controls[] = { GPList };

	class GPList: SerpMod_Buildsys_MyRscListBox
	{
		idc = 1;

		x = 0.25 * safezoneW + safezoneX;
		y = 0.25 * safezoneH + safezoneY;
		w = 0.5 * safezoneW;
		h = 0.5 * safezoneH;
				
		onLBSelChanged = "_this call compile preprocessFileLineNumbers ('serp\modules\buildsys\_on_gplist_sel.sqf')";
	 };
};


