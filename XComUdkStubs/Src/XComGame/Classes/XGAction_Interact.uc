class XGAction_Interact extends XGAction
    native(Action)
    nativereplication
    notplaceable
    hidecategories(Navigation);

struct native InitialReplicationData_XGAction_Interact
{
    var XComInteractiveLevelActor m_kInteractor;
    var name m_nInteractSocketName;
};

var XComInteractiveLevelActor Interactor;
var name InteractSocketName;
var private repnotify repretry InitialReplicationData_XGAction_Interact m_kInitialReplicationData_XGAction_Interact;
var private bool m_bInitialReplicationDataReceived_XGAction_Interact;
var XGUnitNativeBase.ECoverState enumDesiredCoverState;
var XComWorldData.UnitPeekSide UsePeekSide;
var int iIterationCounter;
var int UseCoverDirection;

defaultproperties
{
    m_bBlocksInput=true
    m_bConstantCombat=true
    m_bShouldUpdateOvermind=true
}