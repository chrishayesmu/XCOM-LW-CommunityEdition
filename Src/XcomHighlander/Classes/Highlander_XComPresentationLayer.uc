class Highlander_XComPresentationLayer extends XComPresentationLayer;

simulated state State_AbilityHUD
{
    simulated function Activate()
    {
        m_kTacticalHUD = Spawn(class'Highlander_UITacticalHUD', self);
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

        m_kMissionSummary = Spawn(class'Highlander_UIMissionSummary', self);
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
        m_kPauseMenu = Spawn(class'Highlander_UIPauseMenu', self);
        m_kPauseMenu.Init(XComPlayerController(Owner), GetHUD(), m_bIsIronman, bAllowSaving);
    }
}

// ----------------------------------------------------------------------------------
// NOTE: states past this point are from XComPresentationLayerBase, and need to be modified here,
// in Highlander_XComShellPresentationLayer, and in Highlander_XComHQPresentationLayer together!
// ----------------------------------------------------------------------------------

simulated state State_PCKeybindings
{
    simulated function Activate()
    {
        m_kPCKeybindings = Spawn(class'Highlander_UIKeybindingsPCScreen', self);
        m_kPCKeybindings.Init(XComPlayerController(Owner), GetHUD());
    }
}
