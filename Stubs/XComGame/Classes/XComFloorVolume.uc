class XComFloorVolume extends Volume
    hidecategories(Navigation,Movement,Display,Object)
    native(Level);
//complete stub

enum EFloorVolumeType
{
    eFloor_Default,
    eFloor_Stair,
    eFloor_Invalid_MoveCursorUp,
    eFloor_Invalid_MoveCursorDown,
    eFloor_MAX
};

var() bool m_bUseForBuildingReveal;
var() bool m_bCanHideBuildingIfBlockingVisibility;
var() bool m_bDisableCutout;
var() bool m_bNonEnterableBuildingPiece;
var bool m_bSimplifiedGeometryMode;
var bool bOccludingCursor;
var bool bPrevOccludingCursor;
var() float m_FloorCursorUpperZFactor;
var() EFloorVolumeType m_FloorVolumeType;
var() array<Actor> m_aInclusionActors;
var() array<Actor> m_aExclusionActors;
var() XComLevelActor m_kProxyGeometry;
var Material m_kProxyGeometryMaterial;
var() editconst int FloorNumber;
var transient XComBuildingVolume CachedBuildingVolume;

native function SetSimplifiedGeometryMode(bool bEnableSimplifiedGeometry);
simulated event PostBeginPlay(){}
function bool IsValidUnit(ETeam inputTeam){}
function bool ContainsValidUnit(){}
