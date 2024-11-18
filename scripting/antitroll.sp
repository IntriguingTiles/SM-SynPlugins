#include <sourcemod>
#include <admin>
#include <sdktools>
#include <sdkhooks>

public Plugin myinfo =
{
	name = "Anti-Troll",
	author = "IntriguingTiles",
	description = "Various anti-trolling measures.",
	version = "1.0"
};

public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon, int &subtype, int &cmdnum, int &tickcount, int &seed, int mouse[2])
{
	if (impulse == 50)
	{
		if (!GetAdminFlag(GetUserAdmin(client), Admin_Generic))
		{
			// LogAction(0, client, "Blocked impulse 50 from \"%L\"", client);
			impulse = 0;
		}
	}

	return Plugin_Continue;
}

public void OnEntityCreated(int entity, const char[] classname)
{
	if (StrEqual(classname, "prop_vehicle_jeep_episodic"))
	{
		SDKHook(entity, SDKHook_Use, OnJalopyUse);
		LogAction(0, -1, "Hooked use on jalopy %d", entity);
	}
}

public Action OnJalopyUse(int entity, int activator, int caller, UseType type, float value)
{
	if (activator <= 0) return Plugin_Continue;

	char vehiclescript[128];
	GetEntPropString(entity, Prop_Data, "m_vehicleScript", vehiclescript, sizeof(vehiclescript));

	if (!StrEqual(vehiclescript, "scripts/vehicles/jalopy.txt"))
	{
		return Plugin_Continue;
	}

	if (!GetAdminFlag(GetUserAdmin(activator), Admin_Generic))
	{
		// LogAction(0, activator, "Blocked jalopy use from \"%L\"", activator);
		return Plugin_Handled;
	}

	return Plugin_Continue;
}