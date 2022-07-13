class LWCE_UIInterceptionEngagement extends UIInterceptionEngagement;

simulated function OnInit()
{
    local int I, playerShipType, enemyShipType;

    super(UI_FxsScreen).OnInit();

    m_iView = -1;
    m_kMgr = GetMgr();
    m_kMgr.PostInit(m_kXGInterception);
    m_fPlaybackTimeElapsed = 0.0;
    m_fEnemyEscapeTimer = 0.0;
    m_iTenthsOfSecondCounter = 0;
    m_fTrackingTimer = 0.0;
    m_fTotalBattleLength = m_kMgr.m_kInterceptionEngagement.GetTimeUntilOutrun(1);
    m_iInterceptorPlaybackIndex = 0;
    m_iUFOPlaybackIndex = 0;
    m_iBulletIndex = 0;
    m_iLastDodgeBulletIndex = -1;
    m_bPendingDisengage = false;
    m_bViewingResults = false;
    m_DataInitialized = false;

    enemyShipType = m_kMgr.m_kInterceptionEngagement.GetShip(0).GetType();

    switch (enemyShipType)
    {
        case 10: // Fighter
            I = eShip_UFOSmallScout;
            break;
        case 11: // Raider
            I = eShip_UFOLargeScout;
            break;
        case 12: // Harvester
            I = eShip_UFOAbductor;
            break;
        case 13: // Terror Ship
            I = eShip_UFOSupply;
            break;
        case 14: // Assault Carrier
            I = eShip_UFOBattle;
            break;
    }

    if (enemyShipType >= 10)
    {
        enemyShipType = I;
    }

    playerShipType = m_kMgr.m_kInterceptionEngagement.GetShip(1).GetType();

    AS_SetResultsTitleLabels(m_strReport_Title, m_strReport_Subtitle);
    AS_InitializeData(playerShipType, enemyShipType, m_strPlayerDamageLabel, m_strEstablishingLinkLabel);

    for (I = 0; I < m_kMgr.m_kInterceptionEngagement.GetNumShips(); I++)
    {
        AS_SetHP(I, m_kMgr.m_kInterceptionEngagement.GetShip(I).GetHullStrength(), true);
        AS_SetHP(I, m_kMgr.m_kInterceptionEngagement.GetShip(I).m_iHP, true);
    }

    AS_SetAbortButtonText(m_strAbortMission);
    AS_SetEnemyEscapeTimerLabels(m_strEscapeTimerTitle, m_strTimeSufixSymbol);
    SetConsumablesState(0);

    m_DataInitialized = true;
    enemyShipType = m_kMgr.m_kInterceptionEngagement.GetShip(0).GetType();

    if (!`LWCE_ENGINEERING.LWCE_IsFoundryTechResearched('Foundry_UFOScanners'))
    {
        Invoke("HideUFODamage");
    }
    else if (!`LWCE_LABS.LWCE_IsResearched(UFOTypeToAnalysisTech(enemyShipType)))
    {
        Invoke("HideUFODamage");
    }
}

simulated event Tick(float fDeltaT)
{
    super.Tick(fDeltaT);
}

protected function name UFOTypeToAnalysisTech(int iShipType)
{
    switch (iShipType)
    {
        case 4:
            return 'Tech_UFOAnalysis_Scout';
        case 5:
            return 'Tech_UFOAnalysis_Destroyer';
        case 6:
            return 'Tech_UFOAnalysis_Abductor';
        case 7:
            return 'Tech_UFOAnalysis_Transport';
        case 8:
            return 'Tech_UFOAnalysis_Battleship';
        case 9:
            return 'Tech_UFOAnalysis_Overseer';
        case 10:
            return 'Tech_UFOAnalysis_Fighter';
        case 11:
            return 'Tech_UFOAnalysis_Raider';
        case 12:
            return 'Tech_UFOAnalysis_Harvester';
        case 13:
            return 'Tech_UFOAnalysis_TerrorShip';
        case 14:
            return 'Tech_UFOAnalysis_AssaultCarrier';
        default:
            return '';
    }
}