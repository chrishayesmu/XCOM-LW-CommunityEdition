class DelayedOverwatch extends Actor;
//complete stub

var array<XGUnit> m_arrUnitsTriggeringOverwatch;

simulated function Init(array<XGUnit> arrUnitsTriggeringOverwatch){}
function DoOverwatchAgainstUnit(XGUnit kUnit){}

simulated state TriggerOverwatch{
    simulated event Tick(float fDelta){}
}
