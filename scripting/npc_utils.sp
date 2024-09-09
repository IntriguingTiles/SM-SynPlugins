#include <sourcemod>
#include <sdktools>

public Plugin myinfo =
{
	name = "npc_utils",
	author = "IntriguingTiles",
	description = "Various NPC commands for Synergy.",
	version = "1.0"
};

public void OnPluginStart()
{
	RegAdminCmd("sm_telemonk", TeleMonk, ADMFLAG_GENERIC);
	RegAdminCmd("sm_televort", TeleVort, ADMFLAG_GENERIC);
	RegAdminCmd("sm_telealyx", TeleAlyx, ADMFLAG_GENERIC);
	RegAdminCmd("sm_telebarney", TeleBarney, ADMFLAG_GENERIC);
	RegAdminCmd("sm_telejalopy", TeleJalopy, ADMFLAG_GENERIC);
	RegAdminCmd("sm_spawnbarney", SpawnBarney, ADMFLAG_GENERIC);
	RegAdminCmd("sm_spawnalyx", SpawnAlyx, ADMFLAG_GENERIC);
	RegAdminCmd("sm_spawnvort", SpawnVort, ADMFLAG_GENERIC);
}

public Action TeleMonk(int client, int args)
{
	int entity = FindEntityByClassname(-1, "npc_monk");

	while (entity != -1)
	{
		float vec[3];
		float ang[3];

		GetClientAbsOrigin(client, vec);
		GetClientAbsAngles(client, ang);
		TeleportEntity(entity, vec, ang, { 0.0, 0.0, 0.0 });

		ShowActivity2(client, "[SM] ", "Teleported monk %d.", entity);

		entity = FindEntityByClassname(entity, "npc_monk");
	}

	return Plugin_Handled;
}

public Action TeleVort(int client, int args)
{
	int entity = FindEntityByClassname(-1, "npc_vortigaunt");

	while (entity != -1)
	{
		float vec[3];
		float ang[3];

		GetClientAbsOrigin(client, vec);
		GetClientAbsAngles(client, ang);
		TeleportEntity(entity, vec, ang, { 0.0, 0.0, 0.0 });

		ShowActivity2(client, "[SM] ", "Teleported vort %d.", entity);

		entity = FindEntityByClassname(entity, "npc_vortigaunt");
	}

	return Plugin_Handled;
}

public Action TeleAlyx(int client, int args)
{
	int entity = FindEntityByClassname(-1, "npc_alyx");

	while (entity != -1)
	{
		float vec[3];
		float ang[3];

		GetClientAbsOrigin(client, vec);
		GetClientAbsAngles(client, ang);
		TeleportEntity(entity, vec, ang, { 0.0, 0.0, 0.0 });

		ShowActivity2(client, "[SM] ", "Teleported alyx %d.", entity);

		entity = FindEntityByClassname(entity, "npc_alyx");
	}

	return Plugin_Handled;
}

public Action TeleBarney(int client, int args)
{
	int entity = FindEntityByClassname(-1, "npc_barney");

	while (entity != -1)
	{
		float vec[3];
		float ang[3];

		GetClientAbsOrigin(client, vec);
		GetClientAbsAngles(client, ang);
		TeleportEntity(entity, vec, ang, { 0.0, 0.0, 0.0 });

		ShowActivity2(client, "[SM] ", "Teleported barney %d.", entity);

		entity = FindEntityByClassname(entity, "npc_barney");
	}

	return Plugin_Handled;
}

public Action TeleJalopy(int client, int args)
{
	int entity = FindEntityByClassname(-1, "prop_vehicle_jeep_episodic");

	while (entity != -1)
	{
		char vehiclescript[128];
		GetEntPropString(entity, Prop_Data, "m_vehicleScript", vehiclescript, sizeof(vehiclescript));

		if (!StrEqual(vehiclescript, "scripts/vehicles/jalopy.txt"))
		{
			entity = FindEntityByClassname(entity, "prop_vehicle_jeep_episodic");
			continue;
		}

		float vec[3];
		float ang[3];

		GetClientAbsOrigin(client, vec);
		GetClientAbsAngles(client, ang);
		TeleportEntity(entity, vec, ang, { 0.0, 0.0, 0.0 });

		ShowActivity2(client, "[SM] ", "Teleported jalopy %d.", entity);

		entity = FindEntityByClassname(entity, "prop_vehicle_jeep_episodic");
	}

	return Plugin_Handled;
}

public Action SpawnBarney(int client, int args)
{
	int entity = CreateEntityByName("npc_barney");

	if (entity == -1)
	{
		ReplyToCommand(client, "[SM] Failed to create entity.");
		return Plugin_Handled;
	}

	float vec[3];
	float ang[3];

	GetClientAbsOrigin(client, vec);
	GetClientAbsAngles(client, ang);

	DispatchKeyValue(entity, "targetname", "barney");
	DispatchKeyValueVector(entity, "origin", vec);
	DispatchKeyValueVector(entity, "angles", ang);

	if (args > 0)
	{
		char weapon[65];
		GetCmdArg(1, weapon, sizeof(weapon));
		DispatchKeyValue(entity, "additionalequipment", weapon);
	}

	DispatchSpawn(entity);

	ShowActivity2(client, "[SM] ", "Spawned barney %d.", entity);

	return Plugin_Handled;
}

public Action SpawnAlyx(int client, int args)
{
	int entity = CreateEntityByName("npc_alyx");

	if (entity == -1)
	{
		ReplyToCommand(client, "[SM] Failed to create entity.");
		return Plugin_Handled;
	}

	float vec[3];
	float ang[3];

	GetClientAbsOrigin(client, vec);
	GetClientAbsAngles(client, ang);

	DispatchKeyValue(entity, "targetname", "alyx");
	DispatchKeyValueVector(entity, "origin", vec);
	DispatchKeyValueVector(entity, "angles", ang);

	if (args > 0)
	{
		char weapon[65];
		GetCmdArg(1, weapon, sizeof(weapon));
		DispatchKeyValue(entity, "additionalequipment", weapon);
	}

	DispatchSpawn(entity);

	ShowActivity2(client, "[SM] ", "Spawned alyx %d.", entity);

	return Plugin_Handled;
}

public Action SpawnVort(int client, int args)
{
	int entity = CreateEntityByName("npc_vortigaunt");

	if (entity == -1)
	{
		ReplyToCommand(client, "[SM] Failed to create entity.");
		return Plugin_Handled;
	}

	float vec[3];
	float ang[3];

	GetClientAbsOrigin(client, vec);
	GetClientAbsAngles(client, ang);

	DispatchKeyValue(entity, "targetname", "vort");
	DispatchKeyValueVector(entity, "origin", vec);
	DispatchKeyValueVector(entity, "angles", ang);

	DispatchSpawn(entity);

	ShowActivity2(client, "[SM] ", "Spawned vort %d.", entity);

	return Plugin_Handled;
}