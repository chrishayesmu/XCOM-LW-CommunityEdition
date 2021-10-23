class WatchVariable extends Object
    native;
//complete stub

struct native WatchPointer
{
    var Pointer WatchAddr;
    var int BitMask;
};

struct native WatchCallback
{
    var Function CallbackFunction;
    var Object CallbackOwner;
};

var Object WatchOwner;
var Object CallbackOwner;
var bool Enabled;
var native const bool IsFunction;
var native const Property Watch;
var native const int WatchPrevCRC;
var native const WatchPointer PropertyValueAddress;
var native const int BitMask;
var native const Pointer CallbackAddr;
var native const int WatchGroupHandle;
var native const int ArrayIndex;
var native const name WatchName;
var delegate<WatchVariableCallback> CallbackFn;
var delegate<WatchVariableCallback> WatchVariableCallback__Delegate;

delegate WatchVariableCallback();

