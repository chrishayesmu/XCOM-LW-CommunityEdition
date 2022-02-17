class Highlander_XGAbility_ShredderRocket extends XGAbility_ShredderRocket;

function CalcDamage()
{
    class'Highlander_XGAbility_Extensions'.static.CalcDamage(self);
}

simulated function int GetPossibleDamage()
{
    return class'Highlander_XGAbility_Extensions'.static.GetPossibleDamage(self);
}