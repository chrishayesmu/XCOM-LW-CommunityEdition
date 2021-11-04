class UIScreen extends UIProtoScreen
    abstract
    notplaceable
    hidecategories(Navigation)
    implements(IScreenMgrInterface)
	DependsOn(XGTacticalScreenMgr)
	DependsOn(XGNarrative);

//complete stub
const DBWIDTH = 0.5f;
const DBHEIGHT = 0.4f;
const DBIMAGE_WIDTH = 0.15f;
const DBTITLE_HEIGHT = 0.05f;
const IMAGE_SPACING = 4;

struct TUITableMenu
{
    var UIProtoWidget_Text txtHeader;
    var UIProtoWidget_Menu mnuOptions;
    var array<int> arrSpacing;
};

var XGTacticalScreenMgr m_kTacMgr;
var bool m_bInited;
var bool m_bHasHelp;
var TRect m_rectHelp;
var array<TText> m_arrHelpText;
var array<TUITableMenu> m_arrTableMenus;
var array<TItemUnlock> m_arrUnlocks;
var Color m_clrBackground;
var Color m_clrHelpBackground;
var Color m_clrPanels;
var Color m_clrHeaders;
var Color m_clrNormal;
var Color m_clrHighlight;
var Color m_clrDisabled;
var Color m_clrGood;
var Color m_clrBad;
var Color m_clrWarning;
var Color m_clrMenuBG;
var Color m_clrTextNormal;
var Color m_clrTextHighlight;
var Color m_clrTextDisabled;
var Color m_clrTextGood;
var Color m_clrTextBad;
var Color m_clrTextWarning;
var Color m_clrTextTech;
var Color m_clrTextAlloys;
var Color m_clrTextElerium;
var Color m_clrTextCash;
var Color m_clrTextMenu;

function UIInit(){}
function InitMgr(class<Actor> kMgrClass, optional int iView){}
function int GetCurrentView(){}
simulated function OnInit(){}
function GoToView(int iView){}
function UpdateUI(){};
function UnlockItem(TItemUnlock kUnlock){}
function BeginUnlocks(){}
function ClearUI(){}
function name GetViewState(int iView);
function UIProtoWidget_Rect DrawRect(string strName, TRect kRect, optional Color clrRect){}
function UIProtoWidget_Line DrawLine(string strName, Vector2D v2Start, Vector2D v2End, optional int iLineWidth, optional Color clrLine){}
function UIProtoWidget_Circle DrawCircle(string strName, Vector2D v2Center, float fRadius, Color clrCircle){}
function UIProtoWidget_Panel DrawPanel(string strName, TRect kRect, optional Color clrPanel){}
function UIProtoWidget_Text DrawText(string strName, TText kText, Vector2D v2ScreenCoords, optional int iSize, optional bool bCenterHorizontal, optional bool bCenterVertical, optional float fWrap){}
function UIProtoWidget_Text DrawString(string strName, string strText, Color clrText, Vector2D v2ScreenCoords, optional int iSize, optional bool bCenterHorizontal, optional bool bCenterVertical, optional float fWrap){}
function UIProtoWidget_Text DrawButtonText(string strName, TButtonText kText, Vector2D v2ScreenCoords, optional int iSize, optional bool bCenterHorizontal, optional bool bCenterVertical){}
function DrawButtonBar(TButtonBar kBar, TRect kRect, optional Color clrBar){}
function UIProtoWidget_Text DrawLabeledText(string strName, TLabeledText kText, Vector2D v2ScreenCoords, optional int iSize, optional bool bCenterHorizontal, optional bool bCenterVertical, optional bool bDrawBG){}
function UIProtoWidget_Text DrawLabeledNumberText(string strName, TLabeledText kText, Vector2D v2ScreenCoords, optional int iSize, optional bool bCenterHorizontal, optional bool bCenterVertical){}
function UIProtoWidget_Image DrawImage_OLD(string strName, TImage kImage, Vector2D v2ScreenCoords, float fScale, optional bool bCenterHorizontal, optional bool bCenterVertical, optional float fAlpha){}
function Vector2D DrawImage(string strName, TImage kImage, TRect kRect, optional float fAlpha, optional float fFailScale){}
function float GetImageScale(string strImage, out TRect kRect, out Vector2D v2Size){}
function UIProtoWidget_Menu DrawMenu(string strName, TMenu kMenu, Vector2D v2ScreenCoords, optional int iFontSize, optional Color clrMenuBG, optional Color clrMenuText){}
function UIProtoWidget_Menu DrawTableMenu(name strName, TTableMenu kTableMenu, Vector2D v2ScreenCoords, optional int iFontSize){}
function DrawProgressGraph(string strName, TProgressGraph kGraph, TRect kRect){}
function DrawNode(string strName, TGraphNode kNode, TRect kRect){}
function int GetUITableMenuIndex(name strName){}
function DrawMenuOptions(TMenu kMenu, UIProtoWidget_Menu kUIMenu){}
function AddMenuOptions(int iNumToAdd, UIProtoWidget_Menu kMenu){}
function RemoveMenuOptions(int iNumToRemove, UIProtoWidget_Menu kMenu){}
function UpdateMenuOptions(TMenu kMenu, UIProtoWidget_Menu kUIMenu){}

function DrawTableMenuOptions(TTableMenu kTableMenu, int iUITableMenu){}
function AddTableMenuOptions(int iNumToAdd, TTableMenu kTableMenu, int iUITableMenu){}
function RemoveTableMenuOptions(int iNumToRemove, UIProtoWidget_Menu kTableMenu){}
function UpdateTableMenuOptions(TTableMenu kTableMenu, int iTableMenu){}
function DrawTableOptionImages(TTableMenu kTableMenu, int iTableMenu){}
function GetOptionImageRect(int iOption, int iCategory, int iUITableMenu, out TRect kRect){}
function DetermineTableMenuSpacing(TTableMenu kTableMenu, int iTableMenu){}
function string BuildHeaderString(TTableMenu kTableMenu, int iUITableMenu){}
function string BuildOptionString(TTableMenu kTableMenu, int iUITableMenu, int iOption){}
function bool IsImageCategory(int iCategory){}
function int GetCategorySpacing(int iUITableMenu, int iCategory){}
function Color GetUIStateColor(int iState, optional bool bText){}
function string GetImagePath(int iImage){}
static function string GetFlagPath(int iCountry){}
function BuildBackground(optional Color clrBG){}
function SetHelpRect(TRect kRect){}
function DrawHelp(int iOption){}
function DrawHelpText(TText kHelpText){}
function float GetTextHeight(int iPointSize){}
function float GetTextLetterWidth(int iPointSize){}
function float GetTextWidth(TText kText, int iPointSize){}
function int GetFontForHeight(float fHeight){}
function int GetFontForWidth(string strText, float fWidth){}
function float HeightToWidth(float fHeightScreenSpace){}
function float WidthToHeight(float fWidthScreenSpace){}
function TRect Rect(float fLeft, float fTop, float fRight, float fBottom){}
function float RectWidth(TRect kRect){}
function float RectHeight(TRect kRect){}
function Vector2D RectCenter(TRect kRect){}
function float RectCenterX(TRect kRect){}
function float RectCenterY(TRect kRect){}
function Vector2D RectCenterTop(TRect kRect, int iFontSize){}
function Vector2D RectCenterBottom(TRect kRect, int iFontSize){}
function Vector2D RectRightCenter(TRect kRect, TText txtText, int iFontSize){}
function Vector2D RectLeftCenter(TRect kRect, int iFontSize){}
function TRect ScaleRect(TRect kRect, float fScale){}
function string GetButtonStringCode(int iButton, int iIconSize){}
function Color Black(optional byte A){}
function Color Red(optional byte A){}
function Color Green(optional byte A){}
function Color Blue(optional byte A){}
function Color Cyan(optional byte A){}
function Color Yellow(optional byte A){}
function Color ORANGE(optional byte A){}
function Color PURPLE(optional byte A){}
function Color White(optional byte A){}
function Color Gray(optional byte A){}
function Color BROWN(optional byte A){}

state View{
    event BeginState(name P){}
    event EndState(name P){}
    simulated function bool OnOption(optional string strOption){}
	}

state DialogueBox extends View{
    event PushedState(){}
    function Color GetColor(){}
    simulated function bool OnAccept(optional string strOption){}
    function Close(){}
    simulated function bool OnOption(optional string strOption){}
    simulated function bool OnCancel(optional string strOption){}
    simulated function bool InputButtonY(){}
    simulated function bool InputButtonX(){}
    simulated function bool InputPadLeft(){}
    simulated function bool InputPadRight(){}
    simulated function bool InputPadUp(){}
    simulated function bool InputPadDown(){}
    simulated function bool InputLeftBumper(){}
    simulated function bool InputRightBumper(){}
    simulated function bool InputLeftTrigger(){}
    simulated function bool InputRightTrigger(){}
    simulated function bool InputButtonStart(){}
    simulated function bool InputButtonBack(){}
}
state UnlockBox extends View{
    event PushedState(){}
    function UpdateUI(){}

    function Color GetColor(){}
    function DrawBG(){}
    function DrawDBox(){}
    simulated function bool OnAccept(optional string strOption){}
    function Close(){}
    simulated function bool OnOption(optional string strOption){}
    simulated function bool OnCancel(optional string strOption){}
    simulated function bool InputButtonY(){}
    simulated function bool InputButtonX(){}
    simulated function bool InputPadLeft(){}
    simulated function bool InputPadRight(){}
	simulated function bool InputPadUp(){}
    simulated function bool InputPadDown(){}
    simulated function bool InputLeftBumper(){}
    simulated function bool InputRightBumper(){}
    simulated function bool InputLeftTrigger(){}
    simulated function bool InputRightTrigger(){}
    simulated function bool InputButtonStart(){}
    simulated function bool InputButtonBack(){}
}
