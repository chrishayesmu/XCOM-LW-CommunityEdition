class LWCE_XGCharacter_ExaltEliteSniper extends XGCharacter_ExaltEliteSniper implements(LWCE_XGCharacter);

`include(generators_xgcharacter_checkpointrecord.uci)

`GENERATE_CHECKPOINT_STRUCT(XGCharacter_ExaltEliteSniper);

`include(generators_xgcharacter_fields.uci)

`include(generators_xgcharacter_functions.uci)

defaultproperties
{
    m_kUnitPawnClassToSpawn=class'LWCE_XComExalt'
}