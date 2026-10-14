#include <sourcemod>
#include <sdktools>

public Plugin myinfo =
{
	name = "IdleKick Manager",
	author = "IntriguingTiles",
	description = "Automatically disables mp_idlekick on cutscene maps.",
	version = "1.0",
};

char maps[][] = {
    // hl2 intro
	"d1_trainstation_01",
    // kleiner's lab
	"d1_trainstation_05",
    // eli's lab
    "d1_eli_01",
    "d1_eli_02",
	// waiting for cart
	"d1_town_02",
	// cutscene before coast
	"d1_town_05",
	// alyx makes fun of poor people
	"d2_prison_06",
    // turret defense
	"d2_prison_07",
    // entanglement tele
	"d2_prison_08",
    // kleiner's lab 2
    "d3_c17_01",
	// tunnel holdout
	"d3_c17_06a",
	// plaza fight
	"d3_c17_07",
    // pod ride
    "d3_citadel_02",
	// elevator ride
	"d3_citadel_04",
	// pod ride 2
	"d3_citadel_05",
    // breen cutscene
	"d3_breen_01",
    // ep1 intro
	"ep1_citadel_00",
	// advisor pod cutscene
	"ep1_citadel_01",
	// citadel core cutscene
	"ep1_citadel_03",
	// train ride out of citadel
	"ep1_citadel_04",
	// meetup with barney
	"ep1_c17_02b",
    // ep1 train ride
	"ep1_c17_06",
	// ep2 intro
    "ep2_outland_01",
    // antlion fight, gman cutscene
    "ep2_outland_02",
	// dog vs strider
    "ep2_outland_10a",
	// silo
	"ep2_outland_11",
	// borealis yapping
	"ep2_outland_11b",
    // ep2 outro
    "ep2_outland_12a",
};

ConVar g_cvIdleKickManager;
ConVar g_cvIdleKick;
bool g_bDefaultIdleKick = false;

public void OnPluginStart()
{
	g_cvIdleKickManager = CreateConVar("sm_idlekick_manager", "1", "Enables IdleKick manager.");
	g_cvIdleKick = FindConVar("mp_idlekick");
	g_bDefaultIdleKick = GetConVarBool(g_cvIdleKick);
}

public void OnMapStart()
{
	if (!g_cvIdleKickManager.BoolValue) return;

	char mapName[65];
	GetCurrentMap(mapName, sizeof(mapName));

	for (int i = 0; i < sizeof(maps); i++)
	{
		if (StrEqual(mapName, maps[i], false))
		{
            SetConVarBool(g_cvIdleKick, false);
            LogAction(0, -1, "Disabled mp_idlekick");
            return;
		}
	}

	// if we got here, we can restore mp_idlekick
	SetConVarBool(g_cvIdleKick, g_bDefaultIdleKick);
	LogAction(0, -1, "Restored mp_idlekick");
}