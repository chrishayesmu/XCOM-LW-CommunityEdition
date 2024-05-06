class XComPawnPhysicsProp extends XComSkeletalMeshActor
    hidecategories(Navigation);

var private XComAnimNodeBlendByMovementType BlendByMovement;
var private AnimNodeSequence FinishAnimNodeSequence;
var private Vector LastHeadBoneLocation;
var private Vector CurrentHeadBoneLocation;

defaultproperties
{
    TickGroup=TG_PostAsyncWork
    bNoDelete=false
}