class XGAIBehavior_SectopodDrone extends XGAIBehavior_FlyingUnit
    notplaceable
    hidecategories(Navigation);
//complete stub

enum EDroneMode
{
    eDM_Repair,
    eDM_Attack,
    eDM_Overload,
    eDM_Scout,
    eDM_Escort,
    eDM_None,
    eDM_MAX
};

struct CheckpointRecord_XGAIBehavior_SectopodDrone extends CheckpointRecord
{
    var XGUnit m_kRepairTarget;
};

var XGUnit m_kRepairTarget;
var EDroneMode m_eDroneMode;

simulated function int GetMaxFlightDuration(){}
function float GetReasonableAttackRange(){}
simulated function InitPod(int iPod, optional bool bActive){}
simulated function InitTurn(){}
simulated function UpdateDroneMode(){}
simulated function PreBuildAbilities(){}
simulated function bool HasCustomAbilityValidityCheck(){}
simulated function bool IsAbilityValid(XGAbility kAbility){}
simulated function int ScoreLocation(ai_cover_score kScore, float fDistance){}
function bool HasCustomMoveOption(){}
function EnterCustomMoveState(){}
simulated function bool HasPredeterminedAbility(){}
simulated function int GetPredeterminedAbility(){}
simulated function XGUnit GetPredeterminedTarget(){}
simulated function InitPredeterminedAbility(XGAbility kAbility);

state RepairMove extends MoveState
{
    function Vector DecideNextDestination(optional out string strFail)
    {
        local Vector vDestination;

        if((GetNearestValidPathablePointToMeleeRange(m_kRepairTarget, vDestination)) || IsValidPathDestination(vDestination))
        {
            return vDestination;
        }
        vDestination = FindValidPathDestinationToward(m_kRepairTarget.GetLocation(),,,, strFail);
        return vDestination;
    }   
}