#include <sourcemod>
#include <sdktools>
#include <sdkhooks>

public Plugin myinfo =
{
	name = "Invincible Striders",
	author = "IntriguingTiles",
	description = "Makes striders invincible on d3_c17_12b, d3_c17_13, and ep1_c17_06 until you run a command to make them vulnerable.",
	version = "1.0",
};

bool g_isCorrectMap = false;

public void OnPluginStart()
{
	RegAdminCmd("sm_enable_strider_dmg", Cmd_EnableStriderDmg, ADMFLAG_GENERIC);
}

public Action Cmd_EnableStriderDmg(int client, int args)
{
	if (!g_isCorrectMap)
	{
		ReplyToCommand(client, "[SM] This command can only be used on d3_c17_12b, d3_c17_13 or ep1_c17_06");
		return Plugin_Handled;
	}

	// loop through all npc_striders and set invulnerable to 0
	// stop making new striders invulnerable too
	g_isCorrectMap = false;

	int entity = FindEntityByClassname(-1, "npc_strider");

	while (entity != -1)
	{
		DispatchKeyValue(entity, "invulnerable", "0");
		LogAction(client, -1, "Made strider %d vulnerable", entity);
		entity = FindEntityByClassname(entity, "npc_strider");
	}

	ShowActivity2(client, "[SM] ", "made striders vulnerable.");
	return Plugin_Handled;
}

public void OnMapStart()
{
	char mapName[65];
	GetCurrentMap(mapName, sizeof(mapName));
	g_isCorrectMap = StrEqual(mapName, "d3_c17_12b", false) || StrEqual(mapName, "d3_c17_13", false) || StrEqual(mapName, "ep1_c17_06", false);
}

public void OnEntityCreated(int entity, const char[] classname)
{
	if (g_isCorrectMap && StrEqual(classname, "npc_strider", false))
	{
		DispatchKeyValue(entity, "invulnerable", "1");
		LogAction(-1, -1, "Made strider %d invulnerable", entity);
	}
}
