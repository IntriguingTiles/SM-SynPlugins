#include <sourcemod>
#include <sdktools>

public Plugin myinfo =
{
	name = "sm_ent_remove",
	author = "IntriguingTiles",
	description = "Removes the entity you're looking at.",
	version = "1.0"
};

public void OnPluginStart()
{
	RegAdminCmd("sm_ent_remove", Cmd_EntRemove, ADMFLAG_ROOT);
}

public Action Cmd_EntRemove(int client, int args)
{
	int target = GetClientAimTarget(client, false);
	if (target < 0)
	{
		ReplyToCommand(client, "[SM] Trace hit nothing");
	}
	else
	{
		char classname[64];
		GetEntityClassname(target, classname, sizeof(classname));

		if (StrEqual(classname, "player", true))
		{
			ReplyToCommand(client, "[SM] Trace hit player entity, not removing");
		}
		else
		{
			RemoveEntity(target);
			ShowActivity2(client, "[SM] ", "removed entity %s %i", classname, target);
		}
	}

	return Plugin_Handled;
}