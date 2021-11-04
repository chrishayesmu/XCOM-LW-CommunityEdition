class XGAIBehavior_Directed extends XGAIBehavior
    notplaceable
    hidecategories(Navigation);
//complete stub

struct CheckpointRecord_XGAIBehavior_Directed extends CheckpointRecord
{
    var XComDirectedTacticalExperience m_kDirectedExperience;
};

var XComDirectedTacticalExperience m_kDirectedExperience;

simulated function bool ShouldDrawProximityRing()
{
    return false;
}

simulated function bool IsBehaviorDefined()
{
    return true;
}

simulated function SetDefaultBehavior()
{
    m_eSpawnBehavior = 0;
}

simulated function InitTurn();

simulated function OnMoveComplete()
{
    super.OnMoveComplete();
}

simulated function SetDTE(XComDirectedTacticalExperience kDTE)
{
    m_kDirectedExperience = kDTE;
}

simulated function ForceMove(Vector vDest, optional bool bEndTurnAfterMove, optional bool bDebugDisplayDest)
{
    bEndTurnAfterMove = true;
    bDebugDisplayDest = false;
    super.ForceMove(vDest, bEndTurnAfterMove, bDebugDisplayDest);
    GotoState('ForceMoveTo');
}

state ExecutingAI
{}