SerP_msg = {//["Hello world!",west] call SerP_msg;
	if (count(_this)==2) then {
		[["SerP_message",["",(_this select 0)]],"BIS_fnc_showNotification",_this select 1,false] spawn BIS_fnc_MP;
	}else{
		[["SerP_message",["",(_this select 0)]],"BIS_fnc_showNotification",nil,false] spawn BIS_fnc_MP;
	};
};
SerP_notification = {// [["SerP_message",["title",text]],west] call SerP_msg;
	if (count(_this)==2) then {
		[_this select 0,"BIS_fnc_showNotification",_this select 1,false] spawn BIS_fnc_MP;
	}else{
		[_this select 0,"BIS_fnc_showNotification",nil,false] spawn BIS_fnc_MP;
	};
};
