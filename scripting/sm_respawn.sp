#include <sourcemod>
#include <sdktools>

Handle g_hGameConf;
Handle g_hSpawn;

public Plugin myinfo =
{
	name = "sm_respawn",
	author = "IntriguingTiles",
	description = "Force respawns the given player.",
	version = "1.0",
};

public void OnPluginStart()
{
	RegAdminCmd("sm_respawn", Cmd_Respawn, ADMFLAG_GENERIC);
	LoadTranslations("common.phrases");
	LoadTranslations("tiles.phrases");
	g_hGameConf = LoadGameConfigFile("sdkhooks.games");
	StartPrepSDKCall(SDKCall_Player);
	PrepSDKCall_SetFromConf(g_hGameConf, SDKConf_Virtual, "Spawn");
	g_hSpawn = EndPrepSDKCall();
}

public void RespawnPlayer(int player)
{
	SDKCall(g_hSpawn, player);
}

public Action Cmd_Respawn(int client, int args)
{
	if (args < 1)
	{
		if (!IsPlayerAlive(client))
		{
			RespawnPlayer(client);
			ShowActivity2(client, "[SM] ", "respawned %N.", client);
		}
		else {
			ReplyToCommand(client, "[SM] You are not dead");
		}
		return Plugin_Handled;
	}

	char arg[65];
	GetCmdArg(1, arg, sizeof(arg));

	char target_name[MAX_TARGET_LENGTH];
	int target_list[MAXPLAYERS], target_count;
	bool tn_is_ml;

	if ((target_count = ProcessTargetString(
			 arg,
			 client,
			 target_list,
			 MAXPLAYERS,
			 COMMAND_FILTER_DEAD,
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
		if (IsClientInGame(target_list[i]) && !IsPlayerAlive(target_list[i]))
		{
			RespawnPlayer(target_list[i]);
			// ShowActivity2(client, "Respawned %N", target_list[i]);
		}
	}

	if (tn_is_ml)
	{
		ShowActivity2(client, "[SM] ", "%t", "Respawned target", target_name);
	}
	else
	{
		ShowActivity2(client, "[SM] ", "%t", "Respawned target", "_s", target_name);
	}

	return Plugin_Handled;
}