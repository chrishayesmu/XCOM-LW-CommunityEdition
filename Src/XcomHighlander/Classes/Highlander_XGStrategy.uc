class Highlander_XGStrategy extends XGStrategy;

function NewGame() {
    `HL_LOG_CLS("(highlander override)");

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
        m_kAI = Spawn(class'Highlander_XGStrategyAI');
    }

    m_kRecapSaveData = Spawn(class'XGRecapSaveData');

    if (m_kExaltSimulation == none) {
        m_kExaltSimulation = Spawn(class'XGExaltSimulation');
    }

    // For Dynamic War: sets the counter for each of these mission types to already be partly populated, so they
    // don't all spawn at once and there's some control over which missions occur when at the start of the game.
    m_arrMissionTotals.Add(41);
    m_arrMissionTotals[30] = int(class'XGTacticalGameCore'.default.SW_ELERIUM_LOSS * 0.20); // Research
    m_arrMissionTotals[31] = int(class'XGTacticalGameCore'.default.SW_ELERIUM_LOSS * 0.70); // Scout
    m_arrMissionTotals[32] = int(class'XGTacticalGameCore'.default.SW_ELERIUM_LOSS * 0.40); // Harvest
    m_arrMissionTotals[35] = int(class'XGTacticalGameCore'.default.SW_ELERIUM_LOSS * 0.70); // Abduction
    m_arrMissionTotals[36] = int(class'XGTacticalGameCore'.default.SW_ELERIUM_LOSS * 0.50); // Terror

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
    `HL_LOG_CLS("(highlander override) - OnLoadedGame");
    super.OnLoadedGame();
}

function Init(bool bLoadingFromSave)
{
    `HL_LOG_CLS("(highlander override) - bLoadingFromSave = " $ bLoadingFromSave);

    if (m_arrSecondWave.Length == 0)
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

    if (bLoadingFromSave)
    {
        InitDifficulty(m_iDifficulty);
    }
}
