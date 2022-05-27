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

static function InitPlayers(XGBattle_SP kSelf, optional bool bLoading = false)
{
    local XGPlayer kPlayer;
    local XGAIPlayer kAIPlayer;
    local int I, J;
    local XGUnit kUnit;
    local XCom3DCursor kCursor;
    local array<int> arrTechHistory;
    local array<TTransferSoldier> arrTransfers, arrReinforcements;
    local array<LWCE_TTransferSoldier> arrCETransfers;

    if (bLoading)
    {
        for (I = 0; I < kSelf.m_iNumPlayers; I++)
        {
            kPlayer = kSelf.m_arrPlayers[I];
            kAIPlayer = XGAIPlayer(kPlayer);

            if (kAIPlayer != none)
            {
                kAIPlayer.Init(bLoading);
                kAIPlayer.InitRules();
            }
        }
    }
    else
    {
        kSelf.m_kPodMgr = kSelf.Spawn(class'XComAlienPodManager');
        kSelf.m_kPodMgr.InitPods();

        for (I = 0; I < kSelf.m_iNumPlayers; I++)
        {
            kPlayer = kSelf.m_arrPlayers[I];

            if (kSelf.m_kTransferSave != none)
            {
                `LWCE_LOG_CLS("Branch: kSelf.m_kTransferSave");

                if (XGAIPlayer_Animal(kPlayer) != none || XGAIPlayer(kPlayer) == none)
                {
                    if (kSelf.m_kDesc.m_iMissionType == eMission_HQAssault && XGAIPlayer_Animal(kPlayer) == none)
                    {
                        // Human player
                        for (J = 0; J < 3; J++)
                        {
                            arrTransfers.AddItem(kSelf.m_kTransferSave.m_kBattleDesc.m_kDropShipCargoInfo.m_arrSoldiers[J]);
                        }

                        for (J = 3; J < kSelf.m_kTransferSave.m_kBattleDesc.m_kDropShipCargoInfo.m_arrSoldiers.Length; J++)
                        {
                            arrReinforcements.AddItem(kSelf.m_kTransferSave.m_kBattleDesc.m_kDropShipCargoInfo.m_arrSoldiers[J]);
                        }

                        kSelf.SaveHQAssaultReinforcements(kPlayer, arrReinforcements);
                    }
                    else
                    {
                        arrTransfers = kSelf.m_kTransferSave.m_kBattleDesc.m_kDropShipCargoInfo.m_arrSoldiers;
                        arrCETransfers = LWCE_XGDropshipCargoInfo(kSelf.m_kTransferSave.m_kBattleDesc.m_kDropShipCargoInfo).m_arrCESoldiers;
                    }

                    class'LWCE_XGPlayer_Extensions'.static.LoadSquad(kPlayer, arrTransfers, arrCETransfers, kSelf.m_kTransferSave.m_kBattleDesc.m_kDropShipCargoInfo.m_arrTechHistory, kSelf.GetSpawnPoints(kPlayer.m_eTeam), kSelf.GetPawnTypes(kPlayer.m_eTeam));
                }
            }
            else if (kSelf.m_kProfileSettings != none)
            {
                arrTechHistory.Add(61);
                // TODO: not clear if this branch is anything other than tactical quick start; can ignore if so, otherwise need to populate
                // arrCETransfers from somewhere
                `LWCE_LOG_CLS("Branch: kSelf.m_kProfileSettings");
                class'LWCE_XGPlayer_Extensions'.static.LoadSquad(kPlayer, kSelf.m_kProfileSettings.m_aSoldiers, arrCETransfers, arrTechHistory, kSelf.GetSpawnPoints(kPlayer.m_eTeam), kSelf.GetPawnTypes(kPlayer.m_eTeam));
            }
            else
            {
                `LWCE_LOG_CLS("Branch: neither transfer save nor profile settings");
                arrCETransfers = LWCE_XGDropshipCargoInfo(kSelf.m_kDesc.m_kDropShipCargoInfo).m_arrCESoldiers;
                class'LWCE_XGPlayer_Extensions'.static.LoadSquad(kPlayer, kSelf.m_kDesc.m_kDropShipCargoInfo.m_arrSoldiers, arrCETransfers, kSelf.m_kDesc.m_kDropShipCargoInfo.m_arrTechHistory, kSelf.GetSpawnPoints(kPlayer.m_eTeam), kSelf.GetPawnTypes(kPlayer.m_eTeam));
            }
        }
    }

    kPlayer = kSelf.GetHumanPlayer();
    kUnit = kPlayer.GetSquad().GetMemberAt(0);

    if (kUnit != none)
    {
        kCursor = kPlayer.m_kPlayerController.GetCursor();

        if (kCursor != none)
        {
            kSelf.PRES().GetCamera().m_kLookAtView.SetTransition(eTransition_Cut);
            kSelf.PRES().GetCamera().LookAt(kUnit.Location);
            kSelf.PRES().GetCamera().m_kLookAtView.SetTransition(eTransition_Blend);
        }
    }
}