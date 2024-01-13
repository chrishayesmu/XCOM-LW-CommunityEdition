class LWCE_XComPresentationLayer extends XComPresentationLayer;

`include(generators_presentationlayer.uci)

simulated function PHUDLevelUp(XGCharacter_Soldier kSoldier)
{
    local LWCE_XGCharacter_Soldier kCESoldier;
    local string Message;

    kCESoldier = LWCE_XGCharacter_Soldier(kSoldier);

    Message = Repl(m_sLevelUp, "%sRANK", `GAMECORE.GetRankString(kCESoldier.m_kCESoldier.iRank));
    ReplaceText(Message, "%sNAME", kCESoldier.m_kCESoldier.strLastName);
    GetMessenger().Message(Message, 5, 1, 5.0);
    kCESoldier.m_kUnit.SetTimer(3.0, false, 'DelayPromotionSound');
}

simulated function UIUnitGermanMode(XGUnit TargetUnit)
{
    m_kGermanMode = Spawn(class'LWCE_UIUnitGermanMode', self);
    m_kGermanMode.Init(XComPlayerController(Owner), GetHUD(), TargetUnit);
    PushState('State_GermanMode');
}

simulated state State_AbilityHUD
{
    simulated function Activate()
    {
        m_kTacticalHUD = Spawn(class'LWCE_UITacticalHUD', self);
        m_kTacticalHUD.Init(XComTacticalController(Owner), GetHUD());
        GetHUD().LoadScreen(m_kTacticalHUD);

        if (WorldInfo.NetMode != NM_Standalone)
        {
            m_kMultiplayerHUD = Spawn(class'UIMultiplayerHUD', self);
            m_kMultiplayerHUD.Init(XComTacticalController(Owner), GetHUD());
            GetHUD().LoadScreen(m_kMultiplayerHUD);

            if (!WorldInfo.IsConsoleBuild())
            {
                m_kMultiplayerChatManager = Spawn(class'UIMultiplayerChatManager', self);
                m_kMultiplayerChatManager.Init(XComTacticalController(Owner), GetModalHUD());
                GetModalHUD().LoadScreen(m_kMultiplayerChatManager);
            }
        }
    }
}

simulated state State_FlagMgr
{
    simulated function Activate()
    {
        m_kUnitFlagManager = Spawn(class'LWCE_UIUnitFlagManager', self);
        m_kUnitFlagManager.Init(XComTacticalController(Owner), GetHUD());
        GetHUD().LoadScreen(m_kUnitFlagManager);
    }
}

simulated state State_MissionSummary
{
    simulated function Activate()
    {
        local XComWorldData WorldData;

        if (m_kProtoUI != none)
        {
            m_kProtoUI.Hide();
        }

        if (m_kTacticalHUD != none)
        {
            m_kTacticalHUD.Hide();
        }

        m_kMissionSummary = Spawn(class'LWCE_UIMissionSummary', self);
        m_kMissionSummary.Init(XComPlayerController(Owner), GetHUD());
        GetHUD().LoadScreen(m_kMissionSummary);

        m_kActionIconManager.ShowIcons(false);
        WorldData = class'XComWorldData'.static.GetWorldData();

        if (WorldData != none && WorldData.Volume != none)
        {
            WorldData.Volume.BorderComponent.SetCustomHidden(true);
            WorldData.Volume.BorderComponentDashing.SetCustomHidden(true);
        }
    }
}

simulated state State_PauseMenu
{
    simulated function Activate()
    {
        local bool bAllowSaving;

        bAllowSaving = AllowSaving();
        ToggleUIWhenPaused(false);
        m_kPauseMenu = Spawn(class'LWCE_UIPauseMenu', self);
        m_kPauseMenu.Init(XComPlayerController(Owner), GetHUD(), m_bIsIronman, bAllowSaving);
    }
}

simulated state State_SightlineHUD
{
    simulated function Activate()
    {
        m_kSightlineHUD = Spawn(class'LWCE_UISightlineHUD', self);
        m_kSightlineHUD.Init(XComTacticalController(Owner), GetHUD());
        GetHUD().LoadScreen(m_kSightlineHUD);
    }
}