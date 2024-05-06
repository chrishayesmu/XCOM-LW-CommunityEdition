class XGAIBehavior_Sectopod extends XGAIBehavior
    notplaceable
    hidecategories(Navigation);

var bool m_bHasAoETarget;
var bool m_bTargetSet;

defaultproperties
{
    m_fMinAggro=0.80
    m_bShouldIgnoreCover=true
    m_bCanIgnoreCover=true
    m_bIgnoreOverwatchers=true
    m_bHasSquadSightAbility=true
}