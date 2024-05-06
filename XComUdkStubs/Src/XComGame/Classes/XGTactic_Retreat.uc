class XGTactic_Retreat extends XGTactic
    notplaceable
    hidecategories(Navigation);

struct CheckpointRecord_XGTactic_Retreat extends CheckpointRecord
{
    var XGPod m_kAlly;
};

var XGPod m_kAlly;

defaultproperties
{
    m_strName="RETREAT"
}