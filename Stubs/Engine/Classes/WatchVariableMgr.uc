class WatchVariableMgr extends Actor
    native
    notplaceable
    hidecategories(Navigation);
//complete stub
var private native const noexport Pointer VfTable_FTickableObject;
var array<WatchVariable> WatchVariables;
var bool bInWatchVariableUpdate;
var init array<init WatchVariable> WatchVariablesToRemove;

delegate WatchVariableCallback();

native function int RegisterWatchVariable(Object kWatchVarOwner, name kWatchName, Object kCallbackOwner, delegate<WatchVariableCallback> CallbackFn, optional int ArrayIndex);
native function int RegisterWatchVariableStructMember(Object kWatchVarOwner, name kStructName, name kWatchName, Object kCallbackOwner, delegate<WatchVariableCallback> CallbackFn, optional int ArrayIndex);
native function UnRegisterWatchVariable(int Handle);
native function EnableDisableWatchVariable(int Handle, bool Enable);
native function bool IsHandleValid(int Handle);