class XGAction_Unequip extends XGAction
    notplaceable
    hidecategories(Navigation);

var ELocation m_eSlot;

replication
{
    if(bNetInitial && Role == ROLE_Authority)
        m_eSlot;
}

simulated function bool InternalIsInitialReplicationComplete(){}
function bool Init(XGUnit kUnit){}
function bool CanBePerformed(){}
simulated function name GetAnimationToPlay(){}
simulated state Executing
{
}