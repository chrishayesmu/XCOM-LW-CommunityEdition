class LWCE_XGAbility_ShredderRocket extends XGAbility_ShredderRocket;

function CalcDamage()
{
    class'LWCE_XGAbility_Extensions'.static.CalcDamage(self);
}

simulated function int GetPossibleDamage()
{
    return class'LWCE_XGAbility_Extensions'.static.GetPossibleDamage(self);
}