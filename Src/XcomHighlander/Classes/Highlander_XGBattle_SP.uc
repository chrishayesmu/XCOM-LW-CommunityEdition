class Highlander_XGBattle_SP extends XGBattle_SP;

simulated function InitLevel()
{
    local XComBuildingVolume kBuildingVolume;

    LogInternal(string(Class) $ ":InitLevel: override successful");

    m_kLevel = Spawn(class'XGLevel');
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
        // HIGHLANDER: Override XGVolumeMgr class
        m_kVolumeMgr = Spawn(class'Highlander_XGVolumeMgr');
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

    LogInternal(string(Class) $ ":InitLoadedItems: override successful");

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
        // HIGHLANDER: Override XGVolumeMgr class
        m_kVolumeMgr = Spawn(class'Highlander_XGVolumeMgr');
        m_kVolumeMgr.Init();
    }

    foreach WorldInfo.AllActors(class'XComSpecialMissionHandler_HQAssault', kHQAssaultHandler)
    {
        kHQAssaultHandler.StartRequestingContent();
    }
}