class LWCE_XComShellController extends XComShellController;

function InitInputSystem()
{
    super.InitInputSystem();

    class'LWCE_UIKeybindingsPCScreen'.static.ApplyCustomKeybinds(PlayerInput);
}

defaultproperties
{
    m_kPresentationLayerClass=class'LWCE_XComShellPresentationLayer'
    CheatClass=class'LWCE_XComShellCheatManager'
}