class Highlander_XGCharacter_Sectoid extends XGCharacter_Sectoid;

function XComUnitPawn GetPawnArchetype()
{
    return class'Highlander_XGCharacter_Extensions'.static.GetPawnArchetype(self);
}

defaultproperties
{
    m_kUnitPawnClassToSpawn=class'Highlander_XComSectoid'
}