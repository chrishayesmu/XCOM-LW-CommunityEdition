class XGLevel extends XGLevelNativeBase
    hidecategories(Navigation)
    native(Level)
    notplaceable
    dependson(XComAlienPod);
//complete  stub

struct CheckpointRecord
{
    var array<XComAlienPod> m_arrPods;
    var bool m_bStreamingLevelsComplete;
    var TCameraCache SavedCameraCache;
};

var XGBuildingVisParam m_kBuildingVisParam;
var XComBuildingVolume m_kDropship;
var array<XComAlienPod> m_arrPods;
var XComVis m_kVis;
var array<XComBuildingVolume> m_kBuildingVolumeHistory;
var float m_fLevelTime;
var array<Actor> m_aHideableFlaggedLevelActors_CurrentlyHiddenByRaycast;
var int m_iNumLevelActorsCurrentlyHiddenByRaycast;
var float m_fNextHidePropsAndBuildingsCheck;
var bool m_bStreamingLevelsComplete;
var bool m_bLoadingSaveGame;
var bool m_bBuildingAndPropHiding;
var bool m_bIsCameraPitching;
var XComLevelVolume LevelVolume;
var XComWorldData VisibilityMap;
var TCameraCache SavedCameraCache;
var transient int SleepFrames;
var XGProjectileManager m_kProjectileMgr;
var array<TriggerVolume> m_arrWaterVolumes;

function CreateCheckpointRecord(){}
function AddToBuildingVolumeHistory(XComBuildingVolume kBVolume){}
function HideBuildingVolumeHistory(optional bool bBuildingWithinABuildingOnly){}
event PreBeginPlay(){}
function SetupXComFOW(bool bEnable){}
function SetupXComVis(){}
function Init(){}
function LoadInit(){}
function InitFloorVolumes(){}
function InitWaterVolumes(){}
simulated function AdjustForAbductorBrokenFloor(out Floor kFloor, int iFloorIndex){}
event OnActorUpdateBuildingVisibilityForMouse(Object Params){}
event bool ShouldUseMouseStyleReveals(){}
event OnActorUpdateBuildingVisibility(Object Params){}
simulated function OnUpdateThirdPersonMode_ForceUnReveal(){}
simulated function OnUpdateThirdPersonMode_ForceReveal(XGUnitNativeBase kUnit){}
simulated function OnUpdateThirdPersonMode_ForceRevealNoUnit(){}
simulated function XGUnit GetActiveUnit(){}
simulated function bool IsThirdPerson(){}
simulated function bool IsGlamCam(){}
simulated function bool IsCinematic(){}
simulated event bool ShouldForceUnreveal(){}
simulated function OnUpdateThirdPersonMode(XGUnitNativeBase kUnit){}
simulated function LoadStreamingLevels(bool bLoadingSaveGame){}
simulated function OnStreamingFinished(){}
function int GetWidth(){}
function int GetHeight(){}
simulated function bool IsInBounds(Vector vLoc){}
simulated function float GetTop(){}
simulated function float GetBottom(){}
simulated function float GetLeft(){}
simulated function float GetRight(){}
function XComBuildingVolume GetDropship(){}
simulated function XComBuildingVolume GetBuildingByUnit(XGUnit kUnit){}
function array<XComBuildingVolume> GetBuildings(){}
function bool IsInsideBuilding(Vector vLoc, optional out XComBuildingVolume kVolume){}
function bool IsTileInsideBuilding(int iTileX, int iTileY, int iTileZ){}
function bool GetValidatedPodLocation(out int iTileX, out int iTileY, out int iTileZ, const out XComAlienPod kPod, array<Vector> arrFallback, out array<int> arrValid2x3){}
simulated function HideAllFloors(bool bUseFade){}
native simulated function UpdatePropHidingAndBuildingHiding(optional bool bForceUpdate);
native simulated function DisablePropHiding();
event Tick(float fDeltaT){}
function UpdateWaterVolumes(){}
function AddPod(XComAlienPod kPod){}
function RemovePod(XComAlienPod kPod){}
function bool GetPodsOfType(EPodType eType, out array<XComAlienPod> arrPods){}
simulated event OnCleanupWorld(){}
simulated function RemoveReferences(){}
native function CleanupLocalization();

state Streaming{

    function InitDynamicElements(){}
    function bool IsLevelStreamingReplicated(){}
}