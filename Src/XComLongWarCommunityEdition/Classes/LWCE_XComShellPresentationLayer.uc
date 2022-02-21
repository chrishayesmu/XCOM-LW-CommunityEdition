class LWCE_XComShellPresentationLayer extends XComShellPresentationLayer;

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