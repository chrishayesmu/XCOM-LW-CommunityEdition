class XComZombie extends XComAlienPawn
    config(Game)
    hidecategories(Navigation,Physics,Collision,PrimitiveComponent,Rendering);
//complete stub

var() MaterialInterface ZombieSkinMaterial;
var() MaterialInterface ZombieCivilianBodyMaterial;

simulated function CopyMeshFromVictim(XComUnitPawn Victim){}
simulated function CopyMeshAndMaterials(SkeletalMeshComponent SourceComp, SkeletalMeshComponent DestComp, SkeletalMeshComponent SourceMainMesh){}
simulated function CopyHair(XComHumanPawn Victim){}
