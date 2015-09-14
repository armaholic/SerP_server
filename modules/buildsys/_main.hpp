#ifndef __MAIN_HPP_
#define __MAIN_HPP_

#define _PREFIX_ "Serp\modules\buildsys\"


#define BASENAME misbuildsys
#define FUNC(x) fnc_##BASENAME##_##x
#define GVAR(x) BASENAME##_##x
#define PV(x) private ['x']; x



// remote commands (public vars with event handlers)

#define RC_DEFINE(x) fnc_##BASENAME##RC_##x 
#define RC_INIT_EH(x) 'BASENAME##RC_##x' addPublicVariableEventHandler {(_this select 1) call fnc_##BASENAME##RC_##x;}

#define RC_FUNC(x) fnc_##BASENAME##RC_##x
#define RC_VAR(x) ##BASENAME##RC_##x

// should be defined to pass params
#define RC_EXEC_ARG []

#define RC_EXEC_AC(x) BASENAME##RC_##x = (RC_EXEC_ARG); \
	publicVariable 'BASENAME##RC_##x'; \
	if (!isDedicated) then {BASENAME##RC_##x call fnc_##BASENAME##RC_##x;}
	
#define RC_EXEC_S(x) if (isServer) then \
	{(RC_EXEC_ARG) call fnc_##BASENAME##RC_##x;} else \
	{BASENAME##RC_##x = (RC_EXEC_ARG); publicVariableServer 'BASENAME##RC_##x';}
	
#define RC_EXEC_C(x,z) BASENAME##RC_##x = (RC_EXEC_ARG); \
	(z) publicVariableClient 'BASENAME##RC_##x'



// other

#define GROUP_BP_POINTS_VARIABLE "misBuildSys_BPCount"
#define PLAYER_BUILDING_ALLOWANCE_VARIABLE "misBuildSys_AllowedToBuild"
#define OWN_FORTS_MARK_VARIABLE "misBuildSys_isFort"


// fort data access macros

// title name, object name, cost, on land only
  
#define FDA_TITLE(x) ((x) select 0)
#define FDA_OBJ(x) ((x) select 1)
#define FDA_COST(x) ((x) select 2)
#define FDA_LANDONLY(x) ((x) select 3)
#define FDA_DIST(x) ((x) select 4)
#define FDA_DAMAGE(x) ((x) select 5)
                        


#define ADJUST_DISTANCE_MULT 0.5


#define BASE_ACTION_PRIORITY 100






#endif
