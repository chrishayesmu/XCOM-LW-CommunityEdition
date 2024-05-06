class XGAIBehavior_Elder extends XGAIBehavior_Psi
    notplaceable
    hidecategories(Navigation);

const MAX_PATHING_CAP = 8;

var array<XGUnit> m_arrGuards;
var XGUnit m_kDrainTarget;
var array<XGUnit> m_arrThreats;

defaultproperties
{
    m_bCanIgnoreCover=true
    m_bHasSquadSightAbility=true
}