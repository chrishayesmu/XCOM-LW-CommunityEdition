class Highlander_XGCharacter_SectopodDrone extends XGCharacter_SectopodDrone;

function XComUnitPawn GetPawnArchetype()
{
    return class'Highlander_XGCharacter_Extensions'.static.GetPawnArchetype(self);
}

defaultproperties
{
    m_kUnitPawnClassToSpawn=class'Highlander_XComSectopodDrone'
}