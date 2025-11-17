#include <sourcemod>
#include <sdktools>

public Plugin myinfo =
{
	name = "NPC Utils",
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
	RegAdminCmd("sm_spawnjalopy", SpawnJalopy, ADMFLAG_GENERIC);
	RegAdminCmd("sm_gotomonk", GotoMonk, ADMFLAG_GENERIC);
	RegAdminCmd("sm_gotovort", GotoVort, ADMFLAG_GENERIC);
	RegAdminCmd("sm_gotoalyx", GotoAlyx, ADMFLAG_GENERIC);
	RegAdminCmd("sm_gotobarney", GotoBarney, ADMFLAG_GENERIC);
}

public void TeleEntity(const char[] classname, int client)
{
	int entity = FindEntityByClassname(-1, classname);

	while (entity != -1)
	{
		float vec[3];
		float ang[3];

		GetClientAbsOrigin(client, vec);
		GetClientAbsAngles(client, ang);
		TeleportEntity(entity, vec, ang, { 0.0, 0.0, 0.0 });

		ShowActivity2(client, "[SM] ", "teleported %s %d.", classname, entity);

		entity = FindEntityByClassname(entity, classname);
	}
}

public Action TeleMonk(int client, int args)
{
	TeleEntity("npc_monk", client);
	return Plugin_Handled;
}

public Action TeleVort(int client, int args)
{
	TeleEntity("npc_vortigaunt", client);
	return Plugin_Handled;
}

public Action TeleAlyx(int client, int args)
{
	TeleEntity("npc_alyx", client);
	return Plugin_Handled;
}

public Action TeleBarney(int client, int args)
{
	TeleEntity("npc_barney", client);
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

		ShowActivity2(client, "[SM] ", "teleported jalopy %d.", entity);

		entity = FindEntityByClassname(entity, "prop_vehicle_jeep_episodic");
	}

	return Plugin_Handled;
}

public void SpawnEntity(const char[] classname, const char[] targetname, bool acceptsEquipment, int client, int args)
{
	int entity = CreateEntityByName(classname);

	if (entity == -1)
	{
		ReplyToCommand(client, "[SM] Failed to create entity.");
		return;
	}

	float vec[3];
	float ang[3];

	GetClientAbsOrigin(client, vec);
	GetClientAbsAngles(client, ang);

	DispatchKeyValue(entity, "targetname", targetname);
	DispatchKeyValueVector(entity, "origin", vec);
	DispatchKeyValueVector(entity, "angles", ang);

	if (acceptsEquipment && args > 0)
	{
		char weapon[65];
		GetCmdArg(1, weapon, sizeof(weapon));
		DispatchKeyValue(entity, "additionalequipment", weapon);
	}

	DispatchSpawn(entity);

	ShowActivity2(client, "[SM] ", "spawned %s %d.", targetname, entity);
}

public Action SpawnBarney(int client, int args)
{
	SpawnEntity("npc_barney", "barney", true, client, args);
	return Plugin_Handled;
}

public Action SpawnAlyx(int client, int args)
{
	SpawnEntity("npc_alyx", "alyx", true, client, args);
	return Plugin_Handled;
}

public Action SpawnVort(int client, int args)
{
	SpawnEntity("npc_vortigaunt", "vort", false, client, args);
	return Plugin_Handled;
}

public Action SpawnJalopy(int client, int args)
{
	int entity = CreateEntityByName("prop_vehicle_jeep_episodic");

	if (entity == -1)
	{
		ReplyToCommand(client, "[SM] Failed to create entity.");
		return Plugin_Handled;
	}

	float vec[3];
	float ang[3];

	GetClientAbsOrigin(client, vec);
	GetClientAbsAngles(client, ang);

	DispatchKeyValue(entity, "targetname", "jeep");
	DispatchKeyValue(entity, "vehiclescript", "scripts/vehicles/jalopy.txt");
	DispatchKeyValue(entity, "model", "models/vehicle.mdl");
	DispatchKeyValueVector(entity, "origin", vec);
	DispatchKeyValueVector(entity, "angles", ang);

	SetVariantString("PlayerOn alyx,SetDamageFilter,alyx_invuln_filter,0,-1");
	AcceptEntityInput(entity, "AddOutput");

	SetVariantString("PlayerOff alyx,SetDamageFilter,,0,-1");
	AcceptEntityInput(entity, "AddOutput");

	SetVariantString("PlayerOn alyx,EnterVehicle,jeep,0,-1");
	AcceptEntityInput(entity, "AddOutput");

	SetVariantString("PlayerOff alyx,ExitVehicle,,0,-1");
	AcceptEntityInput(entity, "AddOutput");

	DispatchSpawn(entity);

	ShowActivity2(client, "[SM] ", "spawned jalopy %d.", entity);

	return Plugin_Handled;
}

public void GotoEntity(const char[] classname, int client)
{
	int entity = FindEntityByClassname(-1, classname);

	while (entity != -1)
	{
		float vec[3];

		GetEntPropVector(entity, Prop_Send, "m_vecOrigin", vec);
		TeleportEntity(client, vec, NULL_VECTOR, { 0.0, 0.0, 0.0 });

		ShowActivity2(client, "[SM] ", "teleported to %s %d.", classname, entity);

		entity = FindEntityByClassname(entity, classname);
		break;
	}
}

public Action GotoMonk(int client, int args)
{
	GotoEntity("npc_monk", client);
	return Plugin_Handled;
}

public Action GotoVort(int client, int args)
{
	GotoEntity("npc_vortigaunt", client);
	return Plugin_Handled;
}

public Action GotoAlyx(int client, int args)
{
	GotoEntity("npc_alyx", client);
	return Plugin_Handled;
}

public Action GotoBarney(int client, int args)
{
	GotoEntity("npc_barney", client);
	return Plugin_Handled;
}