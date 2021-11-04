class XComGrappleLine extends Actor
    native(Weapon)
    notplaceable
    hidecategories(Navigation);
//complete stub

var() const name GrappleBoneName;
var() const name WeaponBoneName;
var() const float BaseLength;
var const transient int GrappleBoneIndex;
var const transient int WeaponBoneIndex;
var export editinline SkeletalMeshComponent SkelMeshComp;
var transient Vector GrapplePoint;
var private SkeletalMesh RopeMesh;

native simulated function SetGrapplePoint(const Vector InGrapplePoint);
native simulated function Update();

simulated event PostBeginPlay(){}

