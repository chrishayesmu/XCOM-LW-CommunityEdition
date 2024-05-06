class XGVolume extends Actor
    notplaceable
    hidecategories(Navigation);

const MAX_UNITS_IN_VOLUME = 32;

struct AddToWorldReplicationInfo
{
    var TVolume m_kTVolume;
};

struct CheckpointRecord
{
    var TVolume m_kTVolume;
    var XGUnit m_kInstigator;
    var XGUnit m_aUnits[MAX_UNITS_IN_VOLUME];
    var int m_iNumUnitsInVolume;
    var int m_iTurnTimer;
    var Vector m_vCenter;
    var XGAbility_Targeted m_kAbility;
    var XGUnit m_sightHandler;
};

var TVolume m_kTVolume;
var privatewrite XGUnit m_kInstigator;
var XGUnit m_aUnits[MAX_UNITS_IN_VOLUME];
var int m_iNumUnitsInVolume;
var int m_iTurnTimer;
var Vector m_vCenter;
var XGAbility_Targeted m_kAbility;
var Actor m_kActor;
var DynamicSMActor_Spawnable m_kVolumeFX;
var bool m_bSightBlocking;
var bool m_bProximityMineExplosionRequested;
var bool bProcessLoadedFromSave;
var bool m_bClientAddedToWorld;
var repnotify AddToWorldReplicationInfo m_kAddToWorldReplicationInfo;
var array<XGVolume_DamageOverTimeReplicationInfo> m_aDamageOverTimeReplicationInfos;
var XGUnit m_sightHandler;

defaultproperties
{
    RemoteRole=ROLE_SimulatedProxy
    bTickIsDisabled=true
    bAlwaysRelevant=true

    begin object name=CollisionCylinder class=CylinderComponent
        CollisionHeight=0.0
        CollisionRadius=0.0
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    end object

    CollisionComponent=CollisionCylinder
    Components.Add(CollisionCylinder)

}