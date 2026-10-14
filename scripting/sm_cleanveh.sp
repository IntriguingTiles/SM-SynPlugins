#include <sourcemod>
#include <sdktools>

public Plugin myinfo =
{
	name = "sm_cleanveh",
	author = "IntriguingTiles",
	description = "Removes empty vehicles.",
	version = "1.0",
};

public void OnPluginStart()
{
	RegAdminCmd("sm_cleanveh", Cmd_CleanVeh, ADMFLAG_GENERIC);
}

public Action Cmd_CleanVeh(int client, int args)
{
	int entity = FindEntityByClassname(-1, "prop_vehicle_*");
	int count = 0;

	while (entity != -1)
	{
		int driver = GetEntPropEnt(entity, Prop_Send, "m_hPlayer");

		// TODO: m_hPassengers: confirm this works as expected
		int passengerCount = GetEntPropArraySize(entity, Prop_Send, "m_hPassengers");

		if (driver == -1 && passengerCount == 0)
		{
			char classname[64];
			GetEntityClassname(entity, classname, sizeof(classname));
			if (!StrEqual(classname, "prop_vehicle_choreo_generic")
				&& !StrEqual(classname, "prop_vehicle_apc")
				&& !StrEqual(classname, "prop_vehicle_crane")
				&& !StrEqual(classname, "prop_vehicle_prisoner_pod"))
			{
				RemoveEntity(entity);
				count++;
			}
		}

		entity = FindEntityByClassname(entity, "prop_vehicle_*");
	}

	ShowActivity2(client, "[SM] ", "removed %d empty vehicles.", count);

	return Plugin_Handled;
}