class Highlander_XGAbility_Rift extends XGAbility_Rift;

function CalcDamage()
{
    class'Highlander_XGAbility_Extensions'.static.CalcDamage(self);
}

simulated function int GetPossibleDamage()
{
    return class'Highlander_XGAbility_Extensions'.static.GetPossibleDamage(self);
}