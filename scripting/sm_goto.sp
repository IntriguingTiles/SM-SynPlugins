#include <sourcemod>
#include <sdktools>

public Plugin myinfo =
{
	name = "sm_goto",
	author = "IntriguingTiles",
	description = "Teleports you to players.",
	version = "1.0",
};

public void OnPluginStart()
{
	RegAdminCmd("sm_goto", Cmd_Tele, ADMFLAG_GENERIC);
	LoadTranslations("common.phrases");
	LoadTranslations("tiles.phrases");
}

public Action Cmd_Tele(int client, int args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_goto <#userid|name>");
		return Plugin_Handled;
	}

	char arg[65];
	GetCmdArg(1, arg, sizeof(arg));

	char target_name[MAX_TARGET_LENGTH];
	int target_list[1], target_count;
	bool tn_is_ml;

	if ((target_count = ProcessTargetString(
			 arg,
			 client,
			 target_list,
			 1,
			 COMMAND_FILTER_ALIVE,
			 target_name,
			 sizeof(target_name),
			 tn_is_ml))
		<= 0)
	{
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}

	for (int i = 0; i < target_count; i++)
	{
		float vec[3];
		float ang[3];

		GetClientAbsOrigin(target_list[i], vec);
		GetClientAbsAngles(target_list[i], ang);
		// PrintToChat(client, "[SM] Teleporting \"%N\"", target_list[i]);
		TeleportEntity(client, vec, ang, { 0.0, 0.0, 0.0 });
		// SetEntPropVector(target_list[i], Prop_Send, "m_vecOrigin", vec);
	}

	if (tn_is_ml)
	{
		ShowActivity2(client, "[SM] ", "%t", "Teleported to target", target_name);
	}
	else
	{
		ShowActivity2(client, "[SM] ", "%t", "Teleported to target", "_s", target_name);
	}

	return Plugin_Handled;
}