#include "_main.hpp"

if (isServer) then
{
	[] call compile preprocessFileLineNumbers (_PREFIX_ + "_server.sqf");
};

if (!isDedicated) then
{
	[] execVM (_PREFIX_ + "_client.sqf");
};