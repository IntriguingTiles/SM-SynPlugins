#include <sourcemod>
#include <sdktools>

public Plugin myinfo =
{
	name = "sm_ent_remove_all",
	author = "IntriguingTiles",
	description = "Removes all entities of a given classname or targetname.",
	version = "1.0"
};

public void OnPluginStart()
{
	RegAdminCmd("sm_ent_remove_all", Cmd_EntRemoveAll, ADMFLAG_ROOT);
}

public Action Cmd_EntRemoveAll(int client, int args)
{
	if (args < 1)
	{
		PrintToConsole(client, "Usage: sm_ent_remove_all <classname>");
		return Plugin_Handled;
	}

	char entname[64];
	GetCmdArg(1, entname, sizeof(entname));

	int maxEnts = GetMaxEntities() * 2;

	for (int ent = 0; ent < maxEnts; ent++)
	{
		if (!IsValidEntity(ent)) continue;

		char targetname[128];
		GetEntPropString(ent, Prop_Data, "m_iName", targetname, sizeof(targetname));

		if (StrEqual(targetname, entname, false))
		{
			char classname[64];
			GetEntityClassname(ent, classname, sizeof(classname));
			RemoveEntity(ent);
			ShowActivity2(client, "[SM] ", "removed entity %s (%s) %i", entname, classname, ent);
		}
	}

	// try again but with the classname
	int ent = FindEntityByClassname(-1, entname);

	while (ent != -1)
	{
		RemoveEntity(ent);
		ShowActivity2(client, "[SM] ", "removed entity %s %i", entname, ent);
		ent = FindEntityByClassname(ent, entname);
	}

	return Plugin_Handled;
}