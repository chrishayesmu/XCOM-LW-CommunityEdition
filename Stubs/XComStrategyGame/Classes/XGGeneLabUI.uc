class XGGeneLabUI extends XGScreenMgr
    config(GameData)
    notplaceable
    hidecategories(Navigation);
//complete stub

enum EGeneLabView
{
    eGeneLabView_MainMenu,
    eGeneLabView_Add,
    eGeneLabView_Results,
    eGeneLabView_MAX
};

struct TSoldierTable
{
    var TTableMenu mnuSoldiers;

};

struct TGeneSubjectList
{
    var TText txtTitle;
    var TTableMenu mnuSlots;
    var TButtonText btxtChoose;
};

var TGeneSubjectList m_kSubjectList;
var TSoldierTable m_kSoldierTable;
var int m_iHighlightedSlot;
var XGStrategySoldier m_kShuttleSoldier;
var int m_iShuttleSelectedRow;
var int m_iShuttleSelectedCol;
var const localized string m_strLabelCurrentPatients;
var const localized string m_strLabelAddSoldier;
var const localized string m_strLabelHours;
var const localized string m_strLabelDays;
var const localized string m_strLabelEmpty;
var const localized string m_strPsiGiftedStatus;

function Init(int iView){}
function UpdateView(){}
simulated function OnReceiveFocus(){}
simulated function OnLoseFocus(){}
function OnLeaveGeneLab(){}
function OnLeaveResults(){}
function ShuttleSoldierToGeneEditing(XGStrategySoldier kSoldier, int iSelectedRow, int iSelectedCol){}
function bool OnChooseSoldier(int iOption, optional int iSelectedRow, optional int iSelectedCol){}
function OnLeaveSoldierList(){}
function OnSlotHighlighted(int iSlot){}
function OnChooseSlot(int iSlot){}
function UpdateTraineeList(){}
function TGeneSubjectList BuildTrainees(){}
function UpdateSoldierList(){}
function TTableMenuOption BuildSoldierOption(XGStrategySoldier kSoldier, array<int> arrCategories, int soldierListIndex){}
