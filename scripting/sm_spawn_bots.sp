#include <sourcemod>
#include <sdktools>

public Plugin myinfo =
{
	name = "sm_spawn_bots",
	author = "IntriguingTiles",
	description = "Spawns the specified number of bots.",
	version = "1.0",
};

public void OnPluginStart()
{
	RegAdminCmd("sm_spawn_bots", Cmd_SpawnBots, ADMFLAG_GENERIC);
}

public Action Cmd_SpawnBots(int client, int args)
{
	if (args < 1)
	{
        ReplyToCommand(client, "[SM] Usage: sm_spawn_bots <number of bots>");
        return Plugin_Handled;
	}

    int numBots = GetCmdArgInt(1);

    for (int i = 0; i < numBots; i++) {
        InsertServerCommand("bot");
    }

    ServerExecute();

    ShowActivity2(client, "[SM] ", "spawned %d bots", numBots);
    return Plugin_Handled;
}
