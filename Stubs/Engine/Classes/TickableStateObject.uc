class TickableStateObject extends StateObject
    abstract
    native;

var private native const noexport Pointer VfTable_FTickableObject;
var() bool bTickWhenGamePaused;
var const array<TimerData> Timers;

// Export UTickableStateObject::execSetTimer(FFrame&, void* const)
native final function SetTimer(float InRate, optional bool inbLoop, optional name inTimerFunc, optional Object inObj);

// Export UTickableStateObject::execClearTimer(FFrame&, void* const)
native final function ClearTimer(optional name inTimerFunc, optional Object inObj);

// Export UTickableStateObject::execPauseTimer(FFrame&, void* const)
native final function PauseTimer(bool bPause, optional name inTimerFunc, optional Object inObj);

// Export UTickableStateObject::execIsTimerActive(FFrame&, void* const)
native final function bool IsTimerActive(optional name inTimerFunc, optional Object inObj);

event Tick(float DeltaTime);