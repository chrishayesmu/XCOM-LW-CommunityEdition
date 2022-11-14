class LWCE_XGCharacter_SectopodDrone extends XGCharacter_SectopodDrone implements(LWCE_XGCharacter);

`include(generators_xgcharacter_fields.uci)

`include(generators_xgcharacter_functions.uci)

defaultproperties
{
    m_kUnitPawnClassToSpawn=class'LWCE_XComSectopodDrone'
}