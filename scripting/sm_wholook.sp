#include <sourcemod>
#include <sdktools>

public Plugin myinfo =
{
    name = "sm_wholook",
    author = "IntriguingTiles",
    description = "Gets the name of the player you're looking at.",
    version = "1.0",
};

public void OnPluginStart()
{
    RegAdminCmd("sm_wholook", Cmd_WhoLook, ADMFLAG_GENERIC);
}

public Action Cmd_WhoLook(int client, int args)
{
    int target = GetClientAimTarget(client, true);

    if (target != -1)
    {
        ReplyToCommand(client, "[SM] You are looking at %N", target);
    }
    else
    {
        ReplyToCommand(client, "[SM] You are not looking at a player");
    }

    return Plugin_Handled;
}
