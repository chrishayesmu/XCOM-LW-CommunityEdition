class XGFacility_GeneLabs extends XGFacility
    config(GameData)
    notplaceable
    hidecategories(Navigation);

struct TGeneLabsPatient
{
    var XGStrategySoldier m_kSoldier;
    var array<int> m_arrHoursLeft;
    var array<EPerkType> m_arrPendingGeneMods;

};

struct CheckpointRecord_XGFacility_GeneLabs extends CheckpointRecord
{
    var array<TGeneLabsPatient> m_arrPatients;
};

var const localized string m_strCompletionDialogText;
var array<TGeneLabsPatient> m_arrPatients;
var bool m_bDoingFirstNarrative;
var bool m_bIsPlayingCinematic;
var transient XGStrategySoldier GeneModCinematicSoldier;
var transient XComNarrativeMoment PendingNarrativeMoment;
var transient PhysicsAsset GeneModCinematicPhysics;

function Update(){}
function bool AddSoldierToGeneLabs(XGStrategySoldier kSoldier, array<EGeneModTech> arrGeneTech){}
function string RecordSoldierEnteredGeneLabs(XGStrategySoldier Soldier, array<EGeneModTech> arrGeneTech){}
function bool IsSlotOccupied(int iSlot){}
function bool RemoveSoldierFromGeneLabs(XGStrategySoldier kSoldier){}
function GetEvents(out array<THQEvent> arrEvents){}
function bool HasGeneModTechAvailableBeyondMeld(){}
function bool IsGeneModTechAvailable(EGeneModTech eTech){}
function bool CanAffordGeneMod(EGeneModTech eTech){}
function bool CanAffordGeneMods(array<EGeneModTech> arrTech){}
function bool AlreadyHasGeneMod(XGStrategySoldier kSoldier, EGeneModTech GeneTech){}
function bool AlreadyHasOppositeGeneMod(XGStrategySoldier kSoldier, EGeneModTech GeneTech){}
function SendGeneModToCinematic(){}
function DoGeneModCinematic(XGStrategySoldier kSoldier, XComNarrativeMoment kPendingNarrative){}
function GeneModCinematicComplete(){}
function XComNarrativeMoment GetNarrativeForGeneMod(EPerkType ePerk){}
function bool UrgeGeneMod(){}
state WaitingToStartGeneModCinematic{}

