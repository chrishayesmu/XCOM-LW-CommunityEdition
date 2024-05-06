class XComDestructibleActorImpactDefinition extends Object;

struct native WeaponImpact
{
    var() class<XComDamageType> EffectDamageType;
    var() editinline EffectCue Effect;

    structdefaultproperties
    {
        EffectDamageType=class'XComDamageType_Bullet'
    }
};

var() array<WeaponImpact> WeaponBasedEffects;