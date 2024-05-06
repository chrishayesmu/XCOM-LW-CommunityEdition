class XComDestructibleActor_Action_DamageOverTime extends XComDestructibleActor_Action within XComDestructibleActor
    native(Destruction)
    editinlinenew
    collapsecategories
    hidecategories(Object);

var(XComDestructibleActor_Action) int DamageAmount;
var(XComDestructibleActor_Action) class<XComDamageType> DamageType;
var transient DamageEvent MyDamageEvent;
var transient int TurnToApplyDamage;

defaultproperties
{
    MyDamageEvent=(DamageAmount=0,EventInstigator=none,HitLocation=(X=0.0,Y=0.0,Z=0.0),Momentum=(X=0.0,Y=0.0,Z=0.0),DamageType=none,HitInfo=(Material=none,PhysMaterial=none,Item=0,LevelIndex=0,BoneName=None,HitComponent=none),DamageCauser=none,bRadialDamage=false,Radius=0.0,bIsHit=false,IgnoredActors=none,Target=none,bDamagesUnits=true,bCausesSurroundingAreaDamage=true,bDebug=false,FilterBox=(Min=(X=0.0,Y=0.0,Z=0.0),Max=(X=0.0,Y=0.0,Z=0.0),IsValid=0),kShot=none)
}