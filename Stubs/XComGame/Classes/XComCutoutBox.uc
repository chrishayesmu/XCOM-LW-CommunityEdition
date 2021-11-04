class XComCutoutBox extends StaticMeshActor
	native;
//complete stub

enum ECardinalAxis
{
    POS_X,
    NEG_X,
    POS_Y,
    NEG_Y,
    ECardinalAxis_MAX
};

var transient XComBuildingVisPOI m_kBuildingVisPOI;
var transient XComCutoutBox.ECardinalAxis TraceDirections[2];
//var native transient map<0, 0> m_aCutoutActors;
var transient bool m_bEnabled;
var transient bool m_bIsInside;
var transient bool m_bHidingObscuredVisGroups;
var native transient bool bCutdownNeedsReset;
var transient XComBuildingVolume ObscuringBuildingVolume;
var transient Vector CutoutPosition;
var transient float TracedBoxDims[4];
var transient float TraceResults[4];
var transient float BoxHeight;
var transient float fZMaskPos;
var transient float fZMaskScale;
var native transient float fZPos;
var native transient float fZScale;
var native transient float fCutdownHeight;
var native transient float fEnableDelay;
var native transient float fBuildingCutdownZ;
var native transient float fBuildingCutoutZ;
var native transient XCom3DCursor m_kCachedCursor;
var float BoxWidth;
var native transient float fMaxZCutdown;

function SetCameraPitchingMode(bool bState){}
native function SetCameraPitchingModeNative(bool bState);
native function int GetNumCutoutActors();
native function FlushCutoutActors();
native function UpdateActors(optional bool bHideOnly, optional bool bRevealOnly, optional bool bMouseIsActive);
native function DumpCutoutActors();
native function UpdateBoxDimensions(XComBuildingVolume CurrentBuildingVolume);
native function UpdateMaskDimensions();

simulated function PostBeginPlay(){}
simulated event Tick(float fDeltaTime){}
function SetEnabled(bool bEnabled){}
