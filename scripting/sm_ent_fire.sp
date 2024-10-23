#include <sourcemod>
#include <sdktools>

public Plugin myinfo =
{
	name = "sm_ent_fire",
	author = "IntriguingTiles",
	description = "Sourcemod version of Source's ent_fire command.",
	version = "1.0"
};

public void OnPluginStart()
{
	RegAdminCmd("sm_ent_fire", Cmd_EntFire, ADMFLAG_GENERIC);
}

public Action Cmd_EntFire(int client, int args)
{
	if (args < 2)
	{
		ReplyToCommand(client, "[SM] Usage: sm_ent_fire <entity> <input>");
		return Plugin_Handled;
	}

	char entity[65], input[65], entArgs[65];
	bool hasArgs = false;
	GetCmdArg(1, entity, sizeof(entity));
	GetCmdArg(2, input, sizeof(input));

	if (args >= 3)
	{
		GetCmdArg(3, entArgs, sizeof(entArgs));
		hasArgs = true;
	}

	int maxEnts = GetMaxEntities() * 2;
	bool fired = false;

	for (int ent = 0; ent < maxEnts; ent++)
	{
		if (!IsValidEntity(ent)) continue;

		char targetname[128];
		GetEntPropString(ent, Prop_Data, "m_iName", targetname, sizeof(targetname));

		if (StrEqual(targetname, entity, false))
		{
			if (hasArgs) SetVariantString(entArgs);
			AcceptEntityInput(ent, input);
			ShowActivity2(client, "[SM] ", "fired %s on %s %d", input, entity, ent);
			fired = true;
		}
	}

	// try again but with the classname
	int ent = FindEntityByClassname(-1, entity);

	while (ent != -1)
	{
		if (hasArgs) SetVariantString(entArgs);
		AcceptEntityInput(ent, input);
		ShowActivity2(client, "[SM] ", "fired %s on %s %d", input, entity, ent);
		fired = true;
		ent = FindEntityByClassname(ent, entity);
	}

	if (!fired)
	{
		ReplyToCommand(client, "[SM] No entities found with targetname or classname %s", entity);
	}

	return Plugin_Handled;
}