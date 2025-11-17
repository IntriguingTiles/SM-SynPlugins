#include <sourcemod>
#include <sdktools>

public Plugin myinfo =
{
	name = "Disable d3_c17_10b Lasers",
	author = "IntriguingTiles",
	description = "Disables the laser puzzle on d3_c17_10b.",
	version = "1.0",
};

bool g_firedRelay = false;
bool g_isCorrectMap = false;

public void OnMapStart()
{
	g_firedRelay = false;
	g_isCorrectMap = false;

	char mapName[65];
	GetCurrentMap(mapName, sizeof(mapName));

	if (StrEqual(mapName, "d3_c17_10b", false))
	{
		g_isCorrectMap = true;
	}
}

public void OnEntityCreated(int entity, const char[] classname)
{
	if (g_isCorrectMap && !g_firedRelay && StrEqual(classname, "player"))
	{
		// level should be ready by now
		// fire s_room_off_relay
		int maxEnts = GetMaxEntities() * 2;

		for (int ent = 0; ent < maxEnts; ent++)
		{
			if (!IsValidEntity(ent)) continue;

			char targetname[128];
			GetEntPropString(ent, Prop_Data, "m_iName", targetname, sizeof(targetname));

			if (StrEqual(targetname, "s_room_off_relay", false))
			{
				AcceptEntityInput(ent, "Trigger");
				LogAction(0, -1, "Fired Trigger on s_room_off_relay");
				g_firedRelay = true;
				break;
			}
		}
	}
}