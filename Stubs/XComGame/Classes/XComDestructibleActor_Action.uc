class XComDestructibleActor_Action extends Object within XComDestructibleActor
    abstract
    native(Destruction)
    editinlinenew
    collapsecategories
    hidecategories(Object);
//complete stub

var() bool bEnabled;
var transient bool bActivated;

// Export UXComDestructibleActor_Action::execActivate(FFrame&, void* const)
native function Activate();

// Export UXComDestructibleActor_Action::execDeactivate(FFrame&, void* const)
native function Deactivate();

// Export UXComDestructibleActor_Action::execTick(FFrame&, void* const)
native function Tick(float DeltaTime);

// Export UXComDestructibleActor_Action::execLoad(FFrame&, void* const)
native function Load(float InTimeInState);
