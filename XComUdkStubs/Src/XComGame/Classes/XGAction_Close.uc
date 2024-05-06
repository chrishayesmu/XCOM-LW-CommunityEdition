class XGAction_Close extends XGAction
    notplaceable
    hidecategories(Navigation);

struct native InitialReplicationData_XGAction_Close
{
    var bool m_bOpen;
    var bool m_bForceReplicate;
};

var bool m_bOpen;
var private bool m_bInitialReplicationDataReceived_XGAction_Close;
var private repnotify InitialReplicationData_XGAction_Close m_kInitialReplicationData_XGAction_Close;
var transient AnimNodeSequence m_TmpNode;

defaultproperties
{
    m_bBlocksInput=true
}