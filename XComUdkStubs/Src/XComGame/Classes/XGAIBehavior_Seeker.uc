class XGAIBehavior_Seeker extends XGAIBehavior_FlyingUnit
    notplaceable
    hidecategories(Navigation);

const FORCE_DESTEALTH_TURN_COUNT = 5;

struct CheckpointRecord_XGAIBehavior_Seeker extends CheckpointRecord
{
    var XGUnit m_kStrangleTarget;
    var bool m_bTookStrangleDamage;
};

var XGUnit m_kStrangleTarget;
var bool m_bTookStrangleDamage;

defaultproperties
{
    m_fMinAggro=0.80
}