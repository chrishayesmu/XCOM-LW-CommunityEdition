class XGAction_Berserk extends XGAction
    notplaceable
    hidecategories(Navigation);

struct InitialReplicationData_XGAction_Berserk
{
    var XGUnit m_kIntimidateTarget;
    var bool m_bIntimidateTargetNone;
};

var transient AnimNodeSequence tmpAnimSequence;
var bool m_bGlamCamActive;
var private bool m_bInitialReplicationDataReceived_XGAction_Berserk;
var XGUnit m_kIntimidateTarget;
var private repnotify repretry InitialReplicationData_XGAction_Berserk m_kInitialReplicationData_XGAction_Berserk;