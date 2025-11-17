#include <sourcemod>
#include <admin>
#include <sdktools>
#include <sdkhooks>

public Plugin myinfo =
{
	name = "sm_mimic",
	author = "IntriguingTiles",
	description = "Like bot_mimic but for players.",
	version = "1.0"
};

bool g_bEnabled = false;
bool g_bHasMimicData = false;
int g_iClientToMimic = -1;

int mimicbuttons = 0;
int mimicimpulse = 0;
float mimicvel[3] = { 0.0, 0.0, 0.0 };
float mimicangles[3] = { 0.0, 0.0, 0.0 };
int mimicweapon = 0;
int mimicsubtype = 0;
// int mimiccmdnum = 0;
// int mimictickcount = 0;
int mimicseed = 0;
int mimicmouse[2] = { 0, 0 };

public void OnPluginStart()
{
	RegAdminCmd("sm_mimic", Cmd_Mimic, ADMFLAG_SLAY);
}

public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon, int &subtype, int &cmdnum, int &tickcount, int &seed, int mouse[2])
{
	if (g_bEnabled && client != g_iClientToMimic && g_bHasMimicData && !GetAdminFlag(GetUserAdmin(client), Admin_Generic))
	{
        buttons = mimicbuttons;
        impulse = mimicimpulse;
        vel[0] = mimicvel[0];
        vel[1] = mimicvel[1];
        vel[2] = mimicvel[2];
        angles[0] = mimicangles[0];
        angles[1] = mimicangles[1];
        angles[2] = mimicangles[2];
        weapon = mimicweapon;
        subtype = mimicsubtype;
        // cmdnum = mimiccmdnum;
        // tickcount = mimictickcount;
        seed = mimicseed;
        mouse[0] = mimicmouse[0];
        mouse[1] = mimicmouse[1];
	}
	else if (g_bEnabled && client == g_iClientToMimic)
	{
        mimicbuttons = buttons;
        mimicimpulse = impulse;
        mimicvel[0] = vel[0];
        mimicvel[1] = vel[1];
        mimicvel[2] = vel[2];
        mimicangles[0] = angles[0];
        mimicangles[1] = angles[1];
        mimicangles[2] = angles[2];
        mimicweapon = weapon;
        mimicsubtype = subtype;
        // mimiccmdnum = cmdnum;
        // mimictickcount = tickcount;
        mimicseed = seed;
        mimicmouse[0] = mouse[0];
        mimicmouse[1] = mouse[1];
        g_bHasMimicData = true;
    }

    return Plugin_Continue;
}

public Action Cmd_Mimic(int client, int args)
{
    if (!g_bEnabled) {
        g_iClientToMimic = client;
        g_bHasMimicData = false;
        g_bEnabled = true;
        ShowActivity2(client, "[SM] ", "enabled mimic mode.");
    } else {
        g_iClientToMimic = -1;
        g_bHasMimicData = false;
        g_bEnabled = false;
        ShowActivity2(client, "[SM] ", "disabled mimic mode.");
    }

    return Plugin_Handled;
}