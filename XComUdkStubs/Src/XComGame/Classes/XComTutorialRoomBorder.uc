class XComTutorialRoomBorder extends StaticMeshActor
    hidecategories(Navigation);

var MaterialInstanceConstant MIC;
var bool bPulsing;
var float CurrentPulseTime;
var float MaxPulseTime;
var LinearColor BorderColor;
var float ChokeAmount;

defaultproperties
{
    MaxPulseTime=1.0
    BorderColor=(R=0.850,G=0.810,B=0.140,A=1.0)
    ChokeAmount=6.0
    bStatic=false
    bStaticCollision=true
    bConsiderAllStaticMeshComponentsForStreaming=true
    bPathColliding=true

    begin object name=StaticMeshComponent0
        StaticMesh=StaticMesh'HQ_RoomBorderFX.Meshes.RoomBorderGlowRing'
        WireframeColor=(R=193,G=255,B=6,A=255)
        HiddenGame=true
        bReceiverOfDecalsEvenIfHidden=true
        bForceDirectLightMap=false
    end object
}