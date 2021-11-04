class XGAbility_Grapple extends XGAbility_Targeted
    native(Core)
    notplaceable
    hidecategories(Navigation);
//complete stub

struct native InitialReplicationData_XGAbility_Grapple
{
    var XComPathingPawn m_kPathingPawn;

    structdefaultproperties
    {
        m_kPathingPawn=none
    }
};

var XComPathingPawn PathingPawn;
var Vector GrapplePoint;
var bool bIsValid;
var bool bHasSnappedToLowestFloor;
var bool m_bInitialReplicationDataReceived_XGAbility_Grapple;
var repnotify InitialReplicationData_XGAbility_Grapple m_kInitialReplicationData_XGAbility_Grapple;

replication
{
    if(bNetInitial && Role == ROLE_Authority)
        m_kInitialReplicationData_XGAbility_Grapple;
}

// Export UXGAbility_Grapple::execShotInit(FFrame&, void* const)
native function ShotInit(int iAbility, array<XGUnit> arrTargets, XGWeapon kWeapon, optional bool bReactionFire=false);
simulated function Reset(){}
simulated event ReplicatedEvent(name VarName){}
simulated function bool InternalIsInitialReplicationComplete(){}
simulated function ApplyEffect(){}
simulated function bool ShouldClimbOverLedge(){}
simulated function Vector GetLedgePoint(){}
simulated function Vector GetLedgeOffset(){}
simulated function Vector GetLedgeNormal(){}
final simulated function XCom3DCursor Get3DCursor(){}
simulated function ComputeGrapplePath(Vector Target){}
simulated function DrawGrapplePath(){}
simulated function Deselected(){}
