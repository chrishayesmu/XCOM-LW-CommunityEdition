class XComDestructibleActor_Action_RadialDamage extends XComDestructibleActor_Action within XComDestructibleActor
    native(Destruction)
    editinlinenew
    collapsecategories
    hidecategories(Object);

var(XComDestructibleActor_Action) float DamageRadius;
var(XComDestructibleActor_Action) float DamageAmount;
var(XComDestructibleActor_Action) class<DamageType> DamageType;
var(XComDestructibleActor_Action) float Momentum;
var(XComDestructibleActor_Action) Vector Offset;
var(XComDestructibleActor_Action) bool bLocalSpace;

defaultproperties
{
    DamageRadius=500.0
    DamageAmount=500.0
    DamageType=class'XComDamageType_Explosion'
    Momentum=3000.0
    bLocalSpace=true
}