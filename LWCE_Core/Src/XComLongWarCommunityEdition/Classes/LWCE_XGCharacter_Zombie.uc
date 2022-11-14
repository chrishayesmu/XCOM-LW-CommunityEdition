class LWCE_XGCharacter_Zombie extends XGCharacter_Zombie implements(LWCE_XGCharacter);

`include(generators_xgcharacter_fields.uci)

`include(generators_xgcharacter_functions.uci)

defaultproperties
{
    m_kUnitPawnClassToSpawn=class'LWCE_XComZombie'
}