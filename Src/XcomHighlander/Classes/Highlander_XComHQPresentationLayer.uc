class Highlander_XComHQPresentationLayer extends XComHQPresentationLayer;

simulated function Init()
{
    `HL_LOG(string(Class) $ ": Init");
    super.Init();
}

simulated state State_HangarHiring
{
    simulated function Activate()
    {
        // Highlander: replace UIHiring_Hangar class for a bug fix
        m_kHangarHiring = Spawn(class'Highlander_UIHiring_Hangar', self);
        m_kHangarHiring.Init(XComPlayerController(Owner), GetHUD(), 4);
        GetHUD().LoadScreen(m_kHangarHiring);
    }

    simulated function Deactivate()
    {
        GetHUD().RemoveScreen(m_kHangarHiring);
        m_kHangarHiring = none;
    }

    simulated function OnReceiveFocus()
    {
        m_kHangarHiring.OnReceiveFocus();
    }

    simulated function OnLoseFocus()
    {
        m_kHangarHiring.OnLoseFocus();
    }

    stop;
}