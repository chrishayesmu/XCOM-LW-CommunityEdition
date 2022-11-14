class LWCE_XGCharacter_Sectoid_Commander extends XGCharacter_Sectoid_Commander implements(LWCE_XGCharacter);

`include(generators_xgcharacter_fields.uci)

`include(generators_xgcharacter_functions.uci)

defaultproperties
{
    m_kUnitPawnClassToSpawn=class'LWCE_XComSectoid'
}