class XGAIBehavior_Mechtoid extends XGAIBehavior
    notplaceable
    hidecategories(Navigation);

var XGUnit m_kLastTarget;
var bool m_bForceMoveCloser;

defaultproperties
{
    m_bShouldIgnoreCover=true
    m_bCanIgnoreCover=true
}