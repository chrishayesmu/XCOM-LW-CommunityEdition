class XComHairContent extends Actor
    native(Unit)
    notplaceable
    hidecategories(Navigation,Movement,Display,Attachment,Actor,Collision,Physics,Debug,Object,Advanced)
	dependson(XComContentManager);
//complete stub

var() SkeletalMesh SkeletalMesh;
var() PhysicsAsset PhysicsAsset;
var() name SocketName;
var() bool bIsHelmet;
var() SkeletalMesh SkeletalMeshFemale;
var() PhysicsAsset PhysicsAssetFemale;
var() SkeletalMesh FallbackSkeletalMeshFemale;
var() PhysicsAsset FallbackPhysicsAssetFemale;
var() name SocketNameFemale;
var() SkeletalMesh FallbackSkeletalMesh;
var() PhysicsAsset FallbackPhysicsAsset;
var() array<MaterialInterface> Materials;
var() EColorPalette ColorPalette;