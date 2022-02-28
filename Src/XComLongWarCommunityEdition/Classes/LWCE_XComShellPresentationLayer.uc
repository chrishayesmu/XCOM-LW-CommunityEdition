class LWCE_XComShellPresentationLayer extends XComShellPresentationLayer;

simulated function EnterMainMenu()
{
    if (ShouldShowDevShell())
    {
        UIShellScreen();
    }
    else
    {
        UIFinalShellScreen();
    }
}

private function bool ShouldShowDevShell()
{
    return false; // TODO: make this configurable
}

// ----------------------------------------------------------------------------------
// NOTE: states past this point are from XComPresentationLayerBase, and need to be modified here,
// in LWCE_XComPresentationLayer, and in LWCE_XComHQPresentationLayer together!
// ----------------------------------------------------------------------------------

simulated state State_PCKeybindings
{
    simulated function Activate()
    {
        m_kPCKeybindings = Spawn(class'LWCE_UIKeybindingsPCScreen', self);
        m_kPCKeybindings.Init(XComPlayerController(Owner), GetHUD());
    }
}