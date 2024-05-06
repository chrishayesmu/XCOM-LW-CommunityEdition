class XGAction_SeeEnemy extends XGAction
    notplaceable
    hidecategories(Navigation);

var protected XGUnit m_kEnemy;
var protected XGCameraView m_kSavedView;
var protected XGCameraView m_kEnemyView;
var protected XGCameraView_Cinematic m_kRevealView;
var protected int m_iPrevEnemyMovementIndex;

defaultproperties
{
    m_bBlocksInput=true
    m_bConstantCombat=true
    m_bShouldUpdateOvermind=true
}