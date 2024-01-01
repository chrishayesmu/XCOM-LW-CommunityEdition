class LWCE_XGStrategy extends XGStrategy;

struct CheckpointRecord_LWCE_XGStrategy extends CheckpointRecord
{
    var array<name> m_arrCEFoundryUnlocks;
};

var array<name> m_arrCEItemUnlocks;
var array<name> m_arrCEFacilityUnlocks;
var array<name> m_arrCEFoundryUnlocks;

function NewGame()
{
    if (class'Engine'.static.GetCurrentWorldInfo().Game.BaseMutator != none)
    {
        `WORLDINFO.Game.BaseMutator.Mutate("XGStrategy.NewGame", `WORLDINFO.GetALocalPlayerController());
    }

    ValidateNewGameState();

    m_kWorld = Spawn(class'LWCE_XGWorld');
    m_kGeoscape = Spawn(class'LWCE_XGGeoscape');
    m_kHQ = Spawn(class'LWCE_XGHeadQuarters');
    m_kAI = Spawn(class'LWCE_XGStrategyAI');
    m_kRecapSaveData = Spawn(class'LWCE_XGRecapSaveData');
    m_kExaltSimulation = Spawn(class'LWCE_XGExaltSimulation');

    // For Dynamic War: sets the counter for each of these mission types to already be partly populated, so they
    // don't all spawn at once and there's some control over which missions occur when at the start of the game.
    m_arrMissionTotals.Add(41);
    m_arrMissionTotals[30] = int(class'XGTacticalGameCore'.default.SW_ELERIUM_LOSS * 0.20); // Research
    m_arrMissionTotals[31] = int(class'XGTacticalGameCore'.default.SW_ELERIUM_LOSS * 0.70); // Scout
    m_arrMissionTotals[32] = int(class'XGTacticalGameCore'.default.SW_ELERIUM_LOSS * 0.40); // Harvest
    m_arrMissionTotals[35] = int(class'XGTacticalGameCore'.default.SW_ELERIUM_LOSS * 0.70); // Abduction
    m_arrMissionTotals[36] = int(class'XGTacticalGameCore'.default.SW_ELERIUM_LOSS * 0.50); // Terror

    m_kNarrative = Spawn(class'LWCE_XGNarrative');
    m_kNarrative.InitNarrative(XComHeadquartersGame(WorldInfo.Game).m_bSuppressFirstTimeNarrative);

    m_arrItemUnlocks.Add(255);
    m_arrGeneModUnlocks.Add(11);
    m_arrSecondWave.Add(36);

    Init(false);
    GotoState('Initing');
}

function Init(bool bLoadingFromSave)
{
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

    class'LWCEEventListenerTemplateManager'.static.RegisterStrategyListeners();

    // EVENT: StrategyGameStart
    //
    // TODO: document
    `LWCE_EVENT_MGR.TriggerEvent('StrategyGameStart');
}

function BeginCombat(XGMission kMission)
{
    local int iMissionNum;
    local UIFxsMovieMgr UIMgr;
    local XGShip_Dropship kSkyranger;
    local TPawnContent Content;
    local XComDropshipAudioMgr DropshipAudioManager;
    local XGStrategySoldier kSoldier;

    iMissionNum = STAT_GetStat(eRecap_Missions) + 1;
    kSkyranger = kMission.GetAssignedSkyranger();

    if (kMission.m_iMissionType == eMission_AlienBase)
    {
        // ABAs have their squad rerolled when the mission is launched; all other types use the squad generated when the mission is
        // created. This is because an ABA can be on the Geoscape for an arbitrarily long time, and the original squad might be very
        // outdated by the time the player finally launches.
        kMission.m_kDesc.m_kAlienSquad = AI().DetermineAlienBaseSquad();
        LWCE_XGStorage(STORAGE()).LWCE_RemoveItem('Item_SkeletonKey');
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

    // LWCE issue #60: append the mission number to the op name, which will make it appear anywhere the op is referenced (loading screen, mission debriefing, morgue, etc).
    // Also provide the current Geoscape date for display during the mission. We do this in BeginCombat so that it's definitely accurate, versus doing it when the
    // mission spawns or when the Skyranger first takes flight.
    m_kStrategyTransport.m_kBattleDesc.m_strOpName @= "(#" $ iMissionNum $ ")";
    LWCE_XGBattleDesc(m_kStrategyTransport.m_kBattleDesc).m_strDate = GEOSCAPE().m_kDateTime.GetDateString();

    if (kMission.m_iMissionType == eMission_CovertOpsExtraction || kMission.m_iMissionType == eMission_CaptureAndHold)
    {
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

    // Added for LWCE: transfer our techs in a different format
    PopulateDropshipTechHistory(LWCE_XGBattleDesc(m_kStrategyTransport.m_kBattleDesc));
    Content = m_kStrategyTransport.m_kBattleDesc.DeterminePawnContent();

    if (Content.arrCivilianPawns.Length > 0)
    {
        m_kStrategyTransport.m_kBattleDesc.m_kCivilianInfo = Content.arrCivilianPawns[0];
    }

    `ONLINEEVENTMGR.SaveToStoredStrategy();
    `ONLINEEVENTMGR.SaveTransport();
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

function int GetAct()
{
    if (LWCE_XGStorage(STORAGE()).LWCE_EverHadItem('Item_HyperwaveBeacon'))
    {
        return 3;
    }
    else if (LABS().HasInterrogatedCaptive())
    {
        return 2;
    }
    else
    {
        return 1;
    }
}

function PostLoadSaveGame()
{
    // The original version of this has some unnecessary debug code using deprecated functions;
    // we just replace it with nothing
}

function bool UnlockFacility(EFacilityType eFacility, out TItemUnlock kUnlock)
{
    `LWCE_LOG_DEPRECATED_CLS(UnlockFacility);

    return false;
}

function bool LWCE_UnlockFacility(name FacilityName, out LWCE_TItemUnlock kUnlock)
{
    local LWCEFacilityTemplate kFacility;

    if (m_arrCEFacilityUnlocks.Find(FacilityName) != INDEX_NONE || LWCE_XGHeadquarters(HQ()).LWCE_HasFacility(FacilityName))
    {
        return false;
    }

    kFacility = `LWCE_FACILITY(FacilityName);

    kUnlock.bFacility = true;
    kUnlock.sndFanfare = SNDLIB().SFX_Unlock_Facility;

    kUnlock.ImagePath = kFacility.ImagePath;
    kUnlock.strName = kFacility.strName;
    kUnlock.strDescription = kFacility.strBriefSummary;
    kUnlock.strTitle = m_strNewFacilityAvailable;

    if (kFacility.kCost.iCash != -1)
    {
        kUnlock.strHelp = m_strNewFacilityHelp;
    }

    m_arrCEFacilityUnlocks.AddItem(FacilityName);

    ENGINEERING().m_bCanBuildFacilities = true;
    ENGINEERING().SetDisabled(false);

    return true;
}

function bool UnlockFoundryProject(EFoundryTech eProject, out TItemUnlock kUnlock)
{
    `LWCE_LOG_DEPRECATED_CLS(UnlockFoundryProject);

    return false;
}

function bool LWCE_UnlockFoundryProject(name ProjectName, out LWCE_TItemUnlock kUnlock)
{
    local LWCEFoundryProjectTemplate kTemplate;

    if (m_arrCEFoundryUnlocks.Find(ProjectName) != INDEX_NONE)
    {
        return false;
    }

    kTemplate = `LWCE_FOUNDRY_PROJECT(ProjectName);

    kUnlock.bFoundryProject = true;
    kUnlock.sndFanfare = SNDLIB().SFX_Unlock_Foundry;

    kUnlock.ImagePath = kTemplate.ImagePath;
    kUnlock.strName = kTemplate.strName;
    kUnlock.strDescription = kTemplate.strSummary;
    kUnlock.strTitle = m_strNewFoundryAvailable;
    kUnlock.strHelp = m_strNewFoundryHelp;

    m_arrCEFoundryUnlocks.AddItem(ProjectName);

    return true;
}

function bool UnlockItem(EItemType eItem, out TItemUnlock kUnlock)
{
    `LWCE_LOG_DEPRECATED_CLS(UnlockItem);

    return false;
}

function bool LWCE_UnlockItem(name ItemName, out LWCE_TItemUnlock kUnlock)
{
    local LWCEItemTemplate kItem;

    if (m_arrCEItemUnlocks.Find(ItemName) != INDEX_NONE)
    {
        return false;
    }

    kItem = `LWCE_ITEM(ItemName);
    kUnlock.sndFanfare = SNDLIB().SFX_Unlock_Item;

    kUnlock.ImagePath = kItem.ImagePath;
    kUnlock.strName = kItem.strName;
    kUnlock.strDescription = kItem.strBriefSummary;
    kUnlock.strTitle = m_strNewItemAvailable;
    kUnlock.strHelp = m_strNewItemHelp;

    m_arrCEItemUnlocks.AddItem(ItemName);

    ENGINEERING().m_bCanBuildItems = true;
    ENGINEERING().SetDisabled(false);

    return true;
}

function PlayFinalCinematic()
{
    local XComNarrativeMoment lMoment;

    if (LWCE_XGStrategySoldier(BARRACKS().m_kVolunteer).m_kCESoldier.kAppearance.nmGender == 'Female')
    {
        lMoment = `XComNarrativeMoment("TP13_TheEnd_Female");
    }
    else
    {
        lMoment = `XComNarrativeMoment("TP13_TheEnd");
    }

    if (!PRES().UINarrative(lMoment,, PostFinalCinematic, SendSoldierToFinalCinematic))
    {
        PostFinalCinematic();
    }
}

protected function PopulateDropshipTechHistory(LWCE_XGBattleDesc kBattleDesc)
{
    local name TechName;
    local LWCE_XGDropshipCargoInfo kCargo;

    kCargo = LWCE_XGDropshipCargoInfo(kBattleDesc.m_kDropShipCargoInfo);

    if (kCargo == none)
    {
        `LWCE_LOG_CLS("ERROR: did not find LWCE_XGDropshipCargoInfo in the XGBattleDesc. This battle will not work properly!");
        return;
    }

    foreach `LWCE_LABS.m_arrCEResearched(TechName)
    {
        kCargo.m_arrCETechHistory.AddItem(TechName);
    }

    foreach `LWCE_ENGINEERING.m_arrCEFoundryHistory(TechName)
    {
        kCargo.m_arrCEFoundryHistory.AddItem(TechName);
    }
}

protected function ValidateNewGameState()
{
    local bool bAnyInvalid;

    bAnyInvalid = false;

    if (m_kWorld != none)
    {
        `LWCE_LOG_CLS("WARNING: m_kWorld is already set. Its class is " $ string(m_kWorld.Class));
        bAnyInvalid = true;
    }

    if (m_kGeoscape != none)
    {
        `LWCE_LOG_CLS("WARNING: m_kGeoscape is already set. Its class is " $ string(m_kGeoscape.Class));
        bAnyInvalid = true;
    }

    if (m_kHQ != none)
    {
        `LWCE_LOG_CLS("WARNING: m_kHQ is already set. Its class is " $ string(m_kHQ.Class));
        bAnyInvalid = true;
    }

    if (m_kAI != none)
    {
        `LWCE_LOG_CLS("WARNING: m_kAI is already set. Its class is " $ string(m_kAI.Class));
        bAnyInvalid = true;
    }

    if (m_kRecapSaveData != none)
    {
        `LWCE_LOG_CLS("WARNING: m_kRecapSaveData is already set. Its class is " $ string(m_kRecapSaveData.Class));
        bAnyInvalid = true;
    }

    if (m_kExaltSimulation != none)
    {
        `LWCE_LOG_CLS("WARNING: m_kExaltSimulation is already set. Its class is " $ string(m_kExaltSimulation.Class));
        bAnyInvalid = true;
    }

    if (m_kNarrative != none)
    {
        `LWCE_LOG_CLS("WARNING: m_kNarrative is already set. Its class is " $ string(m_kNarrative.Class));
        bAnyInvalid = true;
    }

    if (bAnyInvalid)
    {
        `LWCE_LOG_CLS("Any XGStrategy member which is already set will be overridden by LWCE. This was most likely done by a mutator-based mod, and that mod will not function properly.");
    }
}

state StartingNewGame
{
Begin:
    CheckForSecondWave();
    m_kHQ.InitNewGame();
    m_kGeoscape.InitNewGame();
    m_kWorld.StartGame();
    m_kAI.InitNewGame();
    `PROFILESETTINGS.Data.IncGamesPlayed();

    if (m_bDebugStart)
    {
        DebugStuff();
    }

    if (!m_bControlledStart && !m_bDebugStart)
    {
        Sleep(0.10);
        GEOSCAPE().PreloadSquadIntoSkyranger(eGA_Abduction, false);

        while (AreDropshipSoldiersStillLoading())
        {
            Sleep(0.10);
        }

        // Following block is in the base class, but IsAsyncLoadingWrapper appears to be a no-op,
        // so we omit it in LWCE
        /*
        while (IsAsyncLoadingWrapper())
        {
            Sleep(0.10);
        }
        */
    }

    while (PRES().IsBusy())
    {
        Sleep(0.0);
    }

    `ONLINEEVENTMGR.ResetAchievementState();

    // EVENT: OnNewCampaignStarted
    //
    // SUMMARY: Triggered at the start of a new campaign. At this point, the default base has been set up,
    //          with the facilities, items, etc that are common to all campaigns. Bonuses specific to a starting
    //          country or continent, or due to Second Wave bonuses, are *not* set up yet; they are applied in response
    //          to the OnNewCampaignStarted event, much like mods. This event occurs prior to the intro mission beginning.
    //
    // DATA: LWCE_XGStrategy
    //
    // SOURCE: LWCE_XGStrategy
    `LWCE_EVENT_MGR.TriggerEvent('OnNewCampaignStarted', self, self);

    if (m_bDebugStart)
    {
        GoToHQ();
    }
    else if (m_bControlledStart)
    {
        m_kSetupPhaseManager = Spawn(class'XGSetupPhaseManager', self);
        m_kSetupPhaseManager.StartNewGame();
    }
    else if (m_bTutorial)
    {
        GoToTutorial();
    }
    else
    {
        GEOSCAPE().TakeFirstMission();
    }

    stop;
}