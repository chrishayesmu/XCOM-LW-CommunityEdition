class XGAIBehavior_Chryssalid extends XGAIBehavior
    notplaceable
    hidecategories(Navigation);
//complete stub

var XGUnit m_kNearestEnemy;

simulated function float GetMinEngageRange()
{
    return 0.0;
}

simulated function PostBuildAbilities()
{
    m_kNearestEnemy = SelectEnemyToEngage();
    super.PostBuildAbilities();
}

simulated function bool HasPredeterminedAbility()
{
    return true;
}

simulated function int GetPredeterminedAbility()
{
    if(IsInMeleeRange())
    {
        return 7;
    }
    return 1;
}

simulated function XGUnit GetPredeterminedTarget()
{
    local XGUnitNativeBase kClosest;

    if(IsInMeleeRange(kClosest))
    {
        m_kNearestEnemy = XGUnit(kClosest);
        return m_kNearestEnemy;
    }
    return none;
}

function XGUnit SelectEnemyToEngage()
{
    local XGUnit kBest;

    if(ShouldAttackCivilians())
    {
        kBest = GetClosestCivilian();
    }
    else
    {
        kBest = GetNearestVisibleEnemy();
    }
    if(kBest == none)
    {
        return super.SelectEnemyToEngage();
    }
    return kBest;
}

defaultproperties
{
    m_fMinAggro=0.60
    m_bCanIgnoreCover=true
    m_bIgnoreOverwatchers=true
    m_fSpacingBuffer=2.0
}