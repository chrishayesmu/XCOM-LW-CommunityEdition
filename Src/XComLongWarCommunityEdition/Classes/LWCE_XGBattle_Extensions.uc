class LWCE_XGBattle_Extensions extends Object
    abstract;

static function InitDescription(XGBattle kSelf)
{
    local XGNarrative kNarr;

    if (kSelf.m_kTransferSave != none)
    {
        kSelf.m_kDesc = kSelf.m_kTransferSave.m_kBattleDesc;
        kSelf.m_kDesc.InitAlienLoadoutInfos();
        kSelf.PRES().SetNarrativeMgr(kSelf.m_kDesc.m_kDropShipCargoInfo.m_kNarrative);

        if (class'Engine'.static.GetCurrentWorldInfo().GetMapName() == "DLC1_1_LowFriends")
        {
            kSelf.PRES().UIPreloadNarrative(XComNarrativeMoment(DynamicLoadObject("NarrativeMomentsDLC60.DLC1_M01_ZhangIntroCin", class'XComNarrativeMoment')));
        }
    }
    else
    {
        kSelf.m_kDesc = kSelf.Spawn(class'LWCE_XGBattleDesc').Init();
        kSelf.m_kDesc.m_iNumPlayers = kSelf.m_iNumPlayers;
        kSelf.m_kDesc.Generate();
        kSelf.m_kDesc.InitHumanLoadoutInfosFromProfileSettingsSaveData(kSelf.m_kProfileSettings);
        kSelf.m_kDesc.InitCivilianContent(kSelf.m_kProfileSettings);
        kSelf.m_kDesc.InitAlienLoadoutInfos();
        kSelf.m_kDesc.m_kDropShipCargoInfo.m_arrSoldiers = kSelf.m_kProfileSettings.m_aSoldiers;

        if (kSelf.PRES().m_kNarrative == none)
        {
            kNarr = kSelf.Spawn(class'LWCE_XGNarrative');
            kNarr.InitNarrative();
            kSelf.PRES().SetNarrativeMgr(kNarr);
        }
    }

    kSelf.InitDifficulty();
}

static function InitLevel(XGBattle kSelf)
{
    local XComBuildingVolume kBuildingVolume;

    `LWCE_LOG_CLS("InitLevel: override successful");

    kSelf.m_kLevel = kSelf.Spawn(class'LWCE_XGLevel');
    kSelf.m_kLevel.Init();

    foreach kSelf.AllActors(class'XComBuildingVolume', kBuildingVolume)
    {
        kBuildingVolume.m_kLevel = kSelf.m_kLevel;
    }

    kSelf.m_kLevel.LoadStreamingLevels(false);

    kSelf.m_kGrenadeMgr = kSelf.Spawn(class'XComGrenadeManager');
    kSelf.m_kGrenadeMgr.Init();

    kSelf.m_kZombieMgr = kSelf.Spawn(class'XComZombieManager');
    kSelf.m_kZombieMgr.Init();

    if (kSelf.Role == ROLE_Authority)
    {
        kSelf.m_kVolumeMgr = kSelf.Spawn(class'LWCE_XGVolumeMgr');
        kSelf.m_kVolumeMgr.Init();
    }

    kSelf.m_kGlamMgr = kSelf.Spawn(class'XComGlamManager');
    kSelf.m_kSpawnAlienQueue = kSelf.Spawn(class'SpawnAlienQueue');

    kSelf.m_kProjectileMgr = new class'XGProjectileManager';
}

static function InitLoadedItems(XGBattle kSelf)
{
    local XComTacticalController kLocalPC;
    local XGPlayer kPlayer;
    local XGVolumeMgr kVolumeMgr;
    local XComSpecialMissionHandler_HQAssault kHQAssaultHandler;
    local int I;

    `LWCE_LOG_CLS("InitLoadedItems: override successful");

    kSelf.InitDifficulty();
    `LWCE_LOG_CLS("InitDifficulty complete");

    kSelf.m_kLevel.LoadInit();
    `LWCE_LOG_CLS("Level LoadInit complete");

    foreach kSelf.WorldInfo.AllControllers(class'XComTacticalController', kLocalPC)
    {
        if (kLocalPC.Player != none)
        {
            kLocalPC.SetTeamType(kSelf.m_arrPlayers[0].m_eTeam);
            kSelf.m_arrPlayers[0].SetPlayerController(kLocalPC);
            kLocalPC.SetXGPlayer(kSelf.m_arrPlayers[0]);
            break;
        }
    }

    `LWCE_LOG_CLS("PlayerController setup complete");

    for (I = 0; I < kSelf.m_iNumPlayers; I++)
    {
        `LWCE_LOG_CLS("LoadInit beginning for player " $ I);

        kPlayer = kSelf.m_arrPlayers[I];
        kPlayer.LoadInit();

        `LWCE_LOG_CLS("LoadInit complete for player " $ I);
    }

    foreach kSelf.WorldInfo.AllActors(class'XGVolumeMgr', kVolumeMgr)
    {
        kSelf.m_kVolumeMgr = kVolumeMgr;
        kVolumeMgr.LoadInit();
        `LWCE_LOG_CLS("LoadInit complete for XGVolumeMgr");
        break;
    }

    if (kSelf.m_kVolumeMgr == none && kSelf.Role == ROLE_Authority)
    {
        kSelf.m_kVolumeMgr = kSelf.Spawn(class'LWCE_XGVolumeMgr');
        kSelf.m_kVolumeMgr.Init();
        `LWCE_LOG_CLS("New Init complete for XGVolumeMgr");
    }

    foreach kSelf.WorldInfo.AllActors(class'XComSpecialMissionHandler_HQAssault', kHQAssaultHandler)
    {
        kHQAssaultHandler.StartRequestingContent();
    }

    `LWCE_LOG_CLS("InitLoadedItems: end");
}