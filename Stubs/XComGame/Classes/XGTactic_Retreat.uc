class XGTactic_Retreat extends XGTactic
    notplaceable
    hidecategories(Navigation);
//complete stub

struct CheckpointRecord_XGTactic_Retreat extends CheckpointRecord
{
    var XGPod m_kAlly;
};

var XGPod m_kAlly;

function InitRetreat(XGPod kPod, XGPod kAllyPod){}
function Retreat(){}
function Vector GetRetreatVector(){}
function Vector GetFallbackPoint(){}

defaultproperties
{
    m_strName="RETREAT"
}