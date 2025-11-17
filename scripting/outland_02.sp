#include <sourcemod>
#include <sdktools>
#include <sdkhooks>

public Plugin myinfo =
{
	name = "outland_02",
	author = "IntriguingTiles",
	description = "Provides a way to force ep2_outland_02 to start as if you came back from ep2_outland_04.",
	version = "1.0",
};

ConVar g_cvOutland02;
ConVar g_cvOutland02Delay;

public void OnPluginStart()
{
	g_cvOutland02 = CreateConVar("sm_outland02", "0", "Force ep2_outland_02 to start as if you came back from ep2_outland_04.");
	g_cvOutland02Delay = CreateConVar("sm_outland02_delay", "3.0", "The delay before firing the debug relay to begin the return sequence.");
}

public void OnMapStart()
{
	char mapName[65];
	GetCurrentMap(mapName, sizeof(mapName));

	if (StrEqual(mapName, "ep2_outland_02", false) && g_cvOutland02.BoolValue)
	{
		HookEvent("player_spawn", OnPlayerSpawn);
	}
}

void OnPlayerSpawn(Event event, const char[] name, bool dontBroadcast)
{
	int maxEnts = GetMaxEntities() * 2;

	for (int ent = 0; ent < maxEnts; ent++)
	{
		if (!IsValidEntity(ent)) continue;

		char targetname[128];
		GetEntPropString(ent, Prop_Data, "m_iName", targetname, sizeof(targetname));

		if (StrEqual(targetname, "syn_spawn_manager", false))
		{
			// set checkpoint so players can't mess up the map
			SetVariantString("syn_spawn_player_3");
			AcceptEntityInput(ent, "SetCheckPoint");
			LogAction(0, -1, "Fired SetCheckPoint on syn_spawn_manager");
			
			AcceptEntityInput(ent, "MovePlayers");
		}
	}

	CreateTimer(g_cvOutland02Delay.FloatValue, OnTimer);
	UnhookEvent("player_spawn", OnPlayerSpawn);
}

void OnTimer(Handle timer)
{
	int maxEnts = GetMaxEntities() * 2;

	for (int ent = 0; ent < maxEnts; ent++)
	{
		if (!IsValidEntity(ent)) continue;

		char targetname[128];
		GetEntPropString(ent, Prop_Data, "m_iName", targetname, sizeof(targetname));

		if (StrEqual(targetname, "debug_choreo_start_in_elevator", false))
		{
			AcceptEntityInput(ent, "Trigger");
			LogAction(0, -1, "Fired Trigger on debug_choreo_start_in_elevator");
		}
	}
}