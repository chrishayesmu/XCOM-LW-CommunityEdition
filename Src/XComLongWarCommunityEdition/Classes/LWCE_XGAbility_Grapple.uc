class LWCE_XGAbility_Grapple extends XGAbility_Grapple;

function CalcDamage()
{
    class'LWCE_XGAbility_Extensions'.static.CalcDamage(self);
}

simulated function int GetPossibleDamage()
{
    return class'LWCE_XGAbility_Extensions'.static.GetPossibleDamage(self);
}