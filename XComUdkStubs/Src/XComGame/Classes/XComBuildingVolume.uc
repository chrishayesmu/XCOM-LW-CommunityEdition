class XComBuildingVolume extends Volume
    native(Level)
    hidecategories(Navigation,Movement,Display);

struct native ExternalMeshHidingGroup
{
    var() string GroupName;
    var() bool bEnabled;
    var() array<Actor> m_aActors;

    structdefaultproperties
    {
        bEnabled=true
    }
};

struct native FloorActorInfo
{
    var Actor ResidentActor;
    var byte CutdownFloor;
};

struct native Floor
{
    var float fCenterZ;
    var float fExtent;
    var() init array<init XComFloorVolume> FloorVolumes;
    var() array<string> ExternalMeshGroupNames;
    var array<int> ExternalMeshGroupIndices;
    var array<FloorActorInfo> m_aCachedActors;
    var array<Emitter> m_aCachedEmitters;
};

var() init array<init Floor> Floors;
// var() init editoronly array<init editoronly VisGroupActor> VisGroupsToHideWhenOccluding; // VisGroupActor is an XCOM-added intrinsic class; we can't use it
var init array<init int> VisGroupIdxToHideWhenOccluding;
var() array<ExternalMeshHidingGroup> ExternalMeshGroups;
var() bool IsUfo;
var() bool IsDropShip;
var() bool IsInside;
var() bool m_bAllowBuildingReveal;
var() bool m_bIsInternalBuilding;
var transient bool IsHot;
var bool bDebuggingThisBuilding;
var bool bOccludingCursor;
var bool bPrevOccludingCursor;
var protected transient int LastShownFloor;
var native transient float fCurrentCutdownHeight;
var native transient float fCurrentCutoutHeight;
var XGLevelNativeBase m_kLevel;

defaultproperties
{
    IsInside=true
    m_bAllowBuildingReveal=true
    LastShownFloor=666
    BrushColor=(R=7,G=255,B=82,A=255)
    bColored=true
    bStatic=false
    bNoDelete=false
}