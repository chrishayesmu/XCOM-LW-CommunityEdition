class XComCable extends Actor
    native(Level)
    placeable
    hidecategories(Navigation);

var(Cable) const XComCablePoint PointA;
var(Cable) const XComCablePoint PointB;
var(Cable) const SkeletalMesh CableMesh;
var(Cable) name BoneAName;
var(Cable) name BoneBName;
var(Cable) name MidBoneName;
var(Cable) const float Droop;
var(Cable) const float SwayDistance;
var(Cable) const float SwaySpeed;
var(Cable) const float SwayOffset;
var(Cable) export editinline SkeletalMeshComponent CableMeshComponent;
var int AnimBoneIndex;
var int BoneAIndex;
var int BoneBIndex;
var float SwayTimer;

defaultproperties
{
    CableMesh=SkeletalMesh'EXT_PROP_Powerlines.Meshes.SM_PROP_Powerline'
    BoneAName=b_endA
    BoneBName=b_endB
    MidBoneName=b_mid
    Droop=32.0
    SwayDistance=16.0
    SwaySpeed=1.0
    AnimBoneIndex=-1
    BoneAIndex=-1
    BoneBIndex=-1
    bStatic=true

    begin object name=SkeletalMeshComponent0 class=SkeletalMeshComponent
        SkeletalMesh=SkeletalMesh'EXT_PROP_Powerlines.Meshes.SM_PROP_Powerline'
        bUpdateSkelWhenNotRendered=false
        bUseAsOccluder=false
    end object

    CableMeshComponent=SkeletalMeshComponent0
    Components.Add(SkeletalMeshComponent0)
}