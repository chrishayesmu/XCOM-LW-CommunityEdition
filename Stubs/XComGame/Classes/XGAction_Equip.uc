class XGAction_Equip extends XGAction
    notplaceable
    hidecategories(Navigation);

var XGInventoryNativeBase.ELocation m_eSlot;
var XGWeapon kWeapon;

replication
{
    if(bNetInitial && Role == ROLE_Authority)
        m_eSlot;
}

simulated function bool InternalIsInitialReplicationComplete(){}
simulated function ELocation GetEquipSlot(){}
function bool Init(XGUnit kUnit, ELocation eEquipFromSlot){}
function bool CanBePerformed(){}
simulated function name GetAnimationToPlay(){}
simulated function InternalCompleteAction(){}

simulated state Executing
{
}