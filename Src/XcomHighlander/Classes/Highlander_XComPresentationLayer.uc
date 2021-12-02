class Highlander_XComPresentationLayer extends XComPresentationLayer;

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