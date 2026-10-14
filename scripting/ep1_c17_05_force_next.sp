#include <sourcemod>
#include <sdktools>

public Plugin myinfo =
{
	name = "ep1_c17_05 Force Next",
	author = "IntriguingTiles",
	description = "Forces the escort sequence on ep1_c17_05 to send the next group of citizens.",
	version = "1.0",
};

public void OnPluginStart()
{
	RegAdminCmd("sm_ep1_c17_05_force_next", Cmd_ForceNext, ADMFLAG_GENERIC);
}

public Action Cmd_ForceNext(int client, int args)
{
	char mapName[65];
	GetCurrentMap(mapName, sizeof(mapName));

	if (!StrEqual(mapName, "ep1_c17_05", false))
	{
		ReplyToCommand(client, "[SM] This command can only be used on ep1_c17_05");
		return Plugin_Handled;
	}

	int entity = FindEntityByClassname(-1, "npc_citizen");
	int hits = 0;

	while (entity != -1)
	{
		char targetname[128];
		GetEntPropString(entity, Prop_Data, "m_iName", targetname, sizeof(targetname));
		if (StrContains(targetname, "citizen_refugees_", false) != -1)
		{
			AcceptEntityInput(entity, "FireUser3");
			AcceptEntityInput(entity, "FireUser1");
			hits++;
		}

		entity = FindEntityByClassname(entity, "npc_citizen");
	}

	if (hits == 0)
		ReplyToCommand(client, "[SM] No citizens found");
	else
		ShowActivity2(client, "[SM] ", "forced next group of citizens");

	return Plugin_Handled;
}