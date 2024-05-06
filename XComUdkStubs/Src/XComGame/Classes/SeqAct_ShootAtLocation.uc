class SeqAct_ShootAtLocation extends SequenceAction
    native(Level)
    dependson(XGTacticalGameCoreData)
    forcescriptorder(true)
    hidecategories(Object);

enum ShotType
{
    ShotType_Normal,
    ShotType_Miss,
    ShotType_Suppress,
    ShotType_Grenade,
    ShotType_Launcher,
    ShotType_MAX
};

var Object IgnoreShooter;
var Object ShooterSpawner;
var Object ShooterActor;
var Object TargetSpawner;
var Actor TargetActor;
var Vector LocationVector;
var() bool ModifyCurrent;
var() bool FireImmediately;
var deprecated bool MustPerformAction;
var() bool ShootOnlyAtTarget;
var() bool ShootAtWorldLocation;
var deprecated bool DontChangeTargets;
var deprecated bool KillTargets;
var() bool MustFire;
var() bool MustShootThisWeapon;
var() ShotType TypeOfShot;
var() EAbility CustomAbility;
var() int DamageOverride;
var() float CursorRestrictedRange;

defaultproperties
{
    FireImmediately=true
    TypeOfShot=ShotType.ShotType_Miss
    bCallHandler=false
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Ignore Object",PropertyName=IgnoreShooter)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Shooter Spawner",PropertyName=ShooterSpawner)
    VariableLinks(2)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Shooter Actor",PropertyName=ShooterActor)
    VariableLinks(3)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Target Spawner",PropertyName=TargetSpawner)
    VariableLinks(4)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Target Actor",PropertyName=TargetActor)
    VariableLinks(5)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Target Location",PropertyName=LocationVector)
    ObjName="Shoot at Location"
}