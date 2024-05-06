class SeqAct_XComDummyWeaponFire extends SeqAct_Latent
    forcescriptorder(true)
    hidecategories(Object);

var XComUnitPawn DummyPawn;
var() int ShotsToFire;
var() float DelayBetweenShots;
var() XComWeapon WeaponClass;
var() byte FireMode;
var() Actor Origin;
var() Actor Target;
var() float HorizontalConeHalfAngleRadians;
var() float VerticalConeHalfAngleRadians;
var XComWeapon DummyWeapon;
var int ShotsFired;
var bool bStartFiring;
var float fTimeUntilNextShot;
var XGPlayer kPlayer;
var XGCharacter kChar;
var XGUnit kSoldier;

defaultproperties
{
    ShotsToFire=1
    bCallHandler=false
    bAutoActivateOutputLinks=false
    InputLinks(0)=(LinkDesc="Start Firing")
    InputLinks(1)=(LinkDesc="Stop Firing")
    OutputLinks(0)=(LinkDesc="Out")
    OutputLinks(1)=(LinkDesc="Finished")
    OutputLinks(2)=(LinkDesc="Stopped")
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Origin",PropertyName=Origin,MaxVars=1)
    VariableLinks(1)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Target",PropertyName=Target,MaxVars=1)
    ObjName="Dummy Weapon Fire (Pre-Rendered Cinematics Only)"
}