class XGTactic_Hunt extends XGTactic
    notplaceable
    hidecategories(Navigation);
//complete stub

struct CheckpointRecord_XGTactic_Hunt extends CheckpointRecord
{
    var XGHuntTarget m_kTarget;
};

var XGHuntTarget m_kTarget;

function InitHunt(XGPod kPod, EPodTactic eTactic, XGHuntTarget kTarget){}
function ChooseHuntPath(){}
function Vector ChooseScoutingLoc(Vector vTargetLoc){}
function DirectHunt(){}
function FlankHunt(){}
function WideHunt(){}
function CallTheHunt(){}
function EPodAnimation GetPodAnim(){}

defaultproperties
{
    m_strName="HUNT"
}