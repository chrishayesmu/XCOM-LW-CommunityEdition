class Highlander_XGStrategy extends XGStrategy;


function NewGame() {
    LogInternal(string(Class) $ " : (highlander override)");

    if (class'Engine'.static.GetCurrentWorldInfo().Game.BaseMutator != none) {
        class'Engine'.static.GetCurrentWorldInfo().Game.BaseMutator.Mutate("XGStrategy.NewGame", class'Engine'.static.GetCurrentWorldInfo().GetALocalPlayerController());
    }

    if (m_kWorld == none) {
        m_kWorld = Spawn(class'XGWorld');
    }

    if (m_kGeoscape == none) {
        m_kGeoscape = Spawn(class'XGGeoscape');
    }

    if (m_kHQ == none) {
        m_kHQ = Spawn(class'XGHeadQuarters');
    }

    if (m_kAI == none) {
        m_kAI = Spawn(class'XGStrategyAI');
    }

    m_kRecapSaveData = Spawn(class'XGRecapSaveData');

    if (m_kExaltSimulation == none) {
        m_kExaltSimulation = Spawn(class'XGExaltSimulation');
    }

    m_arrMissionTotals.Add(41);
    m_arrMissionTotals[30] = int(class'XGTacticalGameCore'.default.SW_ELERIUM_LOSS * 0.20);
    m_arrMissionTotals[31] = int(class'XGTacticalGameCore'.default.SW_ELERIUM_LOSS * 0.70);
    m_arrMissionTotals[32] = int(class'XGTacticalGameCore'.default.SW_ELERIUM_LOSS * 0.40);
    m_arrMissionTotals[35] = int(class'XGTacticalGameCore'.default.SW_ELERIUM_LOSS * 0.70);
    m_arrMissionTotals[36] = int(class'XGTacticalGameCore'.default.SW_ELERIUM_LOSS * 0.50);

    if (m_kNarrative == none) {
        m_kNarrative = Spawn(class'XGNarrative');
        m_kNarrative.InitNarrative(XComHeadquartersGame(WorldInfo.Game).m_bSuppressFirstTimeNarrative);
    }

    m_arrItemUnlocks.Add(255);
    m_arrGeneModUnlocks.Add(11);
    m_arrFacilityUnlocks.Add(24);
    m_arrFoundryUnlocks.Add(48);
    m_arrSecondWave.Add(36);

    Init(false);
    GotoState('Initing');
}

function OnLoadedGame()
{
    LogInternal(string(Class) $ " : (highlander override) - OnLoadedGame");
    super.OnLoadedGame();
}

function Init(bool bLoadingFromSave)
{
    LogInternal(string(Class) $ " : (highlander override) - bLoadingFromSave = " $ bLoadingFromSave);

    // End:0x1D
    if(m_arrSecondWave.Length == 0)
    {
        m_arrSecondWave.Add(36);
    }
    m_bLoadedFromSave = bLoadingFromSave;
    m_bGameOver = false;
    m_kWorld.Init(!bLoadingFromSave);
    m_kGeoscape.Init();
    m_kHQ.Init(bLoadingFromSave);
    m_kAI.Init();
    m_kExaltSimulation.Init(bLoadingFromSave);
    PRES().InitUIScreens();
    PRES().SetNarrativeMgr(m_kNarrative);
    m_bOvermindEnabled = true;
    // End:0x16E
    if(bLoadingFromSave)
    {
        InitDifficulty(m_iDifficulty);
    }
    //return;
}
