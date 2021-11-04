class XGExaltSimulation extends XGStrategyActor
    config(GameData)
    notplaceable
    hidecategories(Navigation);
//complete stub

enum EExaltCellLastVisibilityStatus
{
    eExaltCellLastVisibilityStatus_None,
    eExaltCellLastVisibilityStatus_Revealed,
    eExaltCellLastVisibilityStatus_Hidden,
    eExaltCellLastVisibilityStatus_Removed,
    eExaltCellLastVisibilityStatus_MAX
};

enum EExaltSimulationState
{
    eExaltSimulationState_NotStarted,
    eExaltSimulationState_FirstCellDelay,
    eExaltSimulationState_Active,
    eExaltSimulationState_Finished,
    eExaltSimulationState_MAX
};

enum EExaltCellExposeReason
{
    eExaltCellExposeReason_IntelSweep,
    eExaltCellExposeReason_SabatogeOperation,
    eExaltCellExposeReason_IncreasedPanic,
    eExaltCellExposeReason_ResearchHack,
    eExaltCellExposeReason_MAX
};

struct TExaltCellTuning
{
    var int m_iMinDaysBetweenDifferentCellOperations;
    var int m_iMinDaysBetweenOperations;
    var int m_iMaxDaysBetweenOperations;
    var int m_iMinDaysToHide;
    var int m_iMaxDaysToHide;
    var int m_iMinDaysBetweenCells;
    var int m_iMaxDaysBetweenCells;
    var int m_iMaxSimultaneousCells;
    var int m_iMinSabotageCashAmount;
    var float m_fSabotageCashPercentage;
    var int m_iMinResearchHackDays;
    var float m_fResearchHackPercentage;
};

struct TExaltCellPlacementRollTuning
{
    var float m_fBaseChance;
    var float m_fSatelliteMod;
    var float m_fStealthSatelliteMod;
};

struct TExaltCellPlacementScoreTuning
{
    var float m_fCountryHasLeftXComMod;
    var array<float> m_arrPanicMod;
    var float m_fSatelliteMod;
    var float m_fHomeContinentMod;
    var float m_fContinentHasNoCellsMod;
    var float m_fContinentNoCountriesHaveLeftXComMod;
    var float m_fOnContinentWithOnlyOneCountryLeftInXComMod;
    var float m_fContinentHasLeftXComMod;
    var float m_fOnlyCountryOnContinentWithoutSatelliteMod;
};

struct TExaltTuning
{
    var const config int m_iExaltStartDelayDays;
    var const config int m_iExaltStartDelayDaysVariation;
    var const config int m_iExaltSweepBaseCost;
    var const config float m_fExaltSweepCostIncrease;
    var const config int m_iCovertOperationDuration;
    var const config TExaltCellTuning m_kCellTuning;
    var const config TExaltCellPlacementRollTuning m_kPlacementRollTuning;
    var const config TExaltCellPlacementScoreTuning m_kPlacementScoreTuning;
};

struct TExaltClueDefinition
{
    var int m_iClueTextIndex;
    var array<ECountry> m_arrValidCountries;
    var array<ECountry> m_arrInvalidCountries;
};

struct TExaltCellData
{
    var ECountry m_eCountry;
    var int m_iDaysUntilHidden;
    var int m_iDaysUntilNextActivity;
};

struct TExaltCellPlacementScore
{
    var ECountry m_eCountry;
    var float m_fScore;
};

struct TCovertOpsOperative
{
    var XGStrategySoldier m_kCovertOpsSoldier;
    var ECountry m_eInfiltratedCountry;
    var int m_iDaysUntilComplete;
};

struct TExaltCellLastVisibilityStatus
{
    var ECountry m_eCountry;
    var EExaltCellLastVisibilityStatus m_eVisibilityStatus;
};

struct CheckpointRecord
{
    var TExaltTuning m_kTuning;
    var EExaltSimulationState m_eSimulationState;
    var ECountry m_eExaltCountry;
    var array<TExaltClueDefinition> m_arrClues;
    var array<TExaltCellData> m_arrCellData;
    var array<EExaltCellLastVisibilityStatus> m_arrCellLastVisibilityData;
    var int m_kNextDayTimer;
    var int m_iCellPlacementCooldown;
    var int m_iSweepCount;
    var int m_iCellsCleared;
    var int m_iDaysSinceLastOperation;
    var bool m_bHaveDoneCaptureAndHoldMission;
    var bool m_bHaveDoneExtractionMission;
    var TCovertOpsOperative m_kCovertOpsOperative;
    var array<ECountry> m_arrAccusedCountries;
    var bool m_bFirstCellClearedPostCombat;
};

var XGMission m_kDebugForceMission;
var const config array<config TExaltClueDefinition> m_arrClueDefinitions;
var const localized array<localized string> m_arrClueText;
var const config array<config TExaltTuning> m_arrExaltTuning;
var const localized string m_strCovertInfiltrationDeathReason;
var TExaltTuning m_kTuning;
var EExaltSimulationState m_eSimulationState;
var ECountry m_eExaltCountry;
var array<TExaltClueDefinition> m_arrClues;
var array<TExaltCellData> m_arrCellData;
var array<TExaltCellLastVisibilityStatus> m_arrCellLastVisibilityData;
var int m_kNextDayTimer;
var int m_iCellPlacementCooldown;
var int m_iSweepCount;
var bool m_bHasTimePassedSinceLastSweep;
var bool m_bHaveDoneCaptureAndHoldMission;
var bool m_bHaveDoneExtractionMission;
var bool m_bCellClearedPostCombat;
var bool m_bFirstCellClearedPostCombat;
var int m_iCellsCleared;
var int m_iDaysSinceLastOperation;
var TCovertOpsOperative m_kCovertOpsOperative;
var array<ECountry> m_arrAccusedCountries;

function Init(bool bLoadingFromSave){}
function bool IsExaltActive(){}
function UpdateObjectives(int iHalfHours){}
function XGMission CreateNextMission(){}
function NextDayForOperative(){}
function NextDayForExalt(){}
function PayDay(){}
function OnMissionExpire(XGMission kMission){}
function RelocateCell(ECountry eCellCountry){}
function array<EExaltCellExposeReason> GetPossibleOperationTypes(ECountry eOperationCountry){}
function PerformSabotageOperation(ECountry eOperationCountry){}
function string RecordExaltSabotageOperation(int AmountStolen){}
function PerformIncreasePanicOperation(ECountry eOperationCountry){}
function string RecordExaltPanicOperation(){}
function PerformResearchHackOperation(ECountry eOperationCountry){}
function string RecordExaltResearchOperation(int HoursHacked){}
function PerformRandomOperation(ECountry eOperationCountry){}
function BeginSimulation(){}
function int GetPanicMod(ECountry eCountryToCheck, int iBasePanic){}
function EExaltCellLastVisibilityStatus GetLastVisibiltyStatus(ECountry eCountryToCheck){}
function SetLastVisibiltyStatus(ECountry eCountryToSet, EExaltCellLastVisibilityStatus eStatus){}
function ClearLastVisibiltyStatusForAllCountries(){}
function int GetActiveCellsOnContinent(XGContinent kContinent){}
function float ScoreCountryForCellPlacementAttempt(ECountry eCountryToScore, optional out string strDebugText){}
function ECountry SelectCountryForCellPlacementAttempt(){}
function bool RollDiceForCellPlacement(ECountry eCountryForPlacement){}
function PlaceNextCell(optional bool bIgnoreDiceRoll){}
function string RecordExaltCellPlacementAttempt(bool bSuccess, bool bIgnoredDiceRoll, ECountry Country){}
function ClearCell(ECountry eCountryToClear){}
function bool IsCellActiveInCountry(ECountry eCountryToCheck){}
function bool IsCellExposedInCountry(ECountry eCountryToCheck){}
function ExposeCell(ECountry eCountryToExpose){}
function int GetSweepCost(){}
function PerformSweep(){}
function string RecordExaltSweep(){}
function bool CanPerformSweep(){}
function int GetCollectedClueCount(){}
function string GetCurrentClueDescription(){}
function string GetClueDescription(int iClueIndex){}
function int GetNumCountriesNotRuledOutByClues(){}
function bool IsCountryRuledOutByClueAtIndex(ECountry eCountryToCheck, int iClueIndex){}
function bool IsCountryRuledOutByClue(ECountry eCountryToCheck, TExaltClueDefinition kClue){}
function bool IsCountryRuledOutByCurrentClues(ECountry eCountryToCheck){}
function int GetRuledOutCountryCountForClue(TExaltClueDefinition kClue){}
function SelectClues(ECountry eDesiredCountry){}
function array<ECountry> RemoveInvalidCountriesForClue(array<ECountry> arrCountries, TExaltClueDefinition kClue){}
function PostCombat(XGMission kMission, bool bSuccess){}
function EndSimulation(){}
function bool IsExaltBaseExposedInCountry(ECountry eCountryToCheck){}
function bool HasExaltBeenSuccessfullyAccused(){}
function bool HasCountryBeenAccused(ECountry eCountryToCheck){}
function bool AccuseCountry(ECountry eAccusedCountry){}
function SetCovertOperative(XGStrategySoldier kSoldier, ECountry eCountryToInfiltrate){}
function bool IsOperative(XGStrategySoldier kSoldier){}
function bool IsOperativeInField(){}
function bool IsOperativeInCountry(ECountry eCountryToCheck){}
function int GetCurrentOperativeCountry(){}
function bool IsOperativeReadyForExtraction(){}
function XGStrategySoldier GetOperative(){}
function ClearOperative(){}
function GetEvents(out array<THQEvent> arrEvents){}
function DebugForceCovertMission(string strMapName){}
function DebugPlaceCellInCountry(ECountry ePlacementCountry){}
function PrivateLog(string strText){}
function PrintDebugInfo(){}
