#include <sourcemod>
#include <sdktools>

public Plugin myinfo =
{
	name = "sm_ent_create",
	author = "IntriguingTiles",
	description = "Sourcemod version of Source's ent_create command.",
	version = "1.0",
};

public void OnPluginStart()
{
	RegAdminCmd("sm_ent_create", Cmd_EntCreate, ADMFLAG_GENERIC);
}

public Action Cmd_EntCreate(int client, int args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_ent_create <classname> [param name] [param value] ...");
		return Plugin_Handled;
	}

	char classname[65];
	GetCmdArg(1, classname, sizeof(classname));

	int entity = CreateEntityByName(classname);

	if (entity == -1)
	{
		ReplyToCommand(client, "[SM] Failed to create entity %s", classname);
		return Plugin_Handled;
	}

	float vec[3];
	float ang[3];

	GetClientAbsOrigin(client, vec);
	GetClientAbsAngles(client, ang);

	DispatchKeyValueVector(entity, "origin", vec);
	DispatchKeyValueVector(entity, "angles", ang);

	for (int i = 2; i < args; i += 2)
	{
		char param[65], value[65];
		GetCmdArg(i, param, sizeof(param));
		GetCmdArg(i + 1, value, sizeof(value));

		DispatchKeyValue(entity, param, value);
	}

	DispatchSpawn(entity);

	ShowActivity2(client, "[SM] ", "Spawned %s %d.", classname, entity);

	return Plugin_Handled;
}