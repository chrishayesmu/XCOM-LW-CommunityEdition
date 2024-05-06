class XComPawnIndoorOutdoorInfo extends Object
    native(Level);

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

defaultproperties
{
    m_bShouldRevealFloors=true
}