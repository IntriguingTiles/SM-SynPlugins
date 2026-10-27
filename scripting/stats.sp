#include <sourcemod>
#include <sdktools>
#include <server_fps>

public Plugin myinfo =
{
	name = "stats",
	author = "IntriguingTiles",
	description = "Tracks stats of interest.",
	version = "1.0",
};

// I'm not using prepared statements beacuse they cannot be executed asynchronously at this time

Database g_db;

// sourcepawn-studio cannot currently format these macros correctly
// clang-format off
#define MAKE_VAR(%1, %2) char %1[%2]; char %1escaped[(%2) * 2 + 1]
#define ESCAPE(%1) g_db.Escape(%1, %1escaped, sizeof(%1escaped))
// clang-format on

// these are global to avoid doing unneeded memory allocations during events
MAKE_VAR(mapname, 65);

MAKE_VAR(steam2, MAX_AUTHID_LENGTH);

MAKE_VAR(weapon, 33);
MAKE_VAR(killername, MAX_NAME_LENGTH);
MAKE_VAR(victimname, MAX_NAME_LENGTH);

char query[1024];

bool ignoreTimerTick = true;

public bool CreateTables()
{
	if (!SQL_FastQuery(g_db, "CREATE TABLE IF NOT EXISTS players (steamid TEXT PRIMARY KEY)"))
		return false;
	if (!SQL_FastQuery(g_db, "CREATE TABLE IF NOT EXISTS deaths (id INTEGER PRIMARY KEY, timestamp TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, mapname TEXT NOT NULL, killerID INTEGER NOT NULL, victimID INTEGER NOT NULL, weapon TEXT NOT NULL, suicide INTEGER NOT NULL DEFAULT 0, killername TEXT NOT NULL, victimname TEXT NOT NULL)"))
		return false;
	if (!SQL_FastQuery(g_db, "CREATE TABLE IF NOT EXISTS achievement (count INTEGER NOT NULL DEFAULT 0)"))
		return false;
	if (!SQL_FastQuery(g_db, "CREATE TABLE IF NOT EXISTS server_stats (id INTEGER PRIMARY KEY, timestamp TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP, mapname TEXT NOT NULL, tps REAL NOT NULL, playercount INTEGER NOT NULL, edictcount INTEGER NOT NULL)"))
		return false;
	if (!SQL_FastQuery(g_db, "INSERT INTO achievement (count) SELECT 0 WHERE NOT EXISTS (SELECT 1 FROM achievement)"))
		return false;
	return true;
}

public void OnPluginStart()
{
	char error[255];
	g_db = SQLite_UseDatabase("sourcemod-local", error, sizeof(error));

	if (g_db == null)
	{
		ThrowError("Couldn't use database");
	}

	if (!CreateTables())
	{
		ThrowError("Couldn't create tables");
	}

	// set up our tables
	// what does our schema look like?
	//#region sql
	/*
	CREATE TABLE IF NOT EXISTS players (
		steamid TEXT PRIMARY KEY,
	);

	CREATE TABLE IF NOT EXISTS deaths (
		id INTEGER PRIMARY KEY,
		timestamp TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
		mapname TEXT NOT NULL,
		killerID INTEGER NOT NULL,
		victimID INTEGER NOT NULL,
		weapon TEXT NOT NULL,
		suicide INTEGER NOT NULL DEFAULT 0,
		killername TEXT NOT NULL,
		victimname TEXT NOT NULL
	);

	CREATE TABLE IF NOT EXISTS achievement (
		count INTEGER NOT NULL DEFAULT 0
	);

	CREATE TABLE IF NOT EXISTS server_stats (
		id INTEGER PRIMARY KEY,
		timestamp TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
		mapname TEXT NOT NULL,
		tps REAL NOT NULL,
		playercount INTEGER NOT NULL,
		edictcount INTEGER NOT NULL
	);
	*/
	//#endregion

	HookEvent("synergy_entity_death", OnEntityDeath);
	HookEvent("achievement_earned", OnAchievementEarned);

	// tick every 30 seconds if the server is running at full speed
	CreateTimer(30.0, OnTimer, _, TIMER_REPEAT);
}

public void OnMapStart()
{
	ignoreTimerTick = true;
	GetCurrentMap(mapname, sizeof(mapname));
	if (g_db)
	{
		ESCAPE(mapname);
	}
}

public void SQLCallback(Handle owner, Handle hndl, const char[] error, any data)
{
	if (hndl == null)
	{
		LogError("Query failed: %s", error);
	}
}

public void OnClientPostAdminCheck(int client)
{
	if (IsFakeClient(client)) return;
	// SteamID logging? would be most reliable source of unique info
	bool success = GetClientAuthId(client, AuthId_Steam2, steam2, sizeof(steam2), false);
	if (success)
	{
		// add to db
		ESCAPE(steam2);
		FormatEx(query, sizeof(query), "INSERT INTO players VALUES ('%s') ON CONFLICT DO NOTHING", steam2escaped);
		LogMessage("%s", query);
		SQL_TQuery(g_db, SQLCallback, query);
	}
}

void OnAchievementEarned(Event event, const char[] name, bool dontBroadcast)
{
	// player (byte)
	// achievement (short)
	// don't care about the actual event details
	SQL_TQuery(g_db, SQLCallback, "UPDATE achievement SET count = count + 1");
}

void OnEntityDeath(Event event, const char[] name, bool dontBroadcast)
{
	/*
	what we care about here:
	killerID (short)
	victimID (short)
	weapon (string)
	suicide (bool)
	killername (string)
	victimname (string)

	mapname
	*/
	int killerID = event.GetInt("killerID", -1);
	int victimID = event.GetInt("victimID", -1);
	event.GetString("weapon", weapon, sizeof(weapon));
	bool suicide = event.GetBool("suicide");
	event.GetString("killername", killername, sizeof(killername));
	event.GetString("victimname", victimname, sizeof(victimname));

	ESCAPE(weapon);
	ESCAPE(killername);
	ESCAPE(victimname);
	FormatEx(query, sizeof(query), "INSERT INTO deaths (mapname, killerID, victimID, weapon, suicide, killername, victimname) VALUES ('%s', %d, %d, '%s', %d, '%s', '%s')",
		   mapnameescaped, killerID, victimID, weaponescaped, suicide, killernameescaped, victimnameescaped);
	LogMessage("%s", query);
	SQL_TQuery(g_db, SQLCallback, query);
}

public Action OnTimer(Handle timer)
{
	// mapname
	// tps
	// current player count
	// edict count
	if (ignoreTimerTick)
	{
		// discard the first timer tick per-map
		ignoreTimerTick = false;
		return Plugin_Handled;
	}

	int players = GetClientCount();
	int edicts = GetEntityCount();
	float tps = GetServerFPS();
	FormatEx(query, sizeof(query), "INSERT INTO server_stats (mapname, tps, playercount, edictcount) VALUES('%s', %f, %d, %d)", mapnameescaped, tps, players, edicts);
	LogMessage("%s", query);
	SQL_TQuery(g_db, SQLCallback, query);

	return Plugin_Handled;
}