class XComOutsider extends XComAlienPawn
    config(Game)
    hidecategories(Navigation,Physics,Collision,PrimitiveComponent,Rendering);
//complete stub

var() MaterialInterface StartInvisibleMaterial;
var() MaterialInterface RevealMaterial;
var() MaterialInterface RevealWeaponMaterial;
var transient bool m_bHasSetStartingWeaponMaterials;

simulated function PostBeginPlay(){}
function SwapToInvisibleMaterials(SkeletalMeshComponent kSkelMeshComp){}
simulated function EquipWeapon(XComWeapon kWeapon, bool bImmediate, bool bIsRearBackPackItem){}
function SwapToRevealMaterials(){}
