#include "_main.hpp"

if (isServer) then
{
	(group (_this select 0)) setVariable [GROUP_BP_POINTS_VARIABLE, _this select 1, true];
};