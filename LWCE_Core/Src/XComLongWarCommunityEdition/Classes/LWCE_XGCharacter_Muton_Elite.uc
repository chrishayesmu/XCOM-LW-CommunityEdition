class LWCE_XGCharacter_Muton_Elite extends XGCharacter_Muton_Elite implements(LWCE_XGCharacter);

`include(generators_xgcharacter_checkpointrecord.uci)

`GENERATE_CHECKPOINT_STRUCT(XGCharacter_Muton_Elite);

`include(generators_xgcharacter_fields.uci)

`include(generators_xgcharacter_functions.uci)

defaultproperties
{
    m_kUnitPawnClassToSpawn=class'LWCE_XComMuton'
}