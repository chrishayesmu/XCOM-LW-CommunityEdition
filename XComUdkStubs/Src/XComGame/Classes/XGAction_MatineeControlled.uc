class XGAction_MatineeControlled extends XGAction
    notplaceable
    hidecategories(Navigation);

var transient SeqVar_Object SeqVarPawn;
var string m_VariableLinkName;
var bool m_bRemainInAnimControlForDeath;
var bool m_bCollideWorld;
var bool m_bCollideActors;
var bool m_bBlockActors;
var bool m_bIgnoreEncroachers;
var transient bool m_bHasSetUpPawnForMatinee;
var Vector m_PrevLocation;
var float WaitTimer;

defaultproperties
{
    m_bModal=false
}