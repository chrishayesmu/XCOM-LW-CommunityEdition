class XGNetExecActionQueue extends Info
    native(Action)
    nativereplication
    hidecategories(Navigation,Movement,Collision);

struct native TNetExecActionQueueNode
{
    var XGAction m_kNextExecAction;
    var bool m_bNextExecActionNone;
    var int m_iExecutionOrderID;
};

var privatewrite repnotify XGAction m_kHead;
var privatewrite repnotify XGAction m_kTail;
var private repnotify XGUnitNativeBase m_kUnit;

defaultproperties
{
    RemoteRole=ROLE_SimulatedProxy
    m_bReplicateHidden=false
    bAlwaysRelevant=true
    bReplicateMovement=false
}