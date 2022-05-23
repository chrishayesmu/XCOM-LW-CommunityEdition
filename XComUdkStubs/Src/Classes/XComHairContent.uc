class XComHairContent extends Actor
    dependson(XComContentManager)
    notplaceable
    hidecategories(Navigation,Movement,Display,Attachment,Actor,Collision,Physics,Debug,Object,Advanced);

var() SkeletalMesh SkeletalMesh <Tooltip = "The mesh to use for male characters.">;
var() PhysicsAsset PhysicsAsset;
var() name SocketName <Tooltip = "Name of the socket to attach physics asset to for male characters.">;
var() bool bIsHelmet;
var() SkeletalMesh SkeletalMeshFemale <Tooltip = "The mesh to use for female characters.">;
var() PhysicsAsset PhysicsAssetFemale;
var() SkeletalMesh FallbackSkeletalMeshFemale;
var() PhysicsAsset FallbackPhysicsAssetFemale;
var() name SocketNameFemale <Tooltip = "Name of the socket to attach physics asset to for female characters.">;
var() SkeletalMesh FallbackSkeletalMesh;
var() PhysicsAsset FallbackPhysicsAsset;
var() array<MaterialInterface> Materials;
var() EColorPalette ColorPalette;