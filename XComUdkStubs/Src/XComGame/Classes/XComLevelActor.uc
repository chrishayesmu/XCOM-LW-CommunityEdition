class XComLevelActor extends StaticMeshActor
    native(Level)
    hidecategories(Navigation)
    implements(XComCoverInterface, IMouseInteractionInterface);

struct native VisibilityBlocking
{
    var() const bool bBlockUnitVisibility;

    structdefaultproperties
    {
        bBlockUnitVisibility=true
    }
};

var() const editconst export editinline XComFloorComponent FloorComponent;
var() VisibilityBlocking VisibilityBlockingData;
var() const bool HideableWhenBlockingObjectOfInterest;
var() const bool bIgnoreFor3DCursorCollision;
var(Cover) bool bAlwaysConsiderForCover;
var(Cover) bool bCanClimbOver;
var(Cover) bool bCanClimbOnto;
var(Cover) bool bIsValidDestination;
var(Cover) bool bIgnoreForCover;
var(Cover) bool bUseRigidBodyCollisionForCover;
var() LinearColor TintColor;
var() Actor HidingPartner;
var(Cover) ECoverForceFlag CoverForceFlag;
var(Cover) ECoverForceFlag CoverIgnoreFlag;

defaultproperties
{
    VisibilityBlockingData=(bBlockUnitVisibility=true)
    bAlwaysConsiderForCover=true
    bCanClimbOnto=true
    bIsValidDestination=true
    bStatic=false
    bStaticCollision=true
    bTickIsDisabled=true
    m_bNoDeleteOnClientInitializeActors=true
    bConsiderAllStaticMeshComponentsForStreaming=true
    bPathColliding=true

    begin object name=StaticMeshComponent0
        WireframeColor=(R=193,G=255,B=6,A=255)
        ReplacementPrimitive=none
        bReceiverOfDecalsEvenIfHidden=true
        bForceDirectLightMap=false
    end object

    begin object Class=XComFloorComponent Name=FloorComponent0
		fTargetOpacityMaskHeight=999999.0
	end object
	FloorComponent=FloorComponent0
	Components.Add(FloorComponent0)
}