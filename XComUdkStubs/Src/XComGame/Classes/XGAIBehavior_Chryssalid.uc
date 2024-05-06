class XGAIBehavior_Chryssalid extends XGAIBehavior
    notplaceable
    hidecategories(Navigation);

var XGUnit m_kNearestEnemy;

defaultproperties
{
    m_fMinAggro=0.60
    m_bCanIgnoreCover=true
    m_bIgnoreOverwatchers=true
    m_fSpacingBuffer=2.0
}