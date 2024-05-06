class XComLocomotionUnitPawn extends XComUnitPawnNativeBase
    native(Unit)
    config(Game)
    hidecategories(Navigation);

var bool bWeaponIsDown;
var Vector LastLocation_WeaponDownCheck;
var Rotator LastRotation_WeaponDownCheck;

defaultproperties
{
    bRunPhysicsWithNoController=true
    bReplicateMovement=false
    m_bReplicateCollisionData=false
}