class Highlander_XGAbility_OneForAll extends XGAbility_OneForAll;

function CalcDamage()
{
    class'Highlander_XGAbility_Extensions'.static.CalcDamage(self);
}

simulated function int GetPossibleDamage()
{
    return class'Highlander_XGAbility_Extensions'.static.GetPossibleDamage(self);
}