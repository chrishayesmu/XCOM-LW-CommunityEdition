class XGFacility_Labs extends XGFacility
    hidecategories(Navigation)
    config(GameData);

enum EResearchProgress
{
    eResearchProgress_None,
    eResearchProgress_Stalled,
    eResearchProgress_Slow,
    eResearchProgress_Normal,
    eResearchProgress_Fast,
    eResearchProgress_MAX
};

struct TResearchProject
{
    var int iTech;
    var int iProgress;
    var int iActualHoursLeft;
    var int iEstimate;
    var string strETA;
};

struct CheckpointRecord_XGFacility_Labs extends CheckpointRecord
{
    var bool m_bNewCaptive;
    var bool m_bCaptiveDied;
    var bool m_bNeedsScientists;
    var bool m_bGivenScientists;
    var array<int> m_arrMusingTracker;
    var TResearchProject m_kProject;
    var int m_iNumScientists;
    var array<int> m_arrResearched;
    var array<XGDateTime> m_arrResearchedTimes;
    var ETechType m_eLastResearched;
    var array<int> m_arrMissionResults;
    var bool m_bFirstTechSelected;
    var int m_iRequestCounter;
    var array<int> m_arrProgress;
    var array<int> m_arrTimeSpent;
    var array<EItemType> m_arrUnlockedItems;
    var array<EFacilityType> m_arrUnlockedFacilities;
    var array<EFoundryTech> m_arrUnlockedFoundryProjects;
    var array<int> m_arrCredits;
    var bool m_bNagExplosives;
    var int m_iTechConfirms;
    var int m_iExplosiveNags;
    var float m_fLabBonus;
    var float m_fAdjLabBonus;
    var bool m_bGreyWarning;
    var bool m_bCompletedFirstGeneMod;
    var bool m_bEnemyWithinAchieved;
    var bool m_bUrgeGeneMod;
    var bool m_bUrgeGeneMod2;
};

var bool m_bNewCaptive;
var bool m_bCaptiveDied;
var bool m_bNeedsScientists;
var bool m_bGivenScientists;
var bool m_bFirstTechSelected;
var bool m_bNagExplosives;
var bool m_bChooseTechAfterReport;
var bool m_bGreyWarning;
var bool m_bCompletedFirstGeneMod;
var bool m_bEnemyWithinAchieved;
var bool m_bUrgeGeneMod;
var bool m_bUrgeGeneMod2;
var array<int> m_arrMusingTracker;
var int m_iRequestCounter;
var TResearchProject m_kProject;
var int m_iNumScientists;
var array<int> m_arrResearched;
var array<XGDateTime> m_arrResearchedTimes;
var ETechType m_eLastResearched;
var array<int> m_arrMissionResults;
var array<int> m_arrProgress;
var array<int> m_arrTimeSpent;
var array<EItemType> m_arrUnlockedItems;
var array<EGeneModTech> m_arrUnlockedGeneMods;
var array<EFacilityType> m_arrUnlockedFacilities;
var array<EFoundryTech> m_arrUnlockedFoundryProjects;
var array<int> m_arrCredits;
var int m_iTechConfirms;
var int m_iExplosiveNags;
var XGTechTree m_kTree;
var float m_fLabBonus;
var float m_fAdjLabBonus;
var const localized string m_arrResearchProgress[5];
var const localized string m_strProgress;
var const localized string m_strETAInstant;
var const localized string m_strETADay;
var const localized string m_strETADays;
var const localized string m_strErrInsufficientFunds;
var const localized string m_strErrInsufficientElerium;
var const localized string m_strErrInsufficientAlloys;
var const localized string m_strErrInsufficientResources;
var const localized string m_strCostLabel;
var const localized string m_strCostElerium;
var const localized string m_strCostAlloys;


function Update(){}
function float GetCurrentResearchProgressPercentage(){}
function bool IsAPsiEnablingTech(int iTech){}
function bool IsInterrogationTechAvailable(){}
function bool HasInterrogatedCaptive(){}
function bool IsInterrogationTech(int iTech){}
function int GetNumAutopsiesPerformed(){}
function bool IsAutopsyTech(int iTech){}
function bool NeedsScientists(){}
function ResetRequestCounter(){}
function XComNarrativeMoment GetMusing(){}
function TLabeledText GetCurrentProgressText(){}
function TLabeledText GetProgressText(EResearchProgress eProgress){}
function EResearchProgress GetProgress(int iTech){}
function int GetHoursLeftOnProject(){}
function int GetHoursToResearchProject(int iTech){}
function GetEvents(out array<THQEvent> arrEvents){}
function string GetEstimateString(int iTech){}
function UpdateProgress(){}
function int GetResearchPerHour(){}
function string RecordTechResearched(TResearchProject FinishedProject){}
function OnResearchCompleted(){}
function ResearchCinematicComplete(){}
function bool CheckForEdison(){}
function bool CheckForAllEmployees(){}
function AddResearchCredit(EResearchCredits eCredit){}
function bool HasResearchCredit(EResearchCredits eCredit){}
function int NumKnownResearchCredits(){}
function SetNewProject(int iTech){}
function string RecordStartedResearchProject(TResearchProject Project){}
function PayCost(TResearchCost kCost){}
function RefundCost(TResearchCost kCost, optional bool bXeno){}
function bool HasProject(){}
function TResearchProject GetCurrentProject(){}
function TTech GetCurrentTech(){}
function TTech GetCurrentTechTemplate(){}
function int GetAvailableScientists(){}
function AddScientists(int iNumScientists){}
function RemoveScientists(int iNumScientists){}
function GetAvailableTechs(out array<TTech> arrTechs){}
function bool IsTechAvailable(ETechType eTech){}
function bool HasTechsAvailable(){}
function bool IsPriorityTech(int iTech){}
function int GetNumScientists(){}
function bool IsResearched(int iTech) {}
function int GetNumTechsResearched(){}
function int LabHoursToDays(int iHours){}
function bool GetCostSummary(out TCostSummary kCostSummary, out TResearchCost kCost){}
function bool CanAffordTech(int iTech){}
function array<int> GetCurrentTechStates(){}
function CompilePostMissionReport(array<int> arrPreLandTechs, array<int> arrPostLandTechs){}
function Init(bool bLoadingFromSave){}
function UpdateLabBonus(){}
function InitNewGame(){}
function Enter(int iView){}
function Exit(){}
function CheckForAlerts(){}
