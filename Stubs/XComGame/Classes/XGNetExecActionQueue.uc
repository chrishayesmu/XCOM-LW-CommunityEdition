class XGNetExecActionQueue extends Info
    native(Action)
    nativereplication
    hidecategories(Navigation,Movement,Collision);
//complete stub

struct native TNetExecActionQueueNode
{
    var XGAction m_kNextExecAction;
    var bool m_bNextExecActionNone;
    var int m_iExecutionOrderID;
};

var repnotify XGAction m_kHead;
var repnotify XGAction m_kTail;
var private repnotify XGUnitNativeBase m_kUnit;

simulated event ReplicatedEvent(name VarName){}
final simulated event string ToString(){}
static final event string NetExecActionQueue_Action_ToString(XGAction kAction){}
native final function ProcessQueue();
final function SetUnit(XGUnitNativeBase kUnit){}
final simulated function XGUnitNativeBase GetUnit(){}
final simulated function bool IsIdle(bool bCountPathActionsAsIdle){}
final simulated function XGAction GetFront(){}
final simulated event bool IsActionInQueue(XGAction kAction){}
final simulated event bool IsActionOfClassInQueue(class<XGAction> kActionClass, optional out XGAction kAction){}
simulated function bool IsActionExecuting(XGAction kAction){}
native final simulated function bool IsEmpty();
native final simulated function bool IsActionWithClassNameInQueue(name kActionClassName, optional out XGAction kAction);
native final function ExecuteAction(XGAction kNewAction, XGAction kCurrAction);
native final function DecRefActionForPlayer(XGAction kAction, XComTacticalController kPlayerController);
private native final function int NextExecutionOrderID();
