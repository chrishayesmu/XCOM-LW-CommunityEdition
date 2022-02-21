class LWCE_XGCharacter_Sectoid extends XGCharacter_Sectoid;

function XComUnitPawn GetPawnArchetype()
{
    return class'LWCE_XGCharacter_Extensions'.static.GetPawnArchetype(self);
}

defaultproperties
{
    m_kUnitPawnClassToSpawn=class'LWCE_XComSectoid'
}