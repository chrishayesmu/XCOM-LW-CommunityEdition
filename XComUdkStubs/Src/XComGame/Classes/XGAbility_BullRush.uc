class XGAbility_BullRush extends XGAbility_Targeted
    native(Core)
    notplaceable
    hidecategories(Navigation);

struct native ExecutionReplicationInfo_XGAbility_BullRush
{
    var int m_iDamage;
    var XGUnit m_kUnitTarget;
    var bool m_bUnitTargetNone;
    var Actor m_kWall;
    var bool m_bWallNone;
    var Vector m_vDestination;
    var bool m_bValidDestination;
    var bool m_bForceReplicate;
};

var Vector m_vDestination;
var Actor m_kWall;
var privatewrite int m_iDamage;
var privatewrite XGUnit m_kUnitTarget;
var bool m_bValidDestination;
var private bool m_bExecutionReplicationInfoReceived_XGAbility_BullRush;
var private repnotify repretry ExecutionReplicationInfo_XGAbility_BullRush m_kExecutionReplicationInfo_XGAbility_BullRush;