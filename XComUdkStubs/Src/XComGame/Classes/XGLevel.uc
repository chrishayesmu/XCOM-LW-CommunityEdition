class XGLevel extends XGLevelNativeBase
    native(Level)
    notplaceable
    hidecategories(Navigation);

struct CheckpointRecord
{
    var array<XComAlienPod> m_arrPods;
    var bool m_bStreamingLevelsComplete;
    var TCameraCache SavedCameraCache;
};

var XGBuildingVisParam m_kBuildingVisParam;
var protected XComBuildingVolume m_kDropship;
var protected array<XComAlienPod> m_arrPods;
var XComVis m_kVis;
var array<XComBuildingVolume> m_kBuildingVolumeHistory;
var private float m_fLevelTime;
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

defaultproperties
{
    m_bBuildingAndPropHiding=true
    SavedCameraCache=(TimeStamp=0.0,POV=(Location=(X=0.0,Y=0.0,Z=0.0),Rotation=(Pitch=0,Yaw=0,Roll=0),FOV=90.0))
}