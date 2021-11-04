class XGAIBehavior_Floater extends XGAIBehavior_FlyingUnit
    notplaceable
    hidecategories(Navigation);
//complete stub

const MIN_TURNS_TO_LAUNCH = 2;

var Vector m_vEngagePos;
var int m_iLastLaunched;

function bool CanLaunch(){}
simulated function bool HasRecentlyLaunched(){}
simulated function MarkLaunched(){}
simulated function int GetMaxFlightDuration(){}
function bool HasCustomMoveOption(){}
function EnterCustomMoveState(){}
simulated function bool HasPredeterminedAbility(){}
simulated function int GetPredeterminedAbility(){}
simulated function XGUnit GetPredeterminedTarget(){}
simulated function bool IsValidLaunchToLoc(Vector vLaunchTo){}
simulated function bool FindLaunchToPositionNearIsolatedEnemy(out Vector vLaunchTo_Out){}
simulated state WaitingForTick{}

state Engage
{
    simulated function bool FloaterCoverValidator_Engage(Vector vCoverLoc)
    {
        if(EncroachCoverValidator(vCoverLoc))
        {
            if(VSizeSq2D(vCoverLoc - m_vEngagePos) < Square(5.0 * float(64)))
            {
                return true;
            }
        }
        return false;
    }

    simulated function Vector DecideNextDestination(optional out string strFail)
    {
        local Vector vLoc, vCoverLoc;

        strFail @= "FLOATER dnd";
        vLoc = m_kUnit.GetLocation();
        m_kAttackTarget = SelectEnemyToEngage();
        if(m_kAttackTarget != none)
        {
            m_vEngagePos = FindFiringPosition(m_kAttackTarget);
            if(m_kUnit.GetBestDestination(vCoverLoc,, FloaterCoverValidator_Engage,,, m_bCanIgnoreCover, strFail))
            {
                return vCoverLoc;
            }
            strFail @= ("Found firing position against" @ string(m_kAttackTarget));
            return m_vEngagePos;
        }
        strFail @= "No attack target found!";
        SwitchToAttack(strFail);
        return vLoc;
    }  
}

state Launch
{
    simulated event BeginState(name P);

    simulated event EndState(name N)
    {
        m_kLastAIState = name("Launch");
    }

    simulated function bool InitLaunchState()
    {
    }
}

