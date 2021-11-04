class Highlander_XGStrategy extends XGStrategy;

function NewGame() {
    `HL_LOG_CLS("(highlander override)");

    if (class'Engine'.static.GetCurrentWorldInfo().Game.BaseMutator != none) {
        class'Engine'.static.GetCurrentWorldInfo().Game.BaseMutator.Mutate("XGStrategy.NewGame", class'Engine'.static.GetCurrentWorldInfo().GetALocalPlayerController());
    }

    ValidateNewGameState();

    m_kWorld = Spawn(class'Highlander_XGWorld');
    m_kGeoscape = Spawn(class'Highlander_XGGeoscape');
    m_kHQ = Spawn(class'Highlander_XGHeadQuarters');
    m_kAI = Spawn(class'Highlander_XGStrategyAI');
    m_kRecapSaveData = Spawn(class'Highlander_XGRecapSaveData');
    m_kExaltSimulation = Spawn(class'Highlander_XGExaltSimulation');

    // For Dynamic War: sets the counter for each of these mission types to already be partly populated, so they
    // don't all spawn at once and there's some control over which missions occur when at the start of the game.
    m_arrMissionTotals.Add(41);
    m_arrMissionTotals[30] = int(class'XGTacticalGameCore'.default.SW_ELERIUM_LOSS * 0.20); // Research
    m_arrMissionTotals[31] = int(class'XGTacticalGameCore'.default.SW_ELERIUM_LOSS * 0.70); // Scout
    m_arrMissionTotals[32] = int(class'XGTacticalGameCore'.default.SW_ELERIUM_LOSS * 0.40); // Harvest
    m_arrMissionTotals[35] = int(class'XGTacticalGameCore'.default.SW_ELERIUM_LOSS * 0.70); // Abduction
    m_arrMissionTotals[36] = int(class'XGTacticalGameCore'.default.SW_ELERIUM_LOSS * 0.50); // Terror

    m_kNarrative = Spawn(class'Highlander_XGNarrative');
    m_kNarrative.InitNarrative(XComHeadquartersGame(WorldInfo.Game).m_bSuppressFirstTimeNarrative);

    m_arrItemUnlocks.Add(255);
    m_arrGeneModUnlocks.Add(11);
    m_arrFacilityUnlocks.Add(24);
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

function bool HL_UnlockFoundryProject(int iProject, out TItemUnlock kUnlock)
{
    local HL_TFoundryTech kTech;

    if (m_arrFoundryUnlocks.Find(iProject) == INDEX_NONE)
    {
        kTech = `HL_FTECH(iProject);

        kUnlock.bFoundryProject = true;
        kUnlock.sndFanfare = SNDLIB().SFX_Unlock_Foundry;
        kUnlock.iUnlocked = iProject;
        kUnlock.strName = kTech.strName;
        kUnlock.strDescription = kTech.strSummary;
        kUnlock.strTitle = m_strNewFoundryAvailable;
        kUnlock.strHelp = m_strNewFoundryHelp;

        m_arrFoundryUnlocks.AddItem(iProject);

        return true;
    }
    else
    {
        return false;
    }
}

protected function ValidateNewGameState()
{
    local bool bAnyInvalid;

    bAnyInvalid = false;

    if (m_kWorld != none)
    {
        `HL_LOG_CLS("WARNING: m_kWorld is already set. Its class is " $ string(m_kWorld.Class));
        bAnyInvalid = true;
    }

    if (m_kGeoscape != none)
    {
        `HL_LOG_CLS("WARNING: m_kGeoscape is already set. Its class is " $ string(m_kGeoscape.Class));
        bAnyInvalid = true;
    }

    if (m_kHQ != none)
    {
        `HL_LOG_CLS("WARNING: m_kHQ is already set. Its class is " $ string(m_kHQ.Class));
        bAnyInvalid = true;
    }

    if (m_kAI != none)
    {
        `HL_LOG_CLS("WARNING: m_kAI is already set. Its class is " $ string(m_kAI.Class));
        bAnyInvalid = true;
    }

    if (m_kRecapSaveData != none)
    {
        `HL_LOG_CLS("WARNING: m_kRecapSaveData is already set. Its class is " $ string(m_kRecapSaveData.Class));
        bAnyInvalid = true;
    }

    if (m_kExaltSimulation != none)
    {
        `HL_LOG_CLS("WARNING: m_kExaltSimulation is already set. Its class is " $ string(m_kExaltSimulation.Class));
        bAnyInvalid = true;
    }

    if (m_kNarrative != none)
    {
        `HL_LOG_CLS("WARNING: m_kNarrative is already set. Its class is " $ string(m_kNarrative.Class));
        bAnyInvalid = true;
    }

    if (bAnyInvalid)
    {
        `HL_LOG_CLS("Any XGStrategy member which is already set will be overridden by the Highlander. This was most likely done by a mutator-based mod, and that mod will not function properly.");
    }
}