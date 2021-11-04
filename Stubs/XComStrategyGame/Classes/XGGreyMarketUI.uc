class XGGreyMarketUI extends XGScreenMgr
    config(GameData);
//complete  stub

enum EGreyMarketView
{
    eGreyMarketView_MainMenu,
    eGreyMarketView_LeftMarket,
    eGreyMarketView_MAX
};

struct TGreyMarketHeader
{
    var array<TLabeledText> arrResources;
};

struct TGreyMarketListHeader
{
    var TText txtStorageLabel;
    var TText txtSellLabel;
    var TText txtTotalCredits;
};

struct TGreyMarketItem
{
    var TText txtNumInStorage;
    var TButtonText btxtToStorage;
    var TText txtItemName;
    var TText txtResearchStatus;
    var TText txtItemPrice;
    var TButtonText btxtToSell;
    var TText txtNumForSale;
    var TText txtCredits;
    var bool bCanBeSold;
    var bool bBulk;
    var bool bNotResearched;
    var int iSelling;
};

struct TGMSummary
{
    var TImage imgItem;
    var TText txtName;
    var TText txtSummary;
};

struct TGreyMarketBuyButton
{
    var TButtonText btxtConfirm;
    var EUIState eState;
};

var TGreyMarketHeader m_kHeader;
var TGreyMarketListHeader m_kListHeader;
var array<TGreyMarketItem> m_arrItemList;
var TGreyMarketBuyButton m_kBuyButton;
var TGMSummary m_kItemSummary;
var array<TItem> m_arrItems;
var int m_iHighlight;
var int m_iTotal;
var const localized string m_strLabelInStorage;
var const localized string m_strLabelSell;
var const localized string m_strLabelCompleteTransaction;
var const localized string m_strNotResearched;
var const localized string m_strCanNotSell;
var const localized string m_strNoMoreItems;

function Init(int iView){}
function BuildItemList(){}
function AddSpecialItemsToList(EItemType eItem){}
function UpdateView(){}
function OnSellItem(){}
function OnReturnItem(){}
function ReturnAllItems(){}
function OnHighlightUp(){}
function OnHighlightDown(){}
function SetHighlighted(optional int Target){}
function OnCompleteTransaction(){}
function string RecordGreyMarketSale(){}
function UpdateHeader(){}
function UpdateMain(){}
function UpdateItem(){}
function UpdateList(){}
function BuildItemProperties(){}
function UpdateListHeader(){}
function UpdateBuyButton(bool bValid){}
function OnLeaveFacility(){}
