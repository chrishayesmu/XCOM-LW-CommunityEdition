class XComTank extends XComUnitPawn
    config(Game)
    hidecategories(Navigation,Physics,Collision,PrimitiveComponent,Rendering);

var MaterialInterface m_kMatInterface_TreadLeft;
var MaterialInterface m_kMatInterface_TreadRight;
var Vector m_fLastGroundTrack_Left;
var Vector m_fLastGroundTrack_Right;
var float m_fTreadPosLeft;
var float m_fTreadPosRight;
var float m_fTreadVelocityLeft;
var float m_fTreadVelocityRight;
var float m_fTreadFactor;
var AnimNode_MultiBlendPerBone TreadWheelsNode;
var AnimNodeSequence m_kTreadWheelNodeLeft;
var AnimNodeSequence m_kTreadWheelNodeRight;
var float m_fWheelFactor;
var private EItemType PrimaryWeapon;
var private bool m_bUnitContentLoaded;

simulated function InitializeTreadWheelsNode(){}
simulated event PostBeginPlay(){}
simulated function CacheTreads(){}
simulated function SetTreadFactor(float fFactor){}
simulated function SetWheelFactor(float fFactor){}
simulated function SetTreadPos(MaterialInterface kTread, float fPos){}
simulated function float ProcessTreadPos(float dt, float treadPos, float fVelocity){}
simulated function ProcessTreadsAndWheels(float dt){}
simulated event Tick(float dt){}
simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp){}
simulated function Init(const out TCharacter inCharacter, const out TInventory Inv){}
simulated function OnArmorLoaded(Object ArmorArchetype, int ContentId, int SubID){}
simulated function bool IsPawnReadyForViewing(){}
simulated function bool IsUnitFullyComposed(optional bool bBoostTextures=true){}


state InHQ
{
    event BeginState(name PreviousStateName){}
    simulated event EndState(name NextStateName){}
    simulated function Tick(float dt){}
}
state CharacterCustomization extends InHQ
{
    simulated function RotateInPlace(int Dir){}
}

defaultproperties
{
    m_fTreadFactor=0.030
    m_fWheelFactor=0.030
    TurnSpeedMultiplier=3.0
    m_bShouldTurnBeforeMoving=true
}
