class XGAIBehavior_Exalt extends XGAIBehavior
    notplaceable
    hidecategories(Navigation);
//complete stub

const HEAL_RANGE_LOCATION_BUMP = 2000;
const HEAL_RANGE_PROXIMITY_BUMP = 1000;
const MAX_CAPTURE_POINT_DIRECTION_BONUS = 1500;
const MAX_CAPTURE_POINT_DISTANCE_TILES = 7;

var heal_option m_kPriorityAssignment;

simulated function int ScoreLocation(ai_cover_score kScore, float fDistance)
{
    local Vector vToCapturePoint, vToTestLoc, vTestLoc;
    local int iBonus;
    local float fDot, fBonusPercentage;

    iBonus = super.ScoreLocation(kScore, fDistance);
    if(!m_bCapper && m_kPlayer.m_kPriorityVolume != none)
    {
        vTestLoc = kScore.vLoc;
        vTestLoc.Z += 96.0;
        if(IsInsidePriorityVolume(vTestLoc))
        {
            iBonus = 1500;
        }
        else
        {
            vToCapturePoint = m_kPlayer.m_kPriorityVolume.Location - m_kUnit.GetPawn().Location;
            vToTestLoc = vTestLoc - m_kUnit.GetPawn().Location;
            fDot = Normal(vToCapturePoint) Dot Normal(vToTestLoc);
            if(fDot > float(0))
            {
                fBonusPercentage = FMin(1.0, VSize(vToTestLoc) / (float(7) * 96.0));
                fBonusPercentage *= fDot;
                iBonus += int(float(1500) * fBonusPercentage);
            }
        }
    }
    return iBonus;
}