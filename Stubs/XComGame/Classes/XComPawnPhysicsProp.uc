class XComPawnPhysicsProp extends XComSkeletalMeshActor;
//complete stub

var private XComAnimNodeBlendByMovementType BlendByMovement;
var private AnimNodeSequence FinishAnimNodeSequence;
var private Vector LastHeadBoneLocation;
var private Vector CurrentHeadBoneLocation;

function bool ShouldSaveForCheckpoint(){}


auto state Dormant{}
simulated state AnimatingCorpse
{
    event BeginState(name P){}
    simulated function DoRagdoll(){}
    simulated function FinishRagDoll(){}
    event Tick(float DeltaTime){}
}