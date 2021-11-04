class XComCameraBase extends Camera
    abstract
    transient
    native
    config(Camera)
    hidecategories(Navigation);
//complete stub

function StartTactical(){}

auto simulated state Initing{}

simulated state InTransitionBetweenGames
{
    simulated event EndState(name NextStateName){}
    simulated function DumpPostProcessState(){}
    simulated function DisablePostProcessing(){}
    simulated function RestorePostProcessing(){}
    simulated function EnablePostProcessEffect(name EffectName, bool bEnable){}
}

simulated state TransitioningToStrategy extends InTransitionBetweenGames
{
    simulated function UpdateViewTarget(out TViewTarget OutVT, float DeltaTime){}
}
simulated state TransitioningToTactical extends InTransitionBetweenGames
{
    simulated function UpdateViewTarget(out TViewTarget OutVT, float DeltaTime){}
}

simulated state BootstrappingStrategy extends InTransitionBetweenGames
{
    simulated function UpdateViewTarget(out TViewTarget OutVT, float DeltaTime){}
}
simulated state BootstrappingTactical extends InTransitionBetweenGames
{
    simulated function UpdateViewTarget(out TViewTarget OutVT, float DeltaTime)
    {
    }
}

simulated state CinematicView
{
    simulated function UpdateViewTarget(out TViewTarget OutVT, float DeltaTime){}
    simulated event BeginState(name PrevStateName){}
    simulated event EndState(name N){}
}
