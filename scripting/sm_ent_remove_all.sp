#include <sourcemod>
#include <sdktools>

public Plugin myinfo =
{
	name = "sm_ent_remove_all",
	author = "IntriguingTiles",
	description = "Removes all entities of a given classname.",
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

	char classname[64];
	GetCmdArg(1, classname, sizeof(classname));

	int entity = FindEntityByClassname(-1, classname);

	while (entity != -1)
	{
		RemoveEntity(entity);
		ShowActivity2(client, "[SM] ", "removed entity %s %i", classname, entity);
		entity = FindEntityByClassname(entity, classname);
	}

	return Plugin_Handled;
}