class XGPsiLabsUI extends XGScreenMgr
    config(GameData)
    notplaceable
    hidecategories(Navigation);

enum EBaseView
{
    ePsiLabsView_Main,
    ePsiLabsView_Add,
    ePsiLabsView_Results,
    ePsiLabsView_MAX
};

struct TSoldierTable
{
    var TTableMenu mnuSoldiers;
};

struct TPsiTraineeList
{
    var TText txtTitle;
    var TTableMenu mnuSlots;
    var TButtonText btxtChoose;
};

struct TPsiResultsList
{
    var TText txtTitle;
    var TTableMenu mnuResults;
};

var TPsiTraineeList m_kTraineeList;
var TPsiResultsList m_kResults;
var TSoldierTable m_kSoldierTable;
var int m_iHighlightedSlot;
var int m_iTraineeToBeRemoved;
var bool m_bGift;
var const localized string m_strLabelCurrentTestSubjects;
var const localized string m_strLabelRemoveSoldier;
var const localized string m_strLabelAddSoldier;
var const localized string m_strLabelHours;
var const localized string m_strLabelDays;
var const localized string m_strLabelTestResults;
var const localized string m_strItemEmpty;
var const localized string m_strItemGifted;
var const localized string m_strItemNoGift;
var const localized string m_strConfirmRemovalDialogTitle;
var const localized string m_strConfirmRemovalDialogText;
var const localized string m_strConfirmRemovalDialogAcceptText;
var const localized string m_strPsiLabsPostHelpTitle;
var const localized string m_strPsiLabsPostHelpBody;
var const localized string m_strPsiLabsPostHelpOK;

function Init(int iView){}
function UpdateView(){}
function UpdateTraineeList(){}
function TPsiTraineeList BuildTrainees(){}
function UpdatePsiResults(){}
function TTableMenuOption BuildResultOption(TPsiTrainee kTrainee){}
function OnSlotHighlighted(int iSlot){}
function OnChooseSlot(int iSlot){}
function OnRemoveTrainee(int iSlot){}
function OnConfirmRemoveTrainee(){}
function OnRemoveTraineeDialogConfirm(UIDialogueBox.EUIAction eAction){}
function OnLeaveResults(){}
function OnLeaveFacility(){}
function bool OnChooseSoldier(int iSoldier){}
function OnLeaveSoldierList(){}
function UpdateSoldierList(){}
function TTableMenuOption BuildSoldierOption(XGStrategySoldier kSoldier, array<int> arrCategories, int iSoldierListIndex){}
simulated function OnLoseFocus(){}
simulated function OnReceiveFocus(){}
function PsiLabsPostHelp(){}
