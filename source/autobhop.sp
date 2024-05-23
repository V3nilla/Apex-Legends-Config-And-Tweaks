#include <sourcemod>
#include <sdktools>

#define PLUGIN_VERSION "1.0"

bool g_Bhop[MAXPLAYERS + 1];

public Plugin:myinfo = 
{
    name = "[L4D2] Server-Side Auto Bunnyhop",
    author = "Vanilla",
    description = "Automatically enables bunnyhopping for players.",
    version = PLUGIN_VERSION,
    url = "https://github.com/V3nilla"
};

public OnPluginStart()
{
    RegConsoleCmd("sm_bhop", Cmd_Bhop);
    LoadTranslations("custom_autobhop.phrases");
}

public Action:Cmd_Bhop(int client, int args)
{
    if (!IsPlayerAdmin(client))
    {
        PrintToChat(client, "%t", "No Permission");
        return Plugin_Handled;
    }

    g_Bhop[client] = !g_Bhop[client];

    if (g_Bhop[client])
    {
        PrintToChat(client, "%t", "AutoBhop Enabled");
    }
    else
    {
        PrintToChat(client, "%t", "AutoBhop Disabled");
    }

    return Plugin_Handled;
}

public Action:OnPlayerRunCmd(int client, int &buttons)
{
    if (client > 0 && g_Bhop[client] && IsPlayerAlive(client))
    {
        if ((buttons & IN_JUMP) && !(GetEntProp(client, Prop_Send, "m_fFlags") & FL_ONGROUND))
        {
            buttons &= ~IN_JUMP;
        }
    }
    return Plugin_Continue;
}

bool IsPlayerAdmin(int client)
{
    return GetUserFlagBits(client) & ADMFLAG_ROOT;
}
