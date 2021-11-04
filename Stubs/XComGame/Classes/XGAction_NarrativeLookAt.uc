class XGAction_NarrativeLookAt extends XGAction;

//complete stub
var Vector m_vLookAt;
var XComNarrativeMoment m_kNarrMoment;
var bool bNarrComplete;
var bool bHighPriorityCam;
var name nmOnCompleteRemoteEvent;

function bool Init(XGUnit kUnit, Vector vLoc, XComNarrativeMoment kNarr, bool bPriorityCam, name nmOnCompleteRE){}
simulated function OnNarrativeComplete(){}

simulated state Executing{}

