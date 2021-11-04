class XGAIBehavior_Zombie extends XGAIBehavior
    notplaceable
    hidecategories(Navigation);
//complete stub

var XGUnit m_kNearestEnemy;
simulated function bool IgnoresActiveList(){}
simulated function XGUnit SelectEnemyToEngage(){}
simulated function MeleeAttackPositionUnavailableHandler(out Vector vDest_Out){}
simulated function bool FindRunawayPosition(out Vector vLocation, XGUnit kEnemy, optional out Vector vDirToEnemy, optional float fMetersFromEdge, optional out string strFail){}
simulated function bool IsAnyGrenadeVisible(Vector vLoc, optional out float fOutDistSq, optional out XComProjectile_FragGrenade kNearest){}
simulated function PostBuildAbilities(){}
simulated function bool HasPredeterminedAbility(){}
simulated function int GetPredeterminedAbility(){}
simulated function XGUnit GetPredeterminedTarget(){}

state TacticalMove
{
    simulated function Vector DecideNextDestination(optional out string strFail)
    {
        local array<XComCoverPoint> arrCoverPoints;
        local Vector vDestination;

        strFail @= "ZOMBIE-TACTICALMOVE";
        m_bMoveToActionPoint = true;
        if((GetNearestValidPathablePointToMeleeRange(m_kAttackTarget, vDestination)) || IsValidPathDestination(vDestination))
        {
            strFail @= "GNVPPPTMR";
            return vDestination;
        }
        if(GetScoredCoverDestination(vDestination, true))
        {
            strFail @= "GTTD";
            return vDestination;
        }
        else
        {
            arrCoverPoints = GetValidDestinations(true);
            if(m_kUnit.GetBestDestination(vDestination,, BaseValidator,, arrCoverPoints, m_bCanIgnoreCover, strFail))
            {
                return vDestination;
            }
            else
            {
                SwitchToAttack(strFail);
            }
        }
        return vDestination;
    }
}