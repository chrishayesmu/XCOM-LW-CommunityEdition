class XGAction_Strangle extends XGAction
    notplaceable
    hidecategories(Navigation);

struct InitialReplicationData_XGAction_Strangle
{
    var XGUnit m_kTarget;
    var XGAbility_Targeted m_kAbility;
};

var private XGUnit m_kTarget;
var private Vector m_vAttackDir;
var private XGAbility_Targeted m_kAbility;
var private Vector m_vLookAt;
var privatewrite repnotify repretry InitialReplicationData_XGAction_Strangle m_kInitialReplicationData_XGAction_Strangle;
var privatewrite bool m_bInitialReplicationDataReceived_XGAction_Strangle;