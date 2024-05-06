class XGAbility_Rift extends XGAbility_GameCore
    native(Core)
    notplaceable
    hidecategories(Navigation);

struct native ExecutionReplicationInfo_XGAbility_Rift
{
    var Vector m_spawnPoint;
};

var protected Vector m_spawnPoint;
var private repnotify ExecutionReplicationInfo_XGAbility_Rift m_kExecutionReplicationInfo_XGAbility_Rift;
var private bool m_bExecutionReplicationInfoReceived_XGAbility_Rift;
var private bool bIsValid;