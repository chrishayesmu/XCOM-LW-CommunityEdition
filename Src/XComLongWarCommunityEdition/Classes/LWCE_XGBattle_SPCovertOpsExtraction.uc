class LWCE_XGBattle_SPCovertOpsExtraction extends XGBattle_SPCovertOpsExtraction;

function CollectLoot()
{
    local int Index;
    local LWCE_XGBattleDesc kDesc;

    kDesc = LWCE_XGBattleDesc(m_kDesc);
    kDesc.m_kDropShipCargoInfo.m_kReward.iCredits += m_iCovertOpsCashRewardAmount;

    if (ShouldAwardIntel())
    {
        kDesc.m_kArtifactsContainer.Set(`LW_ITEM_ID(EXALTIntelligence), 1);
    }

    class'XComCollectible'.static.CollectCollectibles(m_kDesc.m_arrArtifacts);

    for (Index = 0; Index < m_kDesc.m_arrArtifacts.Length; Index++)
    {
        if (m_kDesc.m_arrArtifacts[Index] > 0)
        {
            kDesc.m_kArtifactsContainer.AdjustQuantity(Index, m_kDesc.m_arrArtifacts[Index]);
        }
    }

    kDesc.m_kArtifactsContainer.Set(`LW_ITEM_ID(Meld), GetRecoveredMeldAmount());
}

// IMPORTANT: This function is an override of a function in XGBattle_SP. Since we can't modify the inheritance hierarchy,
// this function has been inserted into each LWCE child class override of XGBattle_SP.
// ***If you modify this function, apply the changes in all child classes as well!***
function InitDescription()
{
    local XGNarrative kNarr;

    if (m_kTransferSave != none)
    {
        m_kDesc = m_kTransferSave.m_kBattleDesc;
        m_kDesc.InitAlienLoadoutInfos();
        PRES().SetNarrativeMgr(m_kDesc.m_kDropShipCargoInfo.m_kNarrative);

        if (class'Engine'.static.GetCurrentWorldInfo().GetMapName() == "DLC1_1_LowFriends")
        {
            PRES().UIPreloadNarrative(XComNarrativeMoment(DynamicLoadObject("NarrativeMomentsDLC60.DLC1_M01_ZhangIntroCin", class'XComNarrativeMoment')));
        }
    }
    else
    {
        m_kDesc = Spawn(class'LWCE_XGBattleDesc').Init();
        m_kDesc.m_iNumPlayers = m_iNumPlayers;
        m_kDesc.Generate();
        m_kDesc.InitHumanLoadoutInfosFromProfileSettingsSaveData(m_kProfileSettings);
        m_kDesc.InitCivilianContent(m_kProfileSettings);
        m_kDesc.InitAlienLoadoutInfos();
        m_kDesc.m_kDropShipCargoInfo.m_arrSoldiers = m_kProfileSettings.m_aSoldiers;

        if (PRES().m_kNarrative == none)
        {
            kNarr = Spawn(class'LWCE_XGNarrative');
            kNarr.InitNarrative();
            PRES().SetNarrativeMgr(kNarr);
        }
    }

    InitDifficulty();
}

simulated function InitLevel()
{
    local XComBuildingVolume kBuildingVolume;

    `LWCE_LOG_CLS("InitLevel: override successful");

    m_kLevel = Spawn(class'LWCE_XGLevel');
    m_kLevel.Init();

    foreach AllActors(class'XComBuildingVolume', kBuildingVolume)
    {
        kBuildingVolume.m_kLevel = m_kLevel;
    }

    m_kLevel.LoadStreamingLevels(false);

    m_kGrenadeMgr = Spawn(class'XComGrenadeManager');
    m_kGrenadeMgr.Init();

    m_kZombieMgr = Spawn(class'XComZombieManager');
    m_kZombieMgr.Init();

    if (Role == ROLE_Authority)
    {
        m_kVolumeMgr = Spawn(class'LWCE_XGVolumeMgr');
        m_kVolumeMgr.Init();
    }

    m_kGlamMgr = Spawn(class'XComGlamManager');
    m_kSpawnAlienQueue = Spawn(class'SpawnAlienQueue');

    m_kProjectileMgr = new class'XGProjectileManager';
}

function InitLoadedItems()
{
    local XComTacticalController kLocalPC;
    local XGPlayer kPlayer;
    local XGVolumeMgr kVolumeMgr;
    local XComSpecialMissionHandler_HQAssault kHQAssaultHandler;
    local int I;

    `LWCE_LOG_CLS("InitLoadedItems: override successful");

    InitDifficulty();
    m_kLevel.LoadInit();

    foreach WorldInfo.AllControllers(class'XComTacticalController', kLocalPC)
    {
        if (kLocalPC.Player != none)
        {
            kLocalPC.SetTeamType(m_arrPlayers[0].m_eTeam);
            m_arrPlayers[0].SetPlayerController(kLocalPC);
            kLocalPC.SetXGPlayer(m_arrPlayers[0]);
            break;
        }
    }

    for (I = 0; I < m_iNumPlayers; I++)
    {
        kPlayer = m_arrPlayers[I];
        kPlayer.LoadInit();
    }

    foreach WorldInfo.AllActors(class'XGVolumeMgr', kVolumeMgr)
    {
        m_kVolumeMgr = kVolumeMgr;
        kVolumeMgr.LoadInit();
        break;
    }

    if (m_kVolumeMgr == none && Role == ROLE_Authority)
    {
        m_kVolumeMgr = Spawn(class'LWCE_XGVolumeMgr');
        m_kVolumeMgr.Init();
    }

    foreach WorldInfo.AllActors(class'XComSpecialMissionHandler_HQAssault', kHQAssaultHandler)
    {
        kHQAssaultHandler.StartRequestingContent();
    }
}
