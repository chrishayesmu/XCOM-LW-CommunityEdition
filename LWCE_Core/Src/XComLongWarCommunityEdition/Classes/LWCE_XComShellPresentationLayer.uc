class LWCE_XComShellPresentationLayer extends XComShellPresentationLayer
    config(LWCEQualityOfLife);

var config bool bShowDebugShellScreen;

`include(generators_presentationlayer.uci)

simulated function EnterMainMenu()
{
    if (bShowDebugShellScreen)
    {
        UIShellScreen();
    }
    else
    {
        UIFinalShellScreen();
    }
}

simulated state State_FinalShell
{
    simulated function Activate()
    {
        m_kFinalShellScreen = Spawn(class'LWCE_UIFinalShell', self);
        m_kFinalShellScreen.Init(XComShellController(Owner), GetHUD());
        GetHUD().LoadScreen(m_kFinalShellScreen);
    }
}