class XGTactic_Hunt extends XGTactic
    notplaceable
    hidecategories(Navigation);

struct CheckpointRecord_XGTactic_Hunt extends CheckpointRecord
{
    var XGHuntTarget m_kTarget;
};

var XGHuntTarget m_kTarget;

defaultproperties
{
    m_strName="HUNT"
}