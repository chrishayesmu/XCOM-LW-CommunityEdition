class XGVolume extends Actor
    notplaceable
    hidecategories(Navigation);
//complete stub

const MAX_UNITS_IN_VOLUME = 32;

struct AddToWorldReplicationInfo
{
    var TVolume m_kTVolume;
};

struct CheckpointRecord
{
    var TVolume m_kTVolume;
    var XGUnit m_kInstigator;
    var XGUnit m_aUnits[32];
    var int m_iNumUnitsInVolume;
    var int m_iTurnTimer;
    var Vector m_vCenter;
    var XGAbility_Targeted m_kAbility;
    var XGUnit m_sightHandler;
};

var TVolume m_kTVolume;
var XGUnit m_kInstigator;
var XGUnit m_aUnits[32];
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

replication
{
    if(bNetInitial && Role == ROLE_Authority)
        m_kInstigator;

    if(bNetDirty && Role == ROLE_Authority)
        m_aUnits, m_bProximityMineExplosionRequested, 
        m_bSightBlocking, m_iNumUnitsInVolume, 
        m_iTurnTimer, m_kAbility, 
        m_kActor, m_kAddToWorldReplicationInfo, 
        m_kTVolume, m_sightHandler, 
        m_vCenter;
}

function bool ShouldSaveForCheckpoint(){}
function CreateCheckpointRecord();

function ApplyCheckpointRecord(){}
simulated event ReplicatedEvent(name VarName){}
function Init(TVolume kTVolume, Vector vCenter, optional XGAbility_Targeted kAbility){}
simulated function LoadInit(){}
simulated event Destroyed(){}
function UpdateCollision(){}
simulated function EVolumeType GetType(){}
simulated function bool HasEffect(EVolumeEffect eEffect){}
simulated function bool IsPointInVolume(Vector vPoint){}
simulated function bool HasUnitEntered(XGUnit kUnit){}
function CanProximityMineExplodeCheck(XGUnit kUnit){}
function PerformProximityMineExplosion(){}
function OnUnitEntered(XGUnit kUnit){}
function ApplyAbility(XGUnit kTarget){}
function OnUnitLeft(XGUnit kUnit){}
function OnUnitMoved(XGUnit kUnit){}
function bool ShouldApplyEffect(EVolumeEffect eEffect, XGUnit kUnit){}
simulated function SetSightBlocking(bool bEnable){}
simulated function OnAdd(){}
simulated function OnRemove(){}
simulated function InitVolumeEffect(optional XGUnit kUnit){}
function AddUnit(XGUnit kUnit){}
function RemoveUnit(XGUnit kUnit){}
function bool OnUnitEnterExit_Update(){}
function bool Update(){}
event Tick(float DeltaTime){}

defaultproperties
{
    begin object class=CylinderComponent name=CollisionCylinder 
        CollisionHeight=0.0
        CollisionRadius=0.0
        ReplacementPrimitive=none
        BlockZeroExtent=false
        BlockNonZeroExtent=false
    end object
    Components(0)=CollisionCylinder
	CollisionComponent=CollisionCylinder
}
