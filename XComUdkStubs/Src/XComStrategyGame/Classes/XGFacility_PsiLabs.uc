/*******************************************************************************
 * XGFacility_PsiLabs generated by Eliot.UELib using UE Explorer.
 * Eliot.UELib ? 2009-2015 Eliot van Uytfanghe. All rights reserved.
 * http://eliotvu.com
 *
 * All rights belong to their respective owners.
 *******************************************************************************/
class XGFacility_PsiLabs extends XGFacility
    config(GameData)
    notplaceable
    hidecategories(Navigation);

struct TPsiTrainee
{
    var XGStrategySoldier kSoldier;
    var int iHoursLeft;
    var int bPsiGift;

    structdefaultproperties
    {
        kSoldier=none
        iHoursLeft=0
        bPsiGift=0
    }
};

struct CheckpointRecord_XGFacility_PsiLabs extends CheckpointRecord
{
    var array<TPsiTrainee> m_arrTraining;
    var array<TPsiTrainee> m_arrCompleted;
    var int m_iNumTested;
    var int m_iNumGifted;
    var bool m_bFoundFirst;
    var bool m_bSubjectZeroCinematic;
    var bool m_bAnnouncedResults;
};

var array<TPsiTrainee> m_arrTraining;
var array<TPsiTrainee> m_arrCompleted;
var int m_iNumTested;
var int m_iNumGifted;
var bool m_bFoundFirst;
var bool m_bSubjectZeroCinematic;
var bool m_bAnnouncedResults;
var transient XGStrategySoldier PsiCinematicSoldier;
var transient PhysicsAsset m_kPsiPhysicsAsset;