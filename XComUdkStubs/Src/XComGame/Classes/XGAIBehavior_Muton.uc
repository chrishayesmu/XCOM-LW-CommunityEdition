class XGAIBehavior_Muton extends XGAIBehavior
    notplaceable
    hidecategories(Navigation);

var XGAbility_Targeted m_kPDAbility;

defaultproperties
{
    m_fMinAggro=0.60
    m_bCanIgnoreCover=true
    m_iMaxWeaponStrengthIgnoreCover=2
    m_fFlankWeight=1.50
    m_fAngleWeight=1.50
    m_fVisWeight=0.50
}