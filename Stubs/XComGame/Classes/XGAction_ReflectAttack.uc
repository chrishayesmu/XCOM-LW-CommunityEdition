class XGAction_ReflectAttack extends XGAction_FireImmediate
    notplaceable
    hidecategories(Navigation);
//complete stub

var int m_iReflectedDamage;

simulated function int CalcDamage(){}

simulated state ShutDownToIdle
{
    simulated function bool AllowShutDownToIdle(){}
}
