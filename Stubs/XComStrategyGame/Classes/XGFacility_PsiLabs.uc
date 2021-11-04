class XGFacility_PsiLabs extends XGFacility
    config(GameData)
    notplaceable
    hidecategories(Navigation);

struct TPsiTrainee
{
    var XGStrategySoldier kSoldier;
    var int iHoursLeft;
    var int bPsiGift;
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

function Update(){}
function int RollForGift(XGStrategySoldier kSoldier){}
function int SortPsiCandidates(XGStrategySoldier kSoldier1, XGStrategySoldier kSoldier2){}
function AddSoldier(XGStrategySoldier kSoldier, int iSlot){}
function bool IsSlotOccupied(int iSlot){}
function bool ClearSlot(int iSlot){}
function RemoveSoldier(XGStrategySoldier kSoldier){}
function DetermineGift(int iTrainee){}
function string RecordSoldierHasGift(XGStrategySoldier GiftedSoldier){}
function SendSoldierToPsiCinematic(){}
function SubjectZeroCinematic(){}
function PsiCinematicComplete(){}
function GetEvents(out array<THQEvent> arrEvents){}
state WaitingToStartPsiCinematic{}


