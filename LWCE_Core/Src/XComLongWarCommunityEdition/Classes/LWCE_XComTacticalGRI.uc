class LWCE_XComTacticalGRI extends XComTacticalGRI;

var privatewrite LWCEVisualizationManager m_kVisMgr;

simulated function StartMatch()
{
    super(GameReplicationInfo).StartMatch();
    m_CharacterGen = Spawn(class'LWCE_XGCharacterGenerator');
    mSimpleShapeManager = Spawn(class'SimpleShapeManager');
    m_kTraceMgr = Spawn(class'XComTraceManager');

    if (Role == ROLE_Authority)
    {
        m_kPrecomputedPath = Spawn(class'LWCE_XComPrecomputedPath');
    }

    `LWCE_LOG_CLS("(LWCE override) StartMatch");

    InitBattle();
}

function InitBattle() {
    local XGPlayer NewPlayer;
    local XComTacticalController kLocalPC;
    local StrategyGameTransport kTransport;
    local bool bStandardLoad;
    local XComOnlineEventMgr OnlineEventMgr;
    local XComOnlineProfileSettings ProfileSettings;
    local TPawnContent Content;
    local XComMapMetaData kMapData;

    local XComEngine kEngine;
    kEngine = XComEngine(class'Engine'.static.GetEngine());

    OnlineEventMgr = XComOnlineEventMgr(kEngine.OnlineEventManager);
    ProfileSettings = XComOnlineProfileSettings(kEngine.GetProfileSettings());
    bStandardLoad = OnlineEventMgr.bPerformingStandardLoad;

    if (bStandardLoad)
    {
        OnlineEventMgr.FinishLoadGame();
        foreach AllActors(class'XGBattle', m_kBattle)
        {
            break;
        }

        if (m_kBattle.m_kDesc != none && WorldInfo.NetMode == NM_Standalone)
        {
            Content = m_kBattle.m_kDesc.DeterminePawnContent();
            XComContentManager(kEngine.GetContentManager()).RequestContent(Content, true);
            XComContentManager(kEngine.GetContentManager()).RequestContentForCheckpoint(OnlineEventMgr.CurrentTacticalCheckpoint);
            PostLoad_LoadRequiredContent(XComContentManager(kEngine.GetContentManager()));
        }

        m_kBattle.PostLoad();
    }
    else
    {
        kMapData = class'XComMapManager'.static.GetCurrentMapMetaData();

        if (kMapData.MissionType == eMission_CaptureAndHold)
        {
            m_kBattle = Spawn(class'LWCE_XGBattle_SPCaptureAndHold');
        }
        else if (kMapData.MissionType == eMission_CovertOpsExtraction)
        {
            m_kBattle = Spawn(class'LWCE_XGBattle_SPCovertOpsExtraction');
        }
        else if (XComTacticalGame(WorldInfo.Game).bDebugCombatRequested)
        {
            m_kBattle = Spawn(class'LWCE_XGBattle_SPDebug');
        }
        else
        {
            m_kBattle = Spawn(class'LWCE_XGBattle_SPAssault');
        }

        foreach WorldInfo.AllControllers(class'XComTacticalController', kLocalPC)
        {
            if (kLocalPC.Player != none)
            {
                break;
            }
        }

        if (ProfileSettings == none)
        {
            kEngine.CreateProfileSettings();
            ProfileSettings = XComOnlineProfileSettings(kEngine.GetProfileSettings());
            ProfileSettings.ExtendedLaunch_InitToDefaults();
            class'XComOnlineEventMgr'.static.EnumGamepads_PC();

            if (class'XComOnlineEventMgr'.static.GamepadConnected_PC())
            {
                ProfileSettings.Data.ActivateMouse(false);
            }
        }

        NewPlayer = Spawn(m_kPlayerClass, kLocalPC);
        NewPlayer.Init();
        NewPlayer.SetPlayerController(kLocalPC);
        kLocalPC.SetXGPlayer(NewPlayer);
        kLocalPC.SetTeamType(NewPlayer.m_eTeam);
        m_kBattle.AddPlayer(NewPlayer);

        NewPlayer = Spawn(class'LWCE_XGAIPlayer');
        NewPlayer.Init();
        m_kBattle.AddPlayer(NewPlayer);

        NewPlayer = Spawn(class'LWCE_XGAIPlayer_Animal');
        NewPlayer.Init();
        m_kBattle.AddPlayer(NewPlayer);

        if (XComTacticalGame(WorldInfo.Game).m_bLoadingFromShell)
        {
            m_kProfileSettings = ProfileSettings;
            m_kBattle.SetProfileSettings();
            m_kBattle.Start();
            class'XComEngine'.static.SetRandomSeeds(class'XComEngine'.static.GetARandomSeed());
            `PRES.CreateTutorialSave();
        }
        else
        {
            m_kBattle.SetProfileSettings();
            OnlineEventMgr.LoadTransport();

            foreach AllActors(class'StrategyGameTransport', kTransport)
            {
                m_kBattle.m_kTransferSave = kTransport;
                m_kBattle.m_kTransferSave.m_kBattleDesc.InitHumanLoadoutInfosFromDropshipCargoInfo();
                m_kBattle.m_kDesc = kTransport.m_kBattleDesc;

                `PRES.GetUIMgr().TutorialSaveData = kTransport.m_kTutorialSaveData;

                m_kBattle.Start();

                class'XComEngine'.static.SetRandomSeeds(class'XComEngine'.static.GetARandomSeed());

                break;
            }
        }
    }

    `LWCE_LOG_CLS("(LWCE override) InitBattle");
}

simulated function ReceivedGameClass()
{
    super(GameReplicationInfo).ReceivedGameClass();

    if (m_kGameCore == none)
    {
        m_kGameCore = Spawn(class'LWCE_XGTacticalGameCore', self);
        m_kGameCore.Init();
    }

    if (m_kPerkTree == none)
    {
        m_kPerkTree = Spawn(class'LWCE_XComPerkManager', self);
        m_kPerkTree.Init();
    }

    if (m_kCameraManager == none)
    {
        m_kCameraManager = Spawn(class'LWCE_XComCameraManager', self);
        m_kCameraManager.Init();
    }

    if (m_kVisMgr == none)
    {
        m_kVisMgr = Spawn(class'LWCEVisualizationManager', self);
    }

    class'LWCEEventListenerTemplateManager'.static.RegisterTacticalListeners();
}

defaultproperties
{
    m_kPlayerClass=class'LWCE_XGPlayer'
}
