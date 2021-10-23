class StateObject extends Object
    abstract
    native;

event PostBeginPlay();

simulated event SetInitialState()
{
    GotoState('Auto');
}