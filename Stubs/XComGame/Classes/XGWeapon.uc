class XGWeapon extends XGInventoryItem
	native(Weapon);
//complete stub

const NUM_WEAP_ABILITIES = 8;

struct CheckpointRecord_XGWeapon extends CheckpointRecord_XGInventoryItem
{
    var int iAmmo;
    var int m_iTurnFired;
};

var int iAmmo;
var int iOverheatChance;
var int m_iTurnFired;
var bool bIsFixedRange;
var int aAbilities[8];
var ECursorType iCursorType;
var const localized string m_strMedikitII;
var const localized string m_strArcThrowerII;
var repnotify XComWeapon m_kReplicatedWeaponEntity;
var float fFiringRate;
var TWeapon m_kTWeapon;
var name GlamCamTag;

replication
{
    if(Role == ROLE_Authority)
        fFiringRate, iAmmo, 
        iOverheatChance, m_kReplicatedWeaponEntity;
}

function SetActorTemplateInfo(out ActorTemplateInfo TemplateInfo){}
simulated event ReplicatedEvent(name VarName){}
simulated function bool IsInitialReplicationComplete(){}
simulated event PostBeginPlay(){}
native simulated function Init();
simulated function Actor CreateEntity(){}
simulated function XComWeapon GetEntity(){}
event Destroyed(){}
simulated function bool DoesRadiusDamage(){}
simulated function float GetDamageRadius(){}
simulated function int GetDamageStat(){}
simulated event float LongRange(){}
simulated function int GetRemainingAmmo(){}
function ApplyAmmoCost(int iCost){}
simulated function int GetOverheatChance(){}
simulated function CoolDown(){}
simulated function ApplyOverheatIncrement(XGUnit kUnit, int iAmount){}
simulated function bool HasHeat(){}
simulated function bool IsOverheated(){}
simulated function Overheat(XGUnit kUnit){}
function bool IsMelee(){}
simulated function bool HasProperty(int iWeaponProperty){}
simulated function bool CanBeStartingWeapon(){}
native simulated function bool WeaponHasStandardShot();
simulated function int GetOverallDamageRadius(){}
