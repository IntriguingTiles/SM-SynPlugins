#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <dhooks>

Handle g_hGameConf;
Handle g_hStartLagCompensation;
Handle g_hFinishLagCompensation;
int g_iNumCalls = 0;

public Plugin myinfo =
{
    name = "Lag Compensation Guard",
    author = "IntriguingTiles",
    description = "Prevents lag compensation from being called twice.",
    version = "1.0",
};

public void OnPluginStart()
{
    g_hGameConf = LoadGameConfigFile("lagcomp_guard.synergy");

    // CLagCompensationManager::StartLagCompensation
    g_hStartLagCompensation = DHookCreateDetour(Address_Null, CallConv_THISCALL, ReturnType_Void, ThisPointer_Address);
    DHookSetFromConf(g_hStartLagCompensation, g_hGameConf, SDKConf_Signature, "StartLagCompensation");
    DHookAddParam(g_hStartLagCompensation, HookParamType_CBaseEntity);
    DHookAddParam(g_hStartLagCompensation, HookParamType_ObjectPtr);
    DHookEnableDetour(g_hStartLagCompensation, false, Hooked_StartLagCompensation);

    // CLagCompensationManager::FinishLagCompensation
    g_hFinishLagCompensation = DHookCreateDetour(Address_Null, CallConv_THISCALL, ReturnType_Void, ThisPointer_Address);
    DHookSetFromConf(g_hFinishLagCompensation, g_hGameConf, SDKConf_Signature, "FinishLagCompensation");
    DHookAddParam(g_hFinishLagCompensation, HookParamType_CBaseEntity);
    DHookEnableDetour(g_hFinishLagCompensation, false, Hooked_FinishLagCompensation);
}

public MRESReturn Hooked_StartLagCompensation(Address pThis, Handle hReturn, Handle hParams)
{
    g_iNumCalls++;

    if (g_iNumCalls > 1)
    {
        // LogAction(-1, 0, "Start lag compensation called twice! Ignoring...");
        return MRES_Supercede;
    }

    return MRES_Ignored;
}

public MRESReturn Hooked_FinishLagCompensation(Address pThis, Handle hReturn, Handle hParams)
{
    g_iNumCalls--;

    if (g_iNumCalls > 0)
    {
        // LogAction(-1, 0, "Finish lag compensation called twice! Ignoring...");
        return MRES_Supercede;
    }

    return MRES_Ignored;
}