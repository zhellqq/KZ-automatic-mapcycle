// ====[ INCLUDES ]===========================================================

#include <sourcemod>
#include <steamworks>

#pragma newdecls required;

// ====[ DEFINES ]=============================================================

#define PLUGIN_NAME "KZTimer automatic mapcycle"
#define PLUGIN_AUTHOR "zhell"   
#define PLUGIN_VERSION 	"1.0"
#define PLUGIN_DESCRIPTION "Simple plugin that downloads the latest mapcycle from TWW's FastDL"
#define PLUGIN_URL ""

// ====[ COLORS ]==============================================================

// {default} {darkred} {green} {lightgreen} {red} {blue} {olive} {lime} {lightred} {purple} {grey} {yellow} {orange} {bluegrey} {lightblue} {darkblue} {grey2} {orchid} {lightred2}

// ====[ CVARS | HANDLES | VARIABLES ]=========================================

Handle gH_RequestURL;

// ====[ PLUGIN ]==============================================================

public Plugin myinfo = {
	name = PLUGIN_NAME,
	author = PLUGIN_AUTHOR,
	description = PLUGIN_DESCRIPTION,
	version = PLUGIN_VERSION,
	url = PLUGIN_URL
}

// ====[ FUNCTIONS ]===========================================================

public void OnPluginStart()
{
	gH_RequestURL = CreateConVar("sm_mapcycle_url", "https://kzmaps.tangoworldwide.net/mapcycles/kztimer.txt", "URL to request for the mapcycle; for GOKZ replace kztimer.txt with gokz.txt");
}

public void OnMapStart()
{
	StartRequest();
}

public void StartRequest()
{
	char szUrl[64];
	GetConVarString(gH_RequestURL, szUrl, sizeof(szUrl));
	
	Handle hRequest = SteamWorks_CreateHTTPRequest(k_EHTTPMethodGET, szUrl);
	if (!hRequest || !SteamWorks_SetHTTPCallbacks(hRequest, OnTransferComplete) || !SteamWorks_SendHTTPRequest(hRequest))
	{
		delete hRequest;
	}
}

public int OnTransferComplete(Handle hRequest, bool bFailure, bool bRequestSuccessful, EHTTPStatusCode eStatusCode)
{
	if (!bFailure && bRequestSuccessful && eStatusCode == k_EHTTPStatusCode200OK)
	{
		DeleteFile("mapcycle.txt");
		DeleteFile("maplist.txt");
		
		SteamWorks_WriteHTTPResponseBodyToFile(hRequest, "mapcycle.txt");
		SteamWorks_WriteHTTPResponseBodyToFile(hRequest, "maplist.txt");
	}

	delete hRequest;
}
