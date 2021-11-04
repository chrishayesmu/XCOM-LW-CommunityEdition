class XGFacility_CyberneticsLab extends XGFacility
    config(GameData)
    notplaceable
    hidecategories(Navigation);
	
struct TCyberneticsLabPatient
{
    var XGStrategySoldier m_kSoldier;
    var int m_iHoursLeft;
};

struct TCyberneticsLabRepairingMec
{
    var EItemType m_eMecItem;
    var int m_iHoursLeft;
};
struct CheckpointRecord_XGFacility_CyberneticsLab extends CheckpointRecord
{
    var array<TCyberneticsLabPatient> m_arrPatients;
    var array<TCyberneticsLabRepairingMec> m_arrRepairingMecs;
    var bool m_bSownKeysToMecDeployment;
};

var const config int m_iModCashCost;
var const config int m_iModMeldCost;
var const config int m_iModDays;
var const config float m_fMecRepairCostMod;
var const localized string m_strCompletionDialogTitle;
var const localized string m_strSingleCompletionDialogText;
var const localized string m_strMultiCompletionDialogText;
var array<TCyberneticsLabPatient> m_arrPatients;
var array<TCyberneticsLabRepairingMec> m_arrRepairingMecs;
var bool m_bSownKeysToMecDeployment;
var transient XGStrategySoldier MecCinematicSoldier;
var transient PhysicsAsset MecCinematicPhysics;
var transient LevelStreaming CinCap;

final function UpdatePatients(){}
final function UpdateRepairingMecs(){}
function Update(){}
function bool AddSoldierToCyberneticsLab(XGStrategySoldier kSoldier){}
function bool RemoveSoldierFromCyberneticsLab(XGStrategySoldier kSoldier){}
function bool CanAffordAugment(){}
final function PayModCost(){}
function bool AddMecForRepair(EItemType eItem){}
function int GetHoursToRepairMec(EItemType eItem){}
function bool CanAffordMecRepair(EItemType eItem){}
final function PayMecRepairCost(EItemType eItem){}
function bool CanAffordMecBuildCost(EItemType eItem){}
function PayMecBuildCost(EItemType eItem){}
function string RecordMECBuiltOrUpgraded(EItemType BuiltMEC){}
function bool IsSlotOccupied(int iSlot){}
final function GetPatientEvents(out array<THQEvent> arrEvents){}
final function GetRepairingMecEvents(out array<THQEvent> arrEvents){}
function GetEvents(out array<THQEvent> arrEvents){}
function SendMecToCinematic(){}
function FirstMecCinematic(){}
function MecCinematicComplete(){}
state WaitingToStartFirstMecCinematic{}
