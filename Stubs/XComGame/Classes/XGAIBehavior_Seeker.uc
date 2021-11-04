class XGAIBehavior_Seeker extends XGAIBehavior_FlyingUnit
    notplaceable
    hidecategories(Navigation);
//complete stub

const FORCE_DESTEALTH_TURN_COUNT = 5;

struct CheckpointRecord_XGAIBehavior_Seeker extends CheckpointRecord
{
    var XGUnit m_kStrangleTarget;
    var bool m_bTookStrangleDamage;
};

var XGUnit m_kStrangleTarget;
var bool m_bTookStrangleDamage;

simulated function int GetMaxFlightDuration(){}
simulated function bool IsGrounded(){}
simulated function bool CanFly(){}
simulated function OnTakeDamage(int iDamage, class<DamageType> DamageType){}
simulated function int ScoreLocation(ai_cover_score kScore, float fDistance){}
simulated function OnUnitEndTurn(){}
function bool HasCustomMoveOption(){}
function EnterCustomMoveState(){}
simulated function bool HasValidManeuver(){}
simulated function bool HasPredeterminedAbility(){}
function bool ShouldStealth(){}
function bool CanStealth(){}
simulated function int GetPredeterminedAbility(){}
function UpdateTurnsUnseen(){}
simulated function XGUnit GetPredeterminedTarget(){}
simulated function InitPredeterminedAbility(XGAbility kAbility){}
function ExecuteAbility(){}
simulated function OnDeath(XGUnit kKiller){}

state StrangleMove extends MoveState
{
    function Vector DecideNextDestination(optional out string strFail)
    {
        local Vector vDestination;

        if((GetNearestValidPathablePointToMeleeRange(m_kStrangleTarget, vDestination)) || IsValidPathDestination(vDestination))
        {
            return vDestination;
        }
        vDestination = FindValidPathDestinationToward(m_kStrangleTarget.GetLocation(),,,, strFail);
        return vDestination;
    }
}

state GenericAbility
{
    simulated function bool IsActionComplete(string kHangDebug)
    {
    }
      
}