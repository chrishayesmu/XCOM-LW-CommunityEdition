class XComFloorVolume extends Volume
    native(Level)
    hidecategories(Navigation,Movement,Display,Object);

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

defaultproperties
{
    m_bUseForBuildingReveal=true
    m_bCanHideBuildingIfBlockingVisibility=true
    m_FloorCursorUpperZFactor=0.250
    m_kProxyGeometryMaterial=Material'FX_Visibility.Materials.m_ProxyGeometry'
    BrushColor=(R=255,G=199,B=6,A=255)
    bColored=true
}