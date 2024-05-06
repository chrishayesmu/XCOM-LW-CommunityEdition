class XComGrappleLine extends Actor
    native(Weapon)
    notplaceable
    hidecategories(Navigation);

var() const name GrappleBoneName;
var() const name WeaponBoneName;
var() const float BaseLength;
var const transient int GrappleBoneIndex;
var const transient int WeaponBoneIndex;
var export editinline SkeletalMeshComponent SkelMeshComp;
var transient Vector GrapplePoint;
var private SkeletalMesh RopeMesh;

defaultproperties
{
    GrappleBoneName=b_end
    WeaponBoneName=b_start
    BaseLength=10.0
    GrappleBoneIndex=-1
    WeaponBoneIndex=-1

    begin object name=SkeletalMeshComponent0 class=SkeletalMeshComponent
    end object
    SkelMeshComp=SkeletalMeshComponent0

    Components(0)=SkeletalMeshComponent0
}