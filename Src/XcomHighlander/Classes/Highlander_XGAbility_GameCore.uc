class Highlander_XGAbility_GameCore extends XGAbility_GameCore;

function CalcDamage()
{
    class'Highlander_XGAbility_Extensions'.static.CalcDamage(self);
}

simulated function int GetPossibleDamage()
{
    return class'Highlander_XGAbility_Extensions'.static.GetPossibleDamage(self);
}