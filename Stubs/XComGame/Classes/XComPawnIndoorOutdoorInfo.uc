class XComPawnIndoorOutdoorInfo extends Object
    native(Level)
dependson(XComFloorVolume);
//complete stub

var array<XComFloorVolume> CurrentFloorVolumes;
var XComBuildingVolume CurrentBuildingVolume;
var XComBuildingVolume PreviousBuildingVolume;
var protected int iCachedCurrentFloorNumber;
var protected int iCachedLowestFloorNumber;
var protected int iCachedBestMatchingFloorNumber;
var protected int iCachedLowestOccupiedFloorNumber;
var float fLowestFloorHalfHeight;
var float fLowestFloorLocationZ;
var float fLowestFloorCursorUpperZFactor;
var EFloorVolumeType eLowestFloorVolumeType;
var bool m_bShouldRevealFloors;
var bool m_bForceRaycast;
var IXComBuildingVisInterface BuildingVisActor;

function ParentTouchedOrUntouched(Actor A, bool bTouched){}
final function CacheBestMatchingFloor(){}
function bool IsOnRoof(){}
final function CacheLowestOccupiedFloor(){}
function bool JustLeftBuildingWithinABuilding(){}
function bool IsSamePreviousAndCurrentBuilding(){}
function bool JustEnteredBuildingWithinABuilding(){}
function bool JustEnteredBuilding(){}
function CheckForFloorVolumeEvents(){}

native simulated function bool IsInside();
native simulated function bool IsInsideUfo();
native simulated function bool IsInsideDropship();
function int GetCurrentFloorNumber(){}
function int GetLowestFloorNumber(){}
function float GetLowestFloorHalfHeight(){}
function float GetLowestFloorLocationZ(){}
function float GetLowestFloorCursorUpperZFactor(){}
function EFloorVolumeType GetLowestFloorVolumeType(){}
function float GetLowestOccupiedFloorNumber(){}
