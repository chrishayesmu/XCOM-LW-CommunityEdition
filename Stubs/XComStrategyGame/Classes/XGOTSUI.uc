class XGOTSUI extends XGScreenMgr
    config(GameData)
    notplaceable
    hidecategories(Navigation);
//complete stub

enum EOTSView
{
    eOTSView_Table,
    eOTSView_MAX
};

struct TOTSHeader
{
    var TText txtTitle;
    var array<TLabeledText> arrResources;
};

struct TTableItemSummary
{
    var TText txtTitle;
    var TText txtSummary;
    var TImage imgOption;
};

struct TFacilityTable
{
    var TTableMenu mnuOptions;
    var array<TTableItemSummary> arrSummaries;
};

var TOTSHeader m_kHeader;
var TFacilityTable m_kTable;
var array<int> m_arrResources;
var array<TOTSTech> m_arrTechs;
var const localized string m_strLabelOTS;
var const localized string m_strPurchased;

function Init(int iView){}
function UpdateView(){}
function PerformTableTransaction(int iTableOption){}
function string RecordOTSUpgradeUnlocked(TOTSTech TECH){}
function UpdateHeader(){}
function BuildTechList(){}
function UpdateTableMenu(){}
function TTableMenuOption BuildTableItem(TOTSTech kTech){}
function TTableItemSummary BuildItemSummary(TOTSTech kTech){}
function OnChooseTableOption(int iOption){}
function OnLeaveFacility(){}
function GetCurrentSelectionNameAndCost(int iSelection, out string upgradeName, out string upgradeCost){}
