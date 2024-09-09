#include <sourcemod>
#include <sdktools>

public Plugin myinfo =
{
	name = "sm_equip",
	author = "IntriguingTiles",
	description = "Gives all players weapons if they don't have any depending on the map.",
	version = "1.0"
};

public void OnPluginStart()
{
	RegAdminCmd("sm_equip", EquipPlayers, ADMFLAG_GENERIC);
	// HookEvent("player_spawn", Event_PlayerSpawn);
	// HookEvent("player_activate", Event_PlayerSpawn);
}

public void SpawnAndEquipWeapon(int client, const char[] weapon)
{
	if (IsClientInGame(client))
	{
		int weaponEnt = GivePlayerItem(client, weapon);

		// PrintToServer("Giving %d to %i", weaponEnt, client);

		if (weaponEnt != -1)
		{
			EquipPlayerWeapon(client, weaponEnt);
		}
	}
}

public Action EquipPlayers(int client, int args)
{
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i))
		{
			char weapon[32];
			GetClientWeapon(i, weapon, sizeof(weapon));

			if (strlen(weapon) == 0)
			{
				SpawnAndEquipWeapon(i, "weapon_crowbar");
				SpawnAndEquipWeapon(i, "weapon_pistol");
				SpawnAndEquipWeapon(i, "weapon_smg1");
				SpawnAndEquipWeapon(i, "weapon_frag");
				SpawnAndEquipWeapon(i, "weapon_shotgun");
				SpawnAndEquipWeapon(i, "weapon_physcannon");
				SpawnAndEquipWeapon(i, "weapon_357");
			}
		}
	}

	return Plugin_Handled;
}