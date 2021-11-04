class XGFoundryUI extends XGScreenMgr
    config(GameData);
//complete stub

enum EFoundryView
{
    eFoundryView_Table,
    eFoundryView_MAX
};

struct TFoundryHeader
{
    var TText txtTitle;
    var TLabeledText txtEngineers;
};

struct TFoundryTable
{
    var TTableMenu mnuOptions;
    var array<TObjectSummary> arrSummaries;
};

var TFoundryHeader m_kHeader;
var TFoundryTable m_kTable;
var array<int> m_arrResources;
var array<int> m_arrMainMenuOptions;
var array<TFoundryTech> m_arrTechs;
var const localized string m_strLabelProjectCost;
var const localized string m_strLabelProjectCompleted;
var const localized string m_strLabelAvailableProjects;
var const localized string m_strResearchCreditApplies;

function Init(int iView){}
function UpdateView(){}
function PerformTableTransaction(int iTableOption){}
function UpdateHeader(){}
function UpdateTableMenu(){}
function TTableMenuOption BuildTableItem(TFoundryTech kFoundryTech){}
function TObjectSummary BuildSummary(TFoundryTech kFoundryTech){}
function OnChooseTableOption(int iOption){}
function OnLeaveFacility(){}
