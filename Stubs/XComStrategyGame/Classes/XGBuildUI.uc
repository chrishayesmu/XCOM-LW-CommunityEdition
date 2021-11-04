class XGBuildUI extends XGScreenMgr;

//completet  stub

enum EBuildView
{
    eBuildView_Main,
    eBuildView_Menu,
    eBuildView_MAX
};

enum EBuildCursorState
{
    eBCS_Excavate,
    eBCS_BuildFacility,
    eBCS_BuildAccessLift,
    eBCS_RemoveFacility,
    eBCS_BeginConstruction,
    eBCS_Cancel,
    eBCS_CantDo,
    eBCS_MAX
};

struct TFacilityTable
{
    var TTableMenu mnuOptions;
    var array<TObjectSummary> arrSummaries;
    var array<int> arrFacilities;
};

struct TUIBaseTile
{
    var TTerrainTile kTile;
    var TText txtLabel;
    var TText txtCounter;
    var TImage imgTile;
    var bool bDisabled;
};

struct TUIFacilityTile
{
    var TFacilityTile kTile;
    var TText txtLabel;
    var TText txtCounter;
    var TImage imgTile;
    var bool bDoubleSize;
    var bool bAdjacencyBonusLeft;
    var bool bAdjacencyBonusTop;
};

struct TBuildCursor
{
    var int X;
    var int Y;
    var int iSize;
    var int iCursorState;
    var int iUIState;
    var TButtonText txtLabel;
    var TText txtCost;
    var TText txtHelp;

};

struct TBuildHeader
{
    var TLabeledText txtCash;
    var TLabeledText txtPower;
    var TLabeledText txtElerium;
    var TLabeledText txtAlloys;

};

var array<TUIBaseTile> m_arrTiles;
var array<TUIFacilityTile> m_arrFacilityTiles;
var TBuildCursor m_kCursor;
var TBuildHeader m_kHeader;
var TFacilityTable m_kTable;
var bool m_bFacilityBuilt;
var bool m_bCantRemove;
var const localized string m_strLabelCancel;
var const localized string m_strLabelRemove;
var const localized string m_strLabelBuildLift;
var const localized string m_strLabelBuildFacility;
var const localized string m_strLabelExcavate;
var const localized string m_strLabelRequiredBuild;
var const localized string m_strLabelExcavating;
var const localized string m_strLabelSteam;
var const localized string m_strLabelDays;
var const localized string m_strLabelRemoving;
var const localized string m_strLabelCost;
var const localized string m_strOK;
var const localized string m_strErrNeedLift;
var const localized string m_strErrNeedExcavating;
var const localized string m_strErrNeedFunds;
var const localized string m_strErrNeedPower;
var const localized string m_strErrNeedSteam;
var const localized string m_strPriority;
var const localized string m_strRemoveTitle;
var const localized string m_strRemoveBody;
var const localized string m_strRemoveOK;
var const localized string m_strRemoveCancel;
var const localized string m_strCantRemoveTitle;
var const localized string m_strPowerCantRemoveBody;
var const localized string m_strCaptiveCantRemoveBody;
var const localized string m_strCaptiveRemoveBody;
var const localized string m_strWorkshopCantRemoveBody;
var const localized string m_strUplinkCantRemoveBody;
var const localized string m_strFoundryCantRemoveBody;
var const localized string m_strPsiLabsCantRemoveBody;
var const localized string m_strGeneLabsCantRemoveBody;
var const localized string m_strCyberneticsLabsCantRemoveBody;
var const localized string m_strCyberneticsLabsCantRemoveMecs;
var const localized string m_strCancelConstructionTitle;
var const localized string m_strCancelConstructionBody;
var const localized string m_strCancelConstructionOK;
var const localized string m_strCancelConstructionCancel;
var const localized string m_strDisabledForTutorial;
var int m_iLastTileIndex;

function Init(int iView){}
function int GetTilesWide(){}
function int GetTilesHigh(){}

function UpdateView(){}

function OnChooseTile(){}
function OnCursorLeft(){}
function OnCursorRight(){}
function OnCursorUp(){}
function OnCursorDown(){}
function SetCursorAt(int TileX, int TileY){}
function OnChooseFacility(int iOption){}
function OnLeaveTable(){}
function OnLeaveScreen(){}
function OnFacilityOption(){}
function UpdateHeader(){}
function UpdateCursor(){}
function UpdateFacilityTable(){}
function TTableMenuOption BuildFacilityOption(TFacility kFacility, array<int> arrCategories){}
function int SortFacilities(TFacility kFacility1, TFacility kFacility2){}
function TObjectSummary BuildSummary(TFacility kFacility){}
function UpdateTiles(){}
function RemoveTerrainTileLabelAtIndex(int TileIndex){}
function TUIBaseTile BuildBaseTile(int iTileIndex){}
function TUIFacilityTile BuildFacilityTile(int iTileIndex){}
function bool CanRemoveFacility(int iFacility){}
function string GetCostString(TProjectCost kCost){}
function int GetCursorLevel(){}
simulated function OnReceiveFocus(){}
function ConfirmRemovalDialogue(int X, int Y){}
simulated function ConfirmRemovalDialogueCallback(EUIAction eAction){}
function ConfirmCancelConstructionDialogue(){}
simulated function ConfirmCancelConstructionDialogueCallback(EUIAction eAction){}

