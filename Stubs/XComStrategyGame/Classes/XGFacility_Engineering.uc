class XGFacility_Engineering extends XGFacility
    hidecategories(Navigation)
    config(GameData)
    notplaceable;
//complete stub

struct CheckpointRecord_XGFacility_Engineering extends CheckpointRecord
{
    var array<TConstructionProject> m_arrConstructionProjects;
    var array<TFacilityProject> m_arrFacilityProjects;
    var array<TFoundryProject> m_arrFoundryProjects;
    var array<TItemProject> m_arrItemProjects;
    var bool m_bCanBuildItems;
    var bool m_bCanBuildFacilities;
    var bool m_bNeedsEngineers;
    var bool m_bGivenEngineers;
    var int m_iEngineerReminder;
    var array<int> m_arrMusingTracker;
    var int m_iEleriumHalfLife;
    var XGStorage m_kStorage;
    var int m_iNumEngineers;
    var array<int> m_arrFoundryHistory;
    var array<TEngQueueItem> m_arrQueue;
    var bool m_bUrgeBuildMEC;
};

var array<TConstructionProject> m_arrConstructionProjects;
var array<TFacilityProject> m_arrFacilityProjects;
var array<TFoundryProject> m_arrFoundryProjects;
var config array<config TSatellite> m_arrAlloyProjects;
var array<TItemProject> m_arrItemProjects;
var bool m_bCanBuildItems;
var bool m_bCanBuildFacilities;
var bool m_bNeedsEngineers;
var bool m_bGivenEngineers;
var bool m_bUrgeBuildMEC;
var bool m_bFacilityBuilt;
var bool m_bStartedFoundryProject;
var int m_iEngineerReminder;
var array<int> m_arrMusingTracker;
var int m_iEleriumHalfLife;
var XGStorage m_kStorage;
var int m_iNumEngineers;
var array<int> m_arrFoundryHistory;
var array<TEngQueueItem> m_arrQueue;
var XGItemTree m_kItems;
var array<TProjectCost> m_arrOldRebates;
var const localized string m_strErrAffordEngineers;
var const localized string m_strErrNeedWorkshop;
var const localized string m_strErrNeedEngineers;
var const localized string m_strErrInsufficientFunds;
var const localized string m_strErrInsufficientElerium;
var const localized string m_strErrInsufficientAlloys;
var const localized string m_strErrInsufficientItems;
var const localized string m_strErrInsufficientPower;
var const localized string m_strErrInsufficientExperience;
var const localized string m_strErrInsufficientScientists;
var const localized string m_strErrInsufficientItem;
var const localized string m_strErrInsufficientEngineers;
var const localized string m_strErrRequiredProjectItem;
var const localized string m_strErrRequiredItem;
var const localized string m_strErrBarracksFull;
var const localized string m_strSatelliteLimit;
var const localized string m_strMoreEngineers;
var const localized string m_strLabelRequires;
var const localized string m_strSatelliteBuildLarge;
var const localized string m_strSatelliteBuild;
var const localized string m_strETAHour;
var const localized string m_strETADay;
var const localized string m_strCostElerium;
var const localized string m_strCostAlloys;
var const localized string m_strCostPower;
var const localized string m_strCostEngineers;
var const localized string m_strCostScientists;
var const localized string m_strCostLabel;
var const localized string m_strCostSoldier;
var const localized string m_strCostBarracks;

function Update() {}
function DegradeElerium() {}
function int GetWorkPerHour(int iNumEngineers, bool Brush) {}
function bool NeedsEngineers(){}
function ResetRequestCounter(){}
function XComNarrativeMoment GetMusing(){}
function SpillAvailableEngineers(){}
function UpdateItemProject(){}
function UpdateFacilityProjects(){}
function UpdateFoundryProjects(){}
function UpdateAlloyProjects(){}
function UpdateConstructionProjects(){}
function GetEvents(out array<THQEvent> arrEvents){}
function GetItemEvents(out array<THQEvent> arrEvents){}
function GetFacilityEvents(out array<THQEvent> arrEvents){}
function GetFoundryEvents(out array<THQEvent> arrEvents){}
function AddEngineers(int iNumNewEngineers){}
function int GetNumEngineersAvailable(){}
function AddItemProject(out TItemProject kProject){}
function string RecordStartedItemConstruction(TItemProject Project){}
function ModifyItemProject(TItemProject kProject){}
function RestoreItemFunds(int iIndex){}
function string RecordCanceledItemConstruction(TItemProject Project){}
function MoveItemProjectToTop(out TItemProject kProject){}
function AddFacilityProject(out TFacilityProject kProject){}
function string RecordStartedFacilityProject(TFacilityProject Project){}
function ModifyFacilityProject(TFacilityProject kProject){}
function RestoreFacilityFunds(int iIndex){}
function string RecordCanceledFacilityProject(TFacilityProject Project){}
function bool CanAddFoundryProject(){}
function AddFoundryProject(out TFoundryProject kProject){}
function string RecordStartedFoundryProject(TFoundryProject Project){}
function ModifyFoundryProject(TFoundryProject kProject){}
function RestoreFoundryFunds(int iIndex){}
function string RecordCanceledFoundryProject(TFoundryProject Project){}
function bool IsFoundryTechInQueue(EFoundryTech eFTech){}
function AddAlloyProject(out TAlloyProject kProject){}
function AddFoundryProjectToQueue(out TFoundryProject kProject){}
function AddItemProjectToQueue(out TItemProject kProject){}
function int GetConstructionCounter(out TConstructionProject kProject){}
function int GetFacilityCounter(out TFacilityProject kProject){}
function int GetFoundryCounter(out TFoundryProject kProject){}
function AddConstructionProject(int iProject, int X, int Y){}
function string RecordStartedConstructionProject(int ProjectType){}
function bool HasRebate(){}
function int GetNumShivsOrdered(){}
function OnItemCompleted(int iItemProject, int iQuantity, optional bool bInstant){}
function string RecordItemsBuilt(EItemType ItemType, int ItemQuantity){}
function OnFacilityCompleted(int iProject){}
function OnItemProjectCompleted(int iProject, optional bool bInstant){}
function string RecordFacilityBuilt(EFacilityType FacilityValue){}
function OnConstructionCompleted(int iProject){}
function string RecordExcavationCompleted(int X, int Y){}
function string RecordRemovedFacility(EFacilityType FacilityType){}
function OnFoundryProjectCompleted(int iProject){}
function string RecordFoundryProjectCompleted(TFoundryProject FinishedProject){}
function OnAlloyProjectCompleted(int iProject){}
function RemoveItemProject(int iIndex){}
function ChangeItemIndex(int iOldIndex, int iNewIndex){}
function ChangeFoundryIndex(int iOldIndex, int iNewIndex){}
function RemoveFacilityProject(int iIndex){}
function RemoveConstructionProject(int iIndex){}
function RemoveFoundryProject(int iIndex){}
function RemoveAlloyProject(int iIndex){}
function RemoveItemProjectFromQueue(int iProjectIndex){}
function RemoveFoundryProjectFromQueue(int iProjectIndex){}
function CancelItemProject(int iIndex){}
function CancelFacilityProject(int X, int Y){}
function CancelFoundryProject(int iIndex){}
function CancelAlloyProject(int iIndex){}
function CancelConstructionProject(int X, int Y){}
function int GetNumItemProjects(){}
function int GetNumFoundryProjects(){}
function int GetNumAllProjects(){}
function TItemProject GetItemProject(int iIndex){}
function TFacilityProject GetFacilityProject(int X, int Y){}
function TFoundryProject GetFoundryProject(int iIndex){}
function TAlloyProject GetAlloyProject(int iIndex){}
function TConstructionProject GetConstructionProject(int X, int Y){}
function bool GetCostSummary(out TCostSummary kCostSummary, TProjectCost kCost, optional bool bOmitStaff){}
function bool GetItemCostSummary(out TCostSummary kCostSummary, EItemType eItem, optional int iQuantity, optional bool Brush, optional bool bShowEng, optional int iProjectIndex){}
function bool GetFacilityCostSummary(out TCostSummary kCostSummary, EFacilityType eFacility, int X, int Y, bool Brush){}
function bool GetFoundryCostSummary(out TCostSummary kCostSummary, int iFoundryTech, bool Brush, optional bool bShowEng){}
function TProjectCost GetItemProjectCost(EItemType eItem, int iQuantity, optional bool Brush){}
function int ItemAmount(int iBaseAmount){}
function TProjectCost GetFacilityProjectCost(EFacilityType eFacility, int X, int Y, bool bRushFacility){}
function TProjectCost GetFoundryProjectCost(int iTech, bool bRushFoundry){}
function TProjectCost GetAlloyProjectCost(int iEngineers){}
function TProjectCost GetConstructionProjectCost(int iConstructionType, int X, int Y){}
function PayCost(TProjectCost kCost){}
function RefundCost(TProjectCost kCost){}
function RemoveEngineers(int iEngineers){}
function int GetItemProjectHoursRemaining(TItemProject kProject){}
function string GetETAString(TItemProject kProject){}
function string GetFoundryETAString(TFoundryProject kProject){}
function SellItem(int iItemType, bool bAll){}
function array<TItem> GetItemsByCategory(int iCategory, int iTransactionType){}
function GrantInitialStores(){}
function bool IsCorpseItem(int iItem){}
function bool HavePreReqs(int iItem){}
function int GetNumEngineers(){}
function XGStorage GetStorage(){}
function bool CanHire(out string strHelp){}
function bool IsFoundryTechResearched(int iTech){}
function Init(bool bLoadingFromSave){}
function InitNewGame(){}
function InitLoadGame(){}
function Enter(int iView){}
function Exit(){}
function FirstTimeHelp(){}
function bool CalcWorkshopRebate(TProjectCost kCost, out TProjectCost kRebate, optional bool bIsFacility){}
function int GetNumFirestormsBuilding(){}
function int GetNumSatellitesBuilding(){}
function bool IsBuildingItem(EItemType eItem){}
function int GetNumFacilitiesBuilding(EFacilityType eFacility){}
function bool IsBuildingFacility(EFacilityType eFacility){}
function bool IsPriorityItem(EItemType eItem){}
function bool IsPriorityFacility(EFacilityType eFacility){}
function bool UrgeBuildMEC(){}

