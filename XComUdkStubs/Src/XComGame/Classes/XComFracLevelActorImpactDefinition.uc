class XComFracLevelActorImpactDefinition extends Object
    native(Level)
    dependson(XGGameData);

struct native WeaponImpact
{
    var() class<XComDamageType> EffectDamageType;
    var() editinline EffectCue EffectTemplate;

    structdefaultproperties
    {
        EffectDamageType=class'XComDamageType_Bullet'
    }
};

struct native MaterialImpact
{
    var() EMaterialType MaterialType;
    var() array<WeaponImpact> WeaponBasedEffects;
    var() StaticMesh EdgeBaseDebrisModel_Large;
    var() editinline EffectCue EffectTemplate;
};

var() array<MaterialImpact> MaterialBasedEffects;
var() EmitterInstanceParameterSet DefaultInstanceParameterSet;