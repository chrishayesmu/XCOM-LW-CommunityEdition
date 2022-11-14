class LWCE_XGCharacter_Chryssalid extends XGCharacter_Chryssalid implements(LWCE_XGCharacter);

`include(generators_xgcharacter_fields.uci)

`include(generators_xgcharacter_functions.uci)

defaultproperties
{
    m_kUnitPawnClassToSpawn=class'LWCE_XComChryssalid'
}