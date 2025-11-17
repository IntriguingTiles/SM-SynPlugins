#include <sourcemod>
#include <sdktools>

public Plugin myinfo =
{
	name = "sm_televeh",
	author = "IntriguingTiles",
	description = "Teleports occupied vehicles.",
	version = "1.0",
};

public void OnPluginStart()
{
	RegAdminCmd("sm_televeh", Cmd_TeleVeh, ADMFLAG_GENERIC);
}

public Action Cmd_TeleVeh(int client, int args)
{
	float vec[3];
	float ang[3];

	GetClientAbsOrigin(client, vec);
	GetClientAbsAngles(client, ang);

	int entity = FindEntityByClassname(-1, "prop_vehicle_*");

	while (entity != -1)
	{
		int driver = GetEntPropEnt(entity, Prop_Send, "m_hPlayer");

		if (driver != -1 && driver != client)
		{
			TeleportEntity(entity, vec, ang, { 0.0, 0.0, 0.0 });
		}

		entity = FindEntityByClassname(entity, "prop_vehicle_*");
	}

	ShowActivity2(client, "[SM] ", "teleported all occupied vehicles.");

	return Plugin_Handled;
}