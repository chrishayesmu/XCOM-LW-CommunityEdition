class XGAIBehavior_Floater extends XGAIBehavior_FlyingUnit
    notplaceable
    hidecategories(Navigation);

const MIN_TURNS_TO_LAUNCH = 2;

var Vector m_vEngagePos;
var int m_iLastLaunched;

defaultproperties
{
    m_iLastLaunched=-999
    m_fMinAggro=0.50
    m_bShouldIgnoreCover=false
}