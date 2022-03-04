class LWCE_XComShellPresentationLayer extends XComShellPresentationLayer;

`include(generators.uci)

`LWCE_GENERATOR_XCOMPRESENTATIONLAYERBASE

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