class XGAction_MatineeControlled extends XGAction;
//complete stub

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

function bool Init(XGUnit kUnit){}
event OnAllClientsComplete(){}
simulated function bool CanBePerformed(){}
simulated function bool FindAndUpdateVariableLinkByLinkDesc(out SeqAct_Interp kMatinee, string strDesiredLinkDesc, SeqVar_Object OverrideSeqVar, optional out SeqVar_Object kFoundSeqVarPawn){}
simulated function bool FindAndClearVariableLinkByLinkDesc(out SeqAct_Interp kMatinee, string strDesiredLinkDesc, Object kObjectToClear){}
simulated function bool FindAndSetVisibilityAndBaseByLinkDesc(out SeqAct_Interp kMatinee, string strDesiredLinkDesc, bool bVisible, Actor NewBase){}
simulated function SetUpPawnForMatineeControl(){}
simulated function RestorePawnFromMatineeControl(){}

simulated state Executing{
	simulated event Tick(float fDeltaT){}
}
