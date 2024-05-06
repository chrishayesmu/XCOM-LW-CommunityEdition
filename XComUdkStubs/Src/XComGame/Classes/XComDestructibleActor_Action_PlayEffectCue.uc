class XComDestructibleActor_Action_PlayEffectCue extends XComDestructibleActor_Action within XComDestructibleActor
    native(Destruction)
    editinlinenew
    collapsecategories
    hidecategories(Object);

var(XComDestructibleActor_Action) export editinline EffectCue EffectCue;
var(XComDestructibleActor_Action) EmitterInstanceParameterSet InstanceParameters;
var(XComDestructibleActor_Action) Rotator RotationAdjustment;
var(XComDestructibleActor_Action) Vector PositionAdjustment;
var(XComDestructibleActor_Action) Vector Scale;
var(XComDestructibleActor_Action) XComDestructibleActorImpactDefinition WeaponImpactDefinitions;
var export editinline transient array<export editinline ParticleSystemComponent> PSCs;