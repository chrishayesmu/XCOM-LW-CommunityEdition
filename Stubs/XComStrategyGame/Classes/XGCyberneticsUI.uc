class XGCyberneticsUI extends XGScreenMgr
    config(GameData);
//complete stub

enum ECyberneticsLabView
{
    eCyberneticsLabView_MainMenu,
    eCyberneticsLabView_Add,
    eCyberneticsLabView_Results,
    eCyberneticsLabView_Inventory,
    eCyberneticsLabView_Upgrade,
    eCyberneticsLabView_Repair,
    eCyberneticsLabView_MAX
};

struct TSoldierTable
{
    var TTableMenu mnuSoldiers;
};

struct TCyberneticsSubjectList
{
    var TText txtTitle;
    var TTableMenu mnuSlots;
    var TButtonText btxtChoose;
};

struct TUIMECInventoryItem
{
    var string strName;
    var int iState;
    var bool bCanUpgrade;
    var bool bCanRepair;
    var string strCostLabel;
    var string strCantUpgradeReason;
    var array<string> arrPerkInfo;
    var array<TLabeledText> arrCost;
    var XGStrategySoldier kEquippedSoldier;
    var EItemType eArmorType;
};

struct TUIMECBuildOption
{
    var string strName;
    var string strDescription;
    var EItemType eItem;
};

struct TCyberneticsHeader
{
    var TLabeledText txtCash;
    var TLabeledText txtEngineers;
    var TLabeledText txtMeld;
};

var TCyberneticsHeader m_kHeader;
var TCyberneticsSubjectList m_kSubjectList;
var TSoldierTable m_kSoldierTable;
var int m_iHighlightedSlot;
var int m_iPreviousPlinthMecIndex;
var int m_iSelectedMEC;
var int m_iMECRotationUpgrade1;
var int m_iMECRotationUpgrade2;
var int m_iMECRotationUpgrade3;
var array<TUIMECInventoryItem> m_arrMECInventory;
var TTableMenu m_mnuMechInventory;
var array<TUIMECBuildOption> m_arrMecBuildOptions;
var Actor m_kMecActor;
var InterpActor m_kPlinthActor;
var const localized string m_strLabelCurrentPatients;
var const localized string m_strLabelAddSoldier;
var const localized string m_strLabelHours;
var const localized string m_strLabelDays;
var const localized string m_strLabelEmpty;
var const localized string m_strRookieState;
var const localized string m_strLabelLocked;
var const localized string m_strDescLocked;
var const localized string m_strLabelDamaged;
var const localized string m_strLabelRepairing;
var const localized string m_strBuildNewMEC;
var const localized string m_strRepairTitle;
var const localized string m_strRepairCost;
var const localized string m_strRepairWarning;
var const localized string m_strRepairButtonConfirm;
var const localized string m_strRepairButtonWait;
var const localized string m_strBuildCostLabel;
var const localized string m_strUpgradeCostLabel;
var const localized string m_strRepairCostLabel;
var const localized string m_strCantUpgradeLabel;
var const localized string m_strCantUpgradeReasonMissingTec;
var const localized string m_strCantUpgradeReasonMaxLevel;
var const localized string m_strNewMecBuiltDialogTitle;
var const localized string m_strNewMecBuiltDialogDescription;
var const localized string m_strNewMecRepairingDialogTitle;
var const localized string m_strNewMecRepairingDialogDescription;
var const localized string m_strNewMecUpgradedDialogTitle;
var const localized string m_strNewMecUpgradedDialogDescription;

function Init(int iView){}
function UpdateView(){}
simulated function OnReceiveFocus(){}
simulated function OnLoseFocus(){}
function OnLeaveCyberneticsLab(){}
function OnLeaveResults();

function UpdateHeader(){}
function bool OnChooseSoldier(int iOption){}
function OnLeaveSoldierList(){}
function OnSlotHighlighted(int iSlot){}
function OnChooseSlot(int iSlot){}
function UpdateTraineeList(){}
function TCyberneticsSubjectList BuildTrainees(){}
function UpdateSoldierList(){}
function TTableMenuOption BuildSoldierOption(XGStrategySoldier kSoldier, array<int> arrCategories, int soldierListIndex){}
function UpdateInventory(){}
simulated function string GenerateMecWeaponDescription(EItemType eItem){}
simulated function array<TLabeledText> GetMecCosts(EItemType eBaseArmor, bool bUpgrade, bool bRepair){}
simulated function TUIMECInventoryItem GenerateUpgradeMEC(optional int kMecArmor){}
simulated function TUIMECInventoryItem GenerateDamagedMEC(TItem kMecArmor){}
simulated function TUIMECInventoryItem GenerateRepairingMEC(TCyberneticsLabRepairingMec kMec){}
simulated function bool OnMECInventoryAccept(int iTarget){}
simulated function OnLeaveMECInventory(){}
simulated function SkeletalMeshActor GetPlinthActor(){}
simulated function PutMecOnPlinth(int iMECIndex, optional bool bUsePreviewShader){}
simulated function SetPreviewWeapon(EItemType eWeapon){}
simulated function SetMecRotationForBuildUpgradeView(int iArmorUpgradeLevel){}
simulated function XComMecPawn BuildEmptyMecActor(EItemType eArmorType, Vector vLocation, Rotator rRotation){}
simulated function RemoveMecFromPlinth(){}
simulated function RepairPopup(){}
simulated function RepairCallback(EUIAction eAction){}
simulated function GetMecUpgradeDescriptionAndName(EItemType eUpgradeItem, out string strDescription, out string strName){}
simulated function UpdateUpgradeInfo(){}
simulated function bool IsBuildingNewMec(){}
simulated function TUIMECInventoryItem GetCurrentMECToUpgrade(){}
simulated function bool OnMECUpgradeAccept(int iTarget){}
simulated function ShowMecBuiltPopup(){}
simulated function ShowMecRepairingPopup(string mecName, int iDaysRemaining){}
simulated function ShowMecUpgradedPopup(string oldMecName, string newMecName){}
simulated function OnLeaveMECUpgrade(){}
