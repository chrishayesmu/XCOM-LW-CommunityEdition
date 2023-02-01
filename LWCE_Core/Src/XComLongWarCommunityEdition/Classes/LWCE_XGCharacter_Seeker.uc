class LWCE_XGCharacter_Seeker extends XGCharacter_Seeker implements(LWCE_XGCharacter);

`include(generators_xgcharacter_checkpointrecord.uci)

`GENERATE_CHECKPOINT_STRUCT(XGCharacter_Seeker);

`include(generators_xgcharacter_fields.uci)

`include(generators_xgcharacter_functions.uci)

defaultproperties
{
    m_kUnitPawnClassToSpawn=class'LWCE_XComSeeker'
}