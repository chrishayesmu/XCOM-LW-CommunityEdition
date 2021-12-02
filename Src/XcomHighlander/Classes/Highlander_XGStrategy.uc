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

function BeginCombat(XGMission kMission)
{
    local UIFxsMovieMgr UIMgr;
    local XGShip_Dropship kSkyranger;
    local TPawnContent Content;
    local XComDropshipAudioMgr DropshipAudioManager;
    local XGStrategySoldier kSoldier;

    kSkyranger = kMission.GetAssignedSkyranger();

    if (kMission.m_iMissionType == eMission_AlienBase)
    {
        // ABAs have their squad rerolled when the mission is launched; all other types use the squad generated when the mission is
        // created. This is because an ABA can be on the Geoscape for an arbitrarily long time, and the original squad might be very
        // outdated by the time the player finally launches.
        kMission.m_kDesc.m_kAlienSquad = AI().DetermineAlienBaseSquad();
        STORAGE().RemoveItem(eItem_Skeleton_Key);
    }

    kMission.m_strTip = GetTip(eTip_Tactical);

    if (kSkyranger.GetCapacity() == 8 && STAT_GetStat(eRecap_FirstSixSoldierMission) == 0)
    {
        STAT_SetStat(eRecap_FirstSixSoldierMission, Game().GetDays());
    }

    GEOSCAPE().Pause();

    if (m_kStrategyTransport == none)
    {
        m_kStrategyTransport = Spawn(class'StrategyGameTransport');
    }

    m_kStrategyTransport.m_kBattleDesc = kMission.m_kDesc;
    m_kStrategyTransport.m_kBattleDesc.m_bSilenceNewbieMoments = m_kNarrative.SilenceNewbieMoments();
    m_kStrategyTransport.m_kBattleDesc.m_bIsTutorial = m_bTutorial;
    m_kStrategyTransport.m_kBattleDesc.m_bOvermindEnabled = m_bOvermindEnabled;
    m_kStrategyTransport.m_kBattleDesc.m_bIsIronman = m_bIronMan;
    m_kStrategyTransport.m_kBattleDesc.m_eContinent = EContinent(kMission.GetContinent().GetID());
    m_kStrategyTransport.m_kBattleDesc.m_eTimeOfDay = GEOSCAPE().m_kDateTime.GetTimeOfDay();
    m_kStrategyTransport.m_kBattleDesc.m_kMedalBattleData = BARRACKS().GetMedalBattleData();
    m_kStrategyTransport.m_iMissionID = kMission.m_iID;
    m_kStrategyTransport.m_kRecapSaveData = m_kRecapSaveData;
    m_kStrategyTransport.m_kBattleDesc.m_strMapCommand = class'XComMapManager'.static.GetMapCommandLine(m_kStrategyTransport.m_kBattleDesc.m_strMapName, true, true, m_kStrategyTransport.m_kBattleDesc);

    if (kMission.m_iMissionType == eMission_CovertOpsExtraction || kMission.m_iMissionType == eMission_CaptureAndHold)
    {
        // DebugMode:False
        assert(EXALT().IsOperativeInField());
        kSkyranger.m_kCovertOperative = EXALT().GetOperative();
    }

    kSkyranger.BuildTransferData();

    UIMgr = PRES().GetUIMgr();

    if (UIMgr != none)
    {
        m_kStrategyTransport.m_kTutorialSaveData = UIMgr.TutorialSaveData;
    }

    m_kStrategyTransport.m_kBattleDesc.m_kDropShipCargoInfo.m_kNarrative = m_kNarrative;
    m_kStrategyTransport.m_kBattleDesc.m_arrSecondWave = m_arrSecondWave;
    m_kStrategyTransport.m_kBattleDesc.m_kDropShipCargoInfo.m_bNeedOutsider = false;
    m_kStrategyTransport.m_kBattleDesc.m_kDropShipCargoInfo.m_bNeedAlien = OBJECTIVES().m_eObjective == eObj_CaptureAlien;
    m_kStrategyTransport.m_kBattleDesc.m_kDropShipCargoInfo.m_bAlienDiedByExplosive = false;

    // Added for Highlander: transfer our techs in a different format
    PopulateDropshipTechHistory(Highlander_XGBattleDesc(m_kStrategyTransport.m_kBattleDesc));
    Content = m_kStrategyTransport.m_kBattleDesc.DeterminePawnContent();

    if (ISCONTROLLED() && Game().GetNumMissionsTaken() < 1)
    {
        Content.arrAlienPawns.AddItem(class'XGGameData'.static.MapCharacterToPawn(eChar_Sectoid));
    }

    if (Content.arrCivilianPawns.Length > 0)
    {
        m_kStrategyTransport.m_kBattleDesc.m_kCivilianInfo = Content.arrCivilianPawns[0];
    }

    XComOnlineEventMgr(GameEngine(class'Engine'.static.GetEngine()).OnlineEventManager).SaveToStoredStrategy();
    XComOnlineEventMgr(GameEngine(class'Engine'.static.GetEngine()).OnlineEventManager).SaveTransport();
    `CONTENTMGR.GetContentForMap(m_kStrategyTransport.m_kBattleDesc.m_strMapName, Content);
    `CONTENTMGR.RequestContent(Content, m_kStrategyTransport.m_kBattleDesc.m_iMissionType != eMission_Final);

    foreach kSkyranger.m_arrSoldiers(kSoldier)
    {
        if (kSoldier.m_kPawn != none)
        {
            kSoldier.m_kPawn.ForceBoostTextures();
        }
    }

    if (`HQPRES.m_kMissionAudioMgr == none)
    {
        DropshipAudioManager = new (`HQPRES) class'XComDropshipAudioMgr';
        `HQPRES.m_kMissionAudioMgr = DropshipAudioManager;
    }
    else
    {
        DropshipAudioManager = `HQPRES.m_kMissionAudioMgr;
    }

    if (m_kStrategyTransport.m_kBattleDesc.m_bIsTutorial && m_kStrategyTransport.m_kBattleDesc.m_bDisableSoldierChatter)
    {
        DropshipAudioManager.PreloadFirstMissionNarrative();
    }
    else
    {
        DropshipAudioManager.BeginDropshipNarrativeMoments(kMission, EMissionType(kMission.m_iMissionType), ECountry(kMission.m_iCountry));
    }

    SetTimer(0.10, false, 'DeferredLaunchCommand');
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

protected function PopulateDropshipTechHistory(Highlander_XGBattleDesc kBattleDesc)
{
    local int iTechId;
    local Highlander_XGDropshipCargoInfo kCargo;
    local Highlander_XGFacility_Labs kLabs;
    local HL_TTech kTech;

    kCargo = Highlander_XGDropshipCargoInfo(kBattleDesc.m_kDropShipCargoInfo);
    kLabs = `HL_LABS;

    if (kCargo == none)
    {
        `HL_LOG_CLS("ERROR: did not find Highlander_XGDropshipCargoInfo in the XGBattleDesc. This battle will not work properly!");
        return;
    }

    foreach kLabs.m_arrResearched(iTechId)
    {
        kTech = `HL_TECH(iTechId);

        // Clear out unneeded content from each tech so we don't use memory unnecessarily during the tac game
        kTech.strName = "";
        kTech.strSummary = "";
        kTech.strReport = "";
        kTech.strCustom = "";
        kTech.strCodename = "";
        kTech.ImagePath = "";

        kCargo.m_arrHLTechHistory.AddItem(kTech);
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