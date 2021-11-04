class XComDestructibleActor_Toughness extends Object
    native(Destruction);
//complete stub

var() int Health;
var() bool bFragile;
var() bool bInvincible;
var() bool bSuccumbsToDamage;
var() bool bImmuneToAreaBurnDamage;
var() class<XComDamageType> SuccumbsToDamageClass;

defaultproperties
{
    Health=3
}