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
bool g_firedRelay = false;
bool g_isCorrectMap = false;

public void OnPluginStart()
{
	g_cvOutland02 = CreateConVar("sm_outland02", "0", "Force ep2_outland_02 to start as if you came back from ep2_outland_04.");
}

public void OnMapStart()
{
	g_firedRelay = false;
	g_isCorrectMap = false;

	char mapName[65];
	GetCurrentMap(mapName, sizeof(mapName));

	if (StrEqual(mapName, "ep2_outland_02", false))
	{
		g_isCorrectMap = true;
	}
}

public void OnEntityCreated(int entity, const char[] classname)
{
	// LogAction(0, -1, "Entity created: %d %s", entity, classname);

	if (!g_firedRelay && g_isCorrectMap && g_cvOutland02.BoolValue && StrEqual(classname, "player"))
	{
		// level should be ready by now

		// trigger debug_choreo_start_in_elevator

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
			}

			if (StrEqual(targetname, "debug_choreo_start_in_elevator", false))
			{
				AcceptEntityInput(ent, "Trigger");
				LogAction(0, -1, "Fired Trigger on debug_choreo_start_in_elevator");
				g_firedRelay = true;
			}
		}
	}
}