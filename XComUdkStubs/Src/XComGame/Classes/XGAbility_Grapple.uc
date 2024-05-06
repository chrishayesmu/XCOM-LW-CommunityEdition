class XGAbility_Grapple extends XGAbility_Targeted
    native(Core)
    notplaceable
    hidecategories(Navigation);

struct native InitialReplicationData_XGAbility_Grapple
{
    var XComPathingPawn m_kPathingPawn;
};

var XComPathingPawn PathingPawn;
var Vector GrapplePoint;
var bool bIsValid;
var bool bHasSnappedToLowestFloor;
var private bool m_bInitialReplicationDataReceived_XGAbility_Grapple;
var private repnotify repretry InitialReplicationData_XGAbility_Grapple m_kInitialReplicationData_XGAbility_Grapple;