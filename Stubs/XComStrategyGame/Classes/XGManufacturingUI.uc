class XGManufacturingUI extends XGScreenMgr
    config(GameData);
//complete stub

enum EManufacturingView
{
    eManView_Item,
    eManView_Facility,
    eManView_Foundry,
    eManView_MAX
};

enum EManButton
{
    eManButt_None,
    eManButt_SubmitOrder,
    eManButt_CancelOrder,
    eManButt_ToTop,
    eManButt_MAX
};

enum EManButtonStates
{
    eManButtState_NotVisible,
    eManButtState_Disabled,
    eManButtState_Unselected,
    eManButtState_Highlighted,
    eManButtState_MAX
};

struct TManWidget
{
    var TText txtTitle;
    var TButtonText txtItemInfoButton;
    var TImage imgItem;
    var TText txtQuantity;
    var TText txtQuantityLabel;
    var TButtonText txtQuantityHelp;
    var bool bCanAdjustQuantity;
    var TText txtEngineers;
    var TText txtEngineersLabel;
    var TButtonText txtEngHelp;
    var TLabeledText txtProjDuration;
    var TText txtResourcesLabel;
    var TCostSummary kCost;
    var TText txtNotesLabel;
    var TText txtNotes;
    var TText txtProblem;
    var TButtonText txtRushButton;
    var TButtonText txtNotifyButton;
    var array<TButtonText> arrButtons;
};

var TButtonBar m_kButtonBar;
var TManWidget m_kWidget;
var TImage m_imgBG;
var TItemProject m_kIProject;
var TFacilityProject m_kFProject;
var TFoundryProject m_kFoundProject;
var bool m_bCanRush;
var bool m_bCanAfford;
var bool m_bCanCancel;
var bool m_bSatCapacity;
var bool m_bAllowDeleteOrder;
var array<int> m_arrButtons;
var int m_iHighlightedButton;
var int m_iAddedEngineers;
var const localized string m_strLabelItemInfo;
var const localized string m_strLabelQuantity;
var const localized string m_strLabelProjectDuration;
var const localized string m_strLabelEngineersAssigned;
var const localized string m_strLabelProjectCost;
var const localized string m_strLabelNotes;
var const localized string m_strLabelRushBuild;
var const localized string m_strLabelYES;
var const localized string m_strLabelNO;
var const localized string m_strLabelSubmitOrder;
var const localized string m_strLabelModifyOrder;
var const localized string m_strLabelModifyBeginBuild;
var const localized string m_strLabelContinueBuild;
var const localized string m_strLabelBeginProject;
var const localized string m_strLabelContinueProject;
var const localized string m_strLabelCancelBuild;
var const localized string m_strLabelDeleteProject;
var const localized string m_strLabelFacilityInfo;
var const localized string m_strLabelTimeToBuild;
var const localized string m_strLabelDeleteOrder;
var const localized string m_strLabelProjectInfo;
var const localized string m_strLabelTimeToComplete;
var const localized string m_strBackLabel;
var const localized string m_strETADays;
var const localized string m_strNoteWeaponRifle;
var const localized string m_strNoteWeaponAllSoldiers;
var const localized string m_strNoteWeaponSpecific;
var const localized string m_strNoteInsufficientBays;
var const localized string m_strNoteBuildStalled;
var const localized string m_strNoteMaintenanceCost;
var const localized string m_strNoteFoundryStalled;
var const localized string m_strHelpAdjust;
var const localized string m_strErrEngineers;
var const localized string m_strLabelImmediate;
var const localized string m_strHelp;
var const localized string m_strSatCapacity;

function Init(int iView){}
function DirectInitialize(){}
function UpdateHeader(){}
function UpdateView(){}
function UpdateManufactureItem(){}
function UpdateManButtons(out TManWidget kWidget){}
function UpdateManufactureFacility(){}
function UpdateManufactureFoundry(){}
function OnAccept(){}
function OnSubmitOrder(){}
function OnCancelOrder(){}
function OnMoveToTop(){}
function OnCancelScreen(){}
function bool IsNewProject(){}
function bool ValidateSubmit(){}
function OnIncreaseEngineers(){}
function OnDecreaseEngineers(){}
function OnIncrease(){}
function OnDecrease(){}
function OnNextFocus(){}
function OnPrevFocus(){}
function OnToggleRush(){}
function OnToggleNotify(){}
function OnHelp();
function OnExitScreen(){}
function ReleaseItemFunds(){}
function ReleaseFacilityFunds(){}
function ReleaseFoundryFunds(){}
function RestoreItemFunds(){}
function RestoreFacilityFunds(){}
function RestoreFoundryFunds(){}
function UpdateButtons(){}
function bool ShouldDeleteOrder(){}
function UpdateHighlight(){}
