/**
 * vim: set ts=4 :
 * =============================================================================
 * SourceMod Sample Extension
 * Copyright (C) 2004-2008 AlliedModders LLC.  All rights reserved.
 * =============================================================================
 *
 * This program is free software; you can redistribute it and/or modify it under
 * the terms of the GNU General Public License, version 3.0, as published by the
 * Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * As a special exception, AlliedModders LLC gives you permission to link the
 * code of this program (as well as its derivative works) to "Half-Life 2," the
 * "Source Engine," the "SourcePawn JIT," and any Game MODs that run on software
 * by the Valve Corporation.  You must obey the GNU General Public License in
 * all respects for all other code used.  Additionally, AlliedModders LLC grants
 * this exception to all derivative works.  AlliedModders LLC defines further
 * exceptions, found in LICENSE.txt (as of this writing, version JULY-31-2007),
 * or <http://www.sourcemod.net/license.php>.
 *
 * Version: $Id$
 */

#include "extension.h"
#include <appframework/IAppSystemGroup.h>
#include <engine_hlds_api.h>

/**
 * @file extension.cpp
 * @brief Implement extension code here.
 */

ServerFps g_ServerFps; /**< Global singleton for extension's main interface */

SMEXT_LINK(&g_ServerFps);

IDedicatedServerAPI *g_pDedicatedServerAPI = NULL;

cell_t sm_GetServerFPS(IPluginContext *pContext, const cell_t *params)
{
    if (!g_pDedicatedServerAPI)
        return sp_ftoc(0.0f);

    float fps = 0.0f;
    int nActive = 0, nMaxPlayers = 0;

    g_pDedicatedServerAPI->UpdateStatus(&fps, &nActive, &nMaxPlayers, NULL, 0);
    return sp_ftoc(fps);
}

const sp_nativeinfo_t MyNatives[] = {
    {"GetServerFPS", sm_GetServerFPS},
    {NULL, NULL},
};

bool ServerFps::SDK_OnLoad(char *error, size_t maxlen, bool late)
{
    g_pDedicatedServerAPI = (IDedicatedServerAPI *)g_SMAPI->GetEngineFactory()(VENGINE_HLDS_API_VERSION, NULL);

    if (!g_pDedicatedServerAPI)
    {
        if (error && maxlen)
            g_SMAPI->Format(error, maxlen, "Could not find interface %s", VENGINE_HLDS_API_VERSION);
        return false;
    }

    sharesys->AddNatives(myself, MyNatives);

    return true;
}
