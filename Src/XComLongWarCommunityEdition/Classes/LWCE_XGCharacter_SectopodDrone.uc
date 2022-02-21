class LWCE_XGCharacter_SectopodDrone extends XGCharacter_SectopodDrone;

function XComUnitPawn GetPawnArchetype()
{
    return class'LWCE_XGCharacter_Extensions'.static.GetPawnArchetype(self);
}

defaultproperties
{
    m_kUnitPawnClassToSpawn=class'LWCE_XComSectopodDrone'
}