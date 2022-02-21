class LWCE_XGAbility_Rift extends XGAbility_Rift;

function CalcDamage()
{
    class'LWCE_XGAbility_Extensions'.static.CalcDamage(self);
}

simulated function int GetPossibleDamage()
{
    return class'LWCE_XGAbility_Extensions'.static.GetPossibleDamage(self);
}