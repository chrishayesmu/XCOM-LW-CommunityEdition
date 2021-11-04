class XGAIBehavior_Survivor extends XGAIBehavior
    notplaceable
    hidecategories(Navigation);
//complete stub

simulated function SetDefaultBehavior()
{
    m_eSpawnBehavior = 0;
}

simulated function bool ShouldDrawProximityRing()
{
    return true;
}

simulated function bool IsBehaviorDefined()
{
    return true;
}

simulated function OnDeath(XGUnit kKiller);

simulated function InitTurn();

state ExecutingAI
{
Begin:
    GotoState('EndOfTurn');
    stop;        
}