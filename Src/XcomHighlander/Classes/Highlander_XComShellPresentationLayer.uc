class Highlander_XComShellPresentationLayer extends XComShellPresentationLayer;

// ----------------------------------------------------------------------------------
// NOTE: states past this point are from XComPresentationLayerBase, and need to be modified here,
// in Highlander_XComPresentationLayer, and in Highlander_XComHQPresentationLayer together!
// ----------------------------------------------------------------------------------

simulated state State_PCKeybindings
{
    simulated function Activate()
    {
        m_kPCKeybindings = Spawn(class'Highlander_UIKeybindingsPCScreen', self);
        m_kPCKeybindings.Init(XComPlayerController(Owner), GetHUD());
    }
}