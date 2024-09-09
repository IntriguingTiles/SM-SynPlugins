#include <sourcemod>
#include <sdktools>

public Plugin myinfo =
{
	name = "Anti-Noclip",
	author = "IntriguingTiles",
	description = "Disables noclip for players who are not admins.",
	version = "1.0"
};

public void OnPluginStart()
{
	RegAdminCmd("sm_checknoclip", CheckNoclip, ADMFLAG_GENERIC);
	// HookEvent("player_spawn", Event_PlayerSpawn);
	// HookEvent("player_activate", Event_PlayerSpawn);
	// HookEvent("player_disconnect", Event_PlayerSpawn, EventHookMode_Pre);
}

// public void OnClientPutInServer(int client) {
//     RemoveNoclip(false, client, 0);
// }

// public void OnClientDisconnect(int client) {
//     RemoveNoclip(false, client, 0);
// }
public void RemoveNoclip(bool teleportToClient, int client, int clientToTeleportTo)
{
	if (IsClientInGame(client))
	{
		if (GetEntityMoveType(client) == MOVETYPE_NOCLIP)
		{
			// PrintToChat(client, "[SM] collision group on %N is %d", i, GetEntProp(client, Prop_Send, "m_CollisionGroup"));
			if (GetEntPropEnt(client, Prop_Data, "m_hMoveParent") == -1)
			{
				if (teleportToClient)
				{
					float vec[3];
					float ang[3];

					SetEntityMoveType(client, MOVETYPE_WALK);
					GetClientAbsOrigin(clientToTeleportTo, vec);
					GetClientAbsAngles(clientToTeleportTo, ang);
					TeleportEntity(client, vec, ang, { 0.0, 0.0, 0.0 });
					// SetEntPropVector(client, Prop_Send, "m_vecOrigin", vec);
				}
				else {
					SetEntityMoveType(client, MOVETYPE_WALK);
					// ForcePlayerSuicide(client);
				}
				ShowActivity(0, "[SM] Disabled noclip on %N", client);
			}
		}
	}
}

public Action Event_PlayerSpawn(Handle event, const char[] name, bool dontBroadcast)
{
	int client = GetEventInt(event, "userid");

	// ShowActivity(0, "[SM] Event_PlayerSpawn called");
	//  if (IsClientInGame(client)) {
	//      ShowActivity(0, "[SM] %N spawned", client);
	//  }

	// ShowActivity(0, "[SM] %N spawned", client);
	RemoveNoclip(false, client, 0);

	return Plugin_Continue;
}

public Action CheckNoclip(int client, int args)
{
	// PrintToChat(client, "[SM] m_hViewModel = %d", GetEntPropEnt(client, Prop_Send, "m_hViewModel"));
	// PrintToChat(client, "[SM] m_hViewModel = %d", GetEntPropEnt(client, Prop_Data, "m_hViewModel"));

	for (int i = 1; i <= MaxClients; i++)
	{
		RemoveNoclip(true, i, client);
	}

	return Plugin_Handled;
}