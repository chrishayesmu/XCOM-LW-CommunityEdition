class XGAIBehavior_SectoidCommander extends XGAIBehavior_Sectoid
    notplaceable
    hidecategories(Navigation);
//complete stub

simulated function float GetMaxEngageRange(){}
simulated function float GetMinEngageRange(){}
simulated function PostEquipInit(){}
function bool ShouldKeepHidden(){}
simulated function InitTurn(){}
simulated function PodRevealPreMoveInit(){}
function bool HasCustomMoveOption(){}
function bool PrefersLowCover(){}
function EnterCustomMoveState(){}

state KeepYourDistance extends MoveState
{
    function Vector DecideNextDestination(optional out string strFail)
    {
        local Vector vDest;
        local XGUnit kEnemy;

        if(m_kTargetToView != none)
        {
            kEnemy = m_kTargetToView;
        }
        else
        {
            kEnemy = GetNearestVisibleEnemy(true);
        }
        if(m_kUnit.m_arrVisibleEnemies.Length > 1)
        {
            GetFleeLocation(vDest, kEnemy);
        }
        else
        {
            GetEngageLocation(vDest, kEnemy);
        }
        return vDest;
    }   
}