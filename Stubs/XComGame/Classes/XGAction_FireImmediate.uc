class XGAction_FireImmediate extends XGAction_Fire
    notplaceable
    hidecategories(Navigation);
//complete stub

simulated function bool InternalIsInitialReplicationComplete()
{}
simulated function bool CanBePerformed()
{
    return true;
}

function SetShotImmediately(XGAbility_Targeted kShot)
{
}

simulated state Executing
{
    ignores Tick;

    simulated event BeginState(name P)
    {
    }

    simulated function SetupCamera()
    { }
 
}