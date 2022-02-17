class Highlander_XGAbility_Launch extends XGAbility_Launch;

function CalcDamage()
{
    class'Highlander_XGAbility_Extensions'.static.CalcDamage(self);
}

simulated function int GetPossibleDamage()
{
    return class'Highlander_XGAbility_Extensions'.static.GetPossibleDamage(self);
}