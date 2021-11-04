class XGHangarUI extends XGScreenMgr
	config(GameData);
//complete stub

enum EHangarView
{
    eHangarView_MainMenu,
    eHangarView_ShipSummary,
    eHangarView_Table,
    eHangarView_Transfer,
    eHangarView_Hire,
    eHangarView_ShipList,
    eHangarView_MAX
};

struct THangarHeader
{
    var TText txtTitle;
    var array<TLabeledText> arrResources;
};

struct THangarMainMenu
{
    var TMenu mnuOptions;
};

struct THangarJetUpgrade
{
    var TText txtName;
    var TImage imgUpgrade;
};

struct TShipSummary
{
    var TText txtName;
    var TLabeledText txtStatus;
    var TLabeledText txtKills;
    var TImage imgShip;
    var TText txtWeaponLabel;
    var TText txtWeapon;
    var TLabeledText txtWeaponRange;
    var TLabeledText txtWeaponDamage;
    var TButtonText txtWeaponButton;
    var TButtonText txtTransferButton;
    var TButtonText txtDestroyButton;
};

struct TTableItemSummary
{
    var TText txtTitle;
    var TText txtSummary;
    var TImage imgOption;
};

struct THangarTable
{
    var TTableMenu mnuOptions;
    var array<TTableItemSummary> arrSummaries;
};

struct THangarTransfer
{
    var TMenu mnuTransfer;
    var array<int> arrOptions;
};

struct THiringWidget
{
    var TText txtTitle;
    var TLabeledText txtFacilityCap;
    var TLabeledText txtCost;
    var TText txtNumToHire;
    var TButtonText txtButtonHelp;
    var TLabeledText txtMoney;
    var TImage imgHire;
    var TLabeledText txtMaintenance;
};

var THangarHeader m_kHeader;
var THangarMainMenu m_kMainMenu;
var TShipSummary m_kShipSummary;
var THangarTable m_kTable;
var TButtonText m_kNextHangar;
var TButtonText m_kPrevHangar;
var THiringWidget m_kHiring;
var THangarTransfer m_kTransfer;
var array<TContinentInfo> m_arrContinents;
var array<int> m_arrResources;
var XGShip m_kShip;
var array<TItem> m_arrItems;
var int m_iContinent;
var array<TItemProject> m_akFirestorms;
var int m_iConfirmPendingShipRemoval_Continent;
var int m_iConfirmPendingShipRemoval_Ship;
var int m_iMaxCapacity;
var int m_iNumInterceptors;
var int m_iNumInterceptorsOnOrder;
var int m_iNumHiring;
var int m_iContinentHiringInto;
var const localized string m_strHeaderNames[EHangarView];
var const localized string m_strHeaderHelp[EHangarView];
var const localized string m_strUnknownName;
var const localized string m_strOrderInterceptors;
var const localized string m_strHelpInterceptors;
var const localized string m_strPerSecond;
var const localized string m_strOpenBays;
var const localized string m_strLabelStatus;
var const localized string m_strLabelDamage;
var const localized string m_strLabelRange;
var const localized string m_strLabelWeaponsSystem;
var const localized string m_strLabelTransfer;
var const localized string m_strChangeLoadout;
var const localized string m_strLabelElimiateShip;
var const localized string m_strLabelConfirmedKills;
var const localized string m_strLabelIncreaseOrder;
var const localized string m_strLabelHireCost;
var const localized string m_strLabelHireMonthlyCost;
var const localized string m_strLabelHangarCap;
var const localized string m_strLabelHireInterceptors;
var const localized string m_strLabelTransferTo;
var const localized string m_strLabelEmpty;
var const localized string m_strSatellites;
var const localized string m_strMaintenance;
var const localized string m_strCancelPendingOrderTitle;
var const localized string m_strCancelPendingOrderText_Interceptor;
var const localized string m_strCancelPendingOrderText_Firestorm;

function Init(int iView){}
function UpdateView(){}
static function eShipFireRate GetShipWeaponFiringRateBin(float fFiringTime){}
static function eGenericTriScale GetShipWeaponArmorPenetrationBin(int iAP){}
static function eGenericTriScale GetShipWeaponDamageBin(int iDamage){}
static function eWeaponRangeCat GetShipWeaponRangeBin(int fRate){}
function UpdateShipWeaponView(XGShip_Interceptor kShip, EShipWeapon eWeapon){}
static function TItemCard BuildShipWeaponCard(EItemType eWeapon){}
function TItemCard HANGARUIGetItemCard(optional int iContinent, optional int iShip, optional int viewOverride){}
function UpdateHeader(){}
function UpdateMain(){}
function UpdateShipList(){}
function TTableMenuOption BuildCraftOption(XGShip_Interceptor kShip, array<int> arrCategories){}
function UpdateTransferDisplay(){}
function OnIncreaseHiringOrder(){}
function OnDecreaseHiringOrder(){}
function OnCancelHiringOrder(){}
function bool OnAcceptHiringOrder(){}
function UpdateHireDisplay(){}
function OnChooseMainMenuOption(int iOption){}
function OnChooseCraft(int iContinent, int iShip){}
simulated function ConfirmRemovalOfPendingShipOrder(){}
simulated function RemovePendingShipOrder(optional EUIAction eAction){}
simulated function int GetNumPendingInterceptors(int iContinent){}
function OnLeaveCraftList(){}
function OnChooseTransferInterceptorOption(int iOption){}
function OnChooseTransferInterceptor(int iDestContinent){}
function OnLeaveFacility(){}
function UpdateShipSummary(){}
function UpdateInterceptorSummary(){}
function UpdateSkyrangerSummary(){}
function UpdateTableMenu(){}
function TTableMenuOption BuildTableItem(TItem kItem){}
function TTableItemSummary BuildItemSummary(TItem kItem){}
function OnChooseTableOption(int iOption){}
function OnLeaveTable(){}
function OnLeaveSummary(){}
function OnLeaveTransferInterceptor(){}
function OnEliminate(){}
function OnChangeWeapons(){}
function OnTransferInterceptor(){}
function string GetShipName(){}
function bool IsSkyranger(){}
