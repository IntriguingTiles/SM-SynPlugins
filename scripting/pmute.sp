#include <sourcemod>
#include <sdktools>
#include <clientprefs>
#include <basecomm>

Handle g_hMuteCookie;
Handle g_hGagCookie;

public Plugin myinfo =
{
	name = "pmute",
	author = "IntriguingTiles",
	description = "Persistently mutes/gags players.",
	version = "1.0"
};

public void OnPluginStart()
{
	g_hMuteCookie = RegClientCookie("pmute", "Persistent mute", CookieAccess_Private);
	g_hGagCookie = RegClientCookie("pgag", "Persistent gag", CookieAccess_Private);
	RegAdminCmd("sm_is_muted", Cmd_IsMuted, ADMFLAG_CHAT);
	RegAdminCmd("sm_is_gagged", Cmd_IsGagged, ADMFLAG_CHAT);
	LoadTranslations("common.phrases");
}

public void BaseComm_OnClientMute(int client, bool muteState)
{
	SetClientCookie(client, g_hMuteCookie, muteState ? "1" : "0");
}

public void BaseComm_OnClientGag(int client, bool gagState)
{
	SetClientCookie(client, g_hGagCookie, gagState ? "1" : "0");
}

void CheckMute(int client)
{
	if (!AreClientCookiesCached(client)) return;
	if (!IsClientInGame(client)) return;

	char sMuteState[12];
	GetClientCookie(client, g_hMuteCookie, sMuteState, sizeof(sMuteState));
	bool bMuteState = sMuteState[0] == '1';

	if (bMuteState && !BaseComm_IsClientMuted(client))
	{
		BaseComm_SetClientMute(client, bMuteState);
		LogAction(0, client, "Muted \"%L\"", client);
	}
}

void CheckGag(int client)
{
	if (!AreClientCookiesCached(client)) return;
	if (!IsClientInGame(client)) return;

	char sGagState[12];
	GetClientCookie(client, g_hGagCookie, sGagState, sizeof(sGagState));
	bool bGagState = sGagState[0] == '1';

	if (bGagState && !BaseComm_IsClientGagged(client))
	{
		BaseComm_SetClientGag(client, bGagState);
		LogAction(0, client, "Gagged \"%L\"", client);
	}
}

public void OnClientCookiesCached(int client)
{
	// it's possible for OnClientCookiesCached to be called very late, so we're doing the checks again here just in case
	CheckMute(client);
	CheckGag(client);
}

public void OnClientPostAdminCheck(int client)
{
	CheckMute(client);
	CheckGag(client);
}

public Action Cmd_IsMuted(int client, int args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_is_muted <#userid|name>");
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
			 0,
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
		char sMuteState[12];
		GetClientCookie(target_list[i], g_hMuteCookie, sMuteState, sizeof(sMuteState));
		bool bMuteState = sMuteState[0] == '1';
		ReplyToCommand(client, "[SM] %N is %s.", target_list[i], BaseComm_IsClientMuted(target_list[i]) ? "muted" : "not muted");
		ReplyToCommand(client, "[SM] According to cookies, %N should be %s.", target_list[i], bMuteState ? "muted" : "not muted");
	}

	return Plugin_Handled;
}

public Action Cmd_IsGagged(int client, int args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_is_gagged <#userid|name>");
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
			 0,
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
		char sGagState[12];
		GetClientCookie(client, g_hGagCookie, sGagState, sizeof(sGagState));
		bool bGagState = sGagState[0] == '1';
		ReplyToCommand(client, "[SM] %N is %s.", target_list[i], BaseComm_IsClientGagged(client) ? "gagged" : "not gagged");
		ReplyToCommand(client, "[SM] According to cookies, %N should be %s.", target_list[i], bGagState ? "gagged" : "not gagged");
	}

	return Plugin_Handled;
}