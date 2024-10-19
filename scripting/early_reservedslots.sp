#include <sourcemod>

public Plugin myinfo =
{
	name = "early_reservedslots",
	author = "IntriguingTiles",
	description = "Runs the reserved slot logic as soon as possible during the connection process.",
	version = "1.0",
};

ConVar sm_reserved_slots;
ConVar sm_reserve_type;

public void OnAllPluginsLoaded()
{
	sm_reserved_slots = FindConVar("sm_reserved_slots");
	sm_reserve_type = FindConVar("sm_reserve_type");

	if (sm_reserved_slots == null)
	{
		LogError("sm_reserved_slots not found");
	}

	if (sm_reserve_type == null)
	{
		LogError("sm_reserve_type not found");
	}
}

public bool OnClientConnect(int client, char[] rejectmsg, int maxlen)
{
	char steam2[MAX_AUTHID_LENGTH];
	bool success = GetClientAuthId(client, AuthId_Steam2, steam2, sizeof(steam2), false);

	if (success)
	{
		int reserved = sm_reserved_slots.IntValue;

		if (reserved > 0)
		{
			LogAction(0, client, "Steam2: %s", steam2);
			AdminId id = FindAdminByIdentity(AUTHMETHOD_STEAM, steam2);
			int clients = GetClientCount(false);
			int limit = GetMaxHumanPlayers() - reserved;
			int flags = GetAdminFlags(id, Access_Effective);

			int type = sm_reserve_type.IntValue;

			if (type == 0)
			{
				if (clients <= limit || IsFakeClient(client) || flags & ADMFLAG_ROOT || flags & ADMFLAG_RESERVATION)
				{
					return true;
				}

				/* Kick player because there are no public slots left */
				strcopy(rejectmsg, maxlen, "#GameUI_ServerRejectServerFull");
				return false;
			}
		}
	}
	else {
		LogAction(0, client, "Steam2 not found");
	}

	return true;
}