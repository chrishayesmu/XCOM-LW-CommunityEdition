class XGActionQueue extends Actor
    native(Action);
//complete stub

var array<XGAction> m_arrActions;
var array<string> m_arrActionLogging;

function ResetMultiActionLogging(){}
function PerformMultiActionLogging(XGAction kAction){}
function bool Add(XGAction kAction){}
function LogActions(){}
function string ToString(){}
function RemoveFront(){}
function RemoveBack(){}
function TerminateActions(){}
function Clear(optional bool bForceDestroy, optional bool bLeaveFront){}
function DestroyAction(XGAction kAction, optional bool bForceDestroy){}
function int GetCount(){}
function XGAction GetFront(){}
function XGAction GetBack(){}
function XGAction PeekNext(){}
function XGAction GetSpecificAction(int I){}
native final function bool Contains(name ClassName, optional out XGAction kAction);
function bool NextActionIs(name ClassName){}
event Destroyed(){}

