class XComEmptyMecPawn extends XComMecPawn
    config(Game)
    hidecategories(Navigation,Physics,Collision,PrimitiveComponent,Rendering);
//complete stub

var bool UsePreviewMaterial;

simulated function SetUsePreviewMaterial(){}
simulated function ApplyPreviewMaterial(){}
state CharacterCustomization
{
    simulated event BeginState(name PreviousStateName){}
    function OnArmorLoaded(Object ArmorArchetype, int ContentId, int SubID){}
}

defaultproperties
{
}