#include <sourcemod>
#include <sdktools>

public Plugin myinfo =
{
	name = "sm_crane_driver",
	author = "IntriguingTiles",
	description = "Gets the crane driver's name",
	version = "1.0",
};

public void OnPluginStart()
{
	RegAdminCmd("sm_crane_driver", Cmd_CraneDriver, ADMFLAG_GENERIC);
}

public Action Cmd_CraneDriver(int client, int args)
{
	int crane = FindEntityByClassname(-1, "prop_vehicle_crane");
	if (crane == -1)
	{
		ReplyToCommand(client, "[SM] No crane found.");
		return Plugin_Handled;
	}

	int driver = GetEntPropEnt(crane, Prop_Send, "m_hPlayer");
	if (driver == -1)
	{
		ReplyToCommand(client, "[SM] No driver found.");
		return Plugin_Handled;
	}

	ReplyToCommand(client, "[SM] Crane driver: %N", driver);

	return Plugin_Handled;
}