class XGVolumeMgr extends Actor
	DependsOn(XGTacticalGameCoreNativeBase)
	dependson(UI_FxsPanel);
//complete stub
struct CheckpointRecord
{
    var XGVolume m_aVolumes[255];
    var int m_iNumVolumes;
};

var XGVolume m_aVolumes[255];
var int m_iNumVolumes;
var bool m_bResolveSplashDamage;
var array<TVolume> m_arrTVolumes;
var array<XGVolume> m_arrDelayAddVolumes;

replication
{
    if(bNetDirty && Role == ROLE_Authority)
        m_aVolumes, m_iNumVolumes;
}
simulated function Init(){}
simulated function LoadInit(){}
simulated event PreBeginPlay(){}
simulated function TVolume GetTVolume(EVolumeType eVolume){}
simulated function BuildTVolumes(){}
simulated function BuildTVolume(EVolumeType eVolume, int iDuration, float fRadius, float fHeight, EWidgetColor eColor, float fAlpha, optional EColorShade eShade, optional EVolumeEffect eEffect1, optional EVolumeEffect eEffect2){}
function XGVolume CreateVolumeByType(EVolumeType kType, Vector vCenter, optional float fRadius=-1.0, optional float fHeight=-1.0, optional int iNumTurns=-1, optional XGUnit kOwner){}
function CheckDelayAddVolumes(){}
function XGVolume CreateVolume(TVolume kTVolume, XGUnit kInstigator, Vector vCenter, optional XGAbility_Targeted kAbility){}
function AddVolume(XGVolume kVolume){}
function AddUnitsToNewVolume(XGVolume kVolume){}
function XGBattle BATTLE(){}
function CheckAgainstVolumes(XGUnit kUnit){}
function CheckAgainstVolumes_AnyMovement(XGUnit kUnit){}
function bool IsInTelekineticField(XComProjectile kProjectile){}
function Update(){}
function RemoveVolume(XGVolume kVolume){}
function SetAllSightBlockingVolumes(bool bEnable){}
function RemoveOwnedTelekineticField(XGUnit kOwner){}
function UpdateTelekineticFieldsForUnit(XGUnit kUnit){}
function TestSplashDamage(const out Vector SplashDamageCenter, float Radius){}
function TestSplashDamageDirectional(const out Vector SplashDamageCenter, float Radius, const out Vector Direction, float AngleRadians){}
function ResolveSplashDamage(){}
