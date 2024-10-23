#include <sourcemod>
#include <sdktools>

public Plugin myinfo =
{
	name = "sm_givecamera",
	author = "IntriguingTiles",
	description = "Gives you control of the prisoner pod camera.",
	version = "1.0"
};

public void OnPluginStart()
{
	RegAdminCmd("sm_givecamera", GiveCamera, ADMFLAG_GENERIC);
}

public Action GiveCamera(int client, int args)
{
	// players have m_hVehicle
	// vehicles have m_hPlayer
	// so fetch the m_hVehicle from the calling player and change m_hPlayer to the calling player
	int vehicle = GetEntPropEnt(client, Prop_Send, "m_hVehicle");

	if (vehicle == -1)
	{
		ReplyToCommand(client, "[SM] You are not in a vehicle.");
		return Plugin_Handled;
	}

	int curCameraOwner = GetEntPropEnt(vehicle, Prop_Send, "m_hPlayer");

	if (curCameraOwner == client)
	{
		ReplyToCommand(client, "[SM] You already have control of the camera.");
		return Plugin_Handled;
	}

	if (curCameraOwner == -1)
	{
		ReplyToCommand(client, "[SM] There is no owner of the camera.");
		return Plugin_Handled;
	}

	SetEntPropEnt(vehicle, Prop_Send, "m_hPlayer", client);
	ShowActivity2(client, "[SM] ", "took camera control.");

	return Plugin_Handled;
}