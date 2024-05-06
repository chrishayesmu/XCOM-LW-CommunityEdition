class SeqAct_CustomUnitFlag extends SequenceAction
    forcescriptorder(true)
    hidecategories(Object);

var XComHumanPawn UnitPawn;
var export editinline StaticMeshComponent AttachedMeshComponent;
var Vector MeshTranslation;
var Rotator MeshRotation;
var Vector MeshScale;
var() TextureMovie MovieTexture;
var() Material FlagMaterial;
var() StaticMesh MeshToAttach;

defaultproperties
{
    MeshTranslation=(X=60.0,Y=-35.0,Z=-25.0)
    MeshRotation=(Pitch=0,Yaw=-7281,Roll=8192)
    MeshScale=(X=2.0,Y=1.50,Z=1.0)
    bCallHandler=false
    InputLinks(0)=(LinkDesc="Attach")
    InputLinks(1)=(LinkDesc="Detach")
    InputLinks(2)=(LinkDesc="Play")
    InputLinks(3)=(LinkDesc="Stop")
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="UnitPawn",PropertyName=UnitPawn)
    ObjName="Custom UnitFlag"
}