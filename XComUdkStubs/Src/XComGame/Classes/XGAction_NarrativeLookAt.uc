class XGAction_NarrativeLookAt extends XGAction
    notplaceable
    hidecategories(Navigation);

var Vector m_vLookAt;
var XComNarrativeMoment m_kNarrMoment;
var bool bNarrComplete;
var bool bHighPriorityCam;
var name nmOnCompleteRemoteEvent;

defaultproperties
{
    m_bBlocksInput=true
}