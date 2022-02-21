class LWCE_XGAbility_Ascend extends XGAbility_Ascend;

function CalcDamage()
{
    class'LWCE_XGAbility_Extensions'.static.CalcDamage(self);
}

simulated function int GetPossibleDamage()
{
    return class'LWCE_XGAbility_Extensions'.static.GetPossibleDamage(self);
}