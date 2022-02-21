class LWCE_XGAbility_OneForAll extends XGAbility_OneForAll;

function CalcDamage()
{
    class'LWCE_XGAbility_Extensions'.static.CalcDamage(self);
}

simulated function int GetPossibleDamage()
{
    return class'LWCE_XGAbility_Extensions'.static.GetPossibleDamage(self);
}