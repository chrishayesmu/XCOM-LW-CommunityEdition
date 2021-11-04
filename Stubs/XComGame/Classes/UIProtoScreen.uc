class UIProtoScreen extends UI_FxsScreen
    notplaceable
    hidecategories(Navigation);

enum EMenuStates
{
    eState_Disabled,
    eState_Enabled,
    eState_MAX
};

var array<UIProtoWidget> m_arrWidgets;
var string m_strReturn;
var bool m_bAllowsScrolling;
var bool m_bLeftAnalogVScrolling;
var bool m_bLeftAnalogHScrolling;
var bool m_bIgnoreInput;
var bool m_bHorizontalInput;
var float m_fLeftAnalogRepeatTimer;
var UIProtoWidget m_kFocus;
var int m_iCurrentSelection;
var int m_InputNextContainer;
var int m_InputPrevContainer;
var int m_InputNextItem;
var int m_InputPrevItem;

simulated function BaseInit(XComPlayerController _controller, UIFxsMovie _manager, optional delegate<OnCommandCallback> CommandFunction){}
simulated function XComPlayerController GetController(){}
simulated function UIFxsMovie GetManager(){}
simulated function OnInit(){}
simulated function OnDeactivate();

simulated function IgnoreInput(optional bool isIgnoring){}
simulated function OnCommand(string Cmd, string Arg){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnOption(optional string strOption){}
simulated function bool OnAccept(optional string strOption){}
simulated function bool OnCancel(optional string strOption){}
simulated function bool OnInput(string strInput, int nAction){}
function bool AllowsScrolling(){}
function DebugSetupInitialValues(){}
function UpdateLocation(name ObjectName, optional float xPer, optional float yPer){}
function ShowObject(coerce name ObjectName){}
function HideObject(coerce name ObjectName){}
function SetHighlighted(string ObjectName, bool isHighlighted){}
function CreateMenu(coerce name MenuName, array<UIProtoWidget_Text> arrItems, array<UIProtoScreen.EMenuStates> arrItemStates, optional bool centerH, optional bool centerV, optional bool isUniformW){}
function UpdateMenu(coerce name MenuName, array<UIProtoWidget_Text> arrItems, array<UIProtoScreen.EMenuStates> arrItemStates, int nSelectedIndex){}
function bool SetSelected(name Id){}
function bool SelectNextMenu(){}
function bool SelectPrevMenu(){}
function string GetSelectedIndex(){}
function bool SelectNextItem(){}
function bool SelectPrevItem(){}
function bool InputButtonA(){}
function bool InputButtonB(){}
function bool InputButtonX(){}
function bool InputButtonY(){}
function bool InputButtonStart(){}
function bool InputButtonBack(){}
function bool InputPadDown(){}
function bool InputPadUp(){}
function bool InputPadRight(){}
function bool InputPadLeft(){}
function bool InputLeftBumper(){}
function bool InputRightBumper(){}
function bool InputLeftTrigger(){}
function bool InputRightTrigger(){}
function PostProcessInput(PlayerInput PlayerInput, float fDeltaT){}
function AddTextArea(coerce name textAreaName, string DisplayText, optional float xloc, optional float yloc, optional float maxW, optional int TextSize, optional float Width, optional float Height, optional string TextColor, optional string bgColor, optional int bgAlpha, optional bool centerH, optional bool centerV){}
function UpdateTextAreaString(string textAreaName, string DisplayText){}
function CreateNewPanel(coerce name rectName, optional float xloc, optional float yloc, optional float Width, optional float Height, optional string bgColor, optional int fillAlpha, optional bool centerH, optional bool centerV){}
function CreateNewLine(coerce name lineName, optional float X1, optional float Y1, optional float X2, optional float Y2, optional int lineWidth, optional string LineColor, optional int fillAlpha){}
function CreateNewImage(coerce name newImageClipName, string imagePackageLocation, optional float xloc, optional float yloc, optional int mcScale, optional int fillAlpha, optional bool centerH, optional bool centerV){}
function UpdateImage(coerce name newImageClipName, string imagePackageLocation, optional float xloc, optional float yloc, optional int mcScale){}
function CreateNewColorPicker(coerce name cpName, optional int CurrentRow, optional int CurrentColumn, optional float xloc, optional float yloc, optional float Width, optional float Height, optional bool centerH, optional bool centerV){}
function CreateNewCircle(coerce name sName, optional float xloc, optional float yloc, optional float Width, optional float Height, optional string bgColor, optional int fillAlpha, optional bool centerH, optional bool centerV){}
function AddTextWidget(UIProtoWidget_Text kText){}
function AddPanelWidget(UIProtoWidget_Panel kPanel){}
function AddRectWidget(UIProtoWidget_Rect kRect){}
function AddLineWidget(UIProtoWidget_Line kLine){}
function AddImageWidget(UIProtoWidget_Image kImage){}
function UpdateImageWidget(UIProtoWidget_Image kWidget){}
function AddMenuWidget(UIProtoWidget_Menu kMenu, optional bool bHighlightOnAdd){}
function AddBarGraphWidget(UIProtoWidget_BarGraph kGraph){}
function AddColorPickerWidget(UIProtoWidget_ColorPicker kColorPicker){}
function AddCircleWidget(UIProtoWidget_Circle kCircle){}
function RemoveWidget(UIProtoWidget kWidget){}
function UpdateTextWidget(UIProtoWidget_Text kWidget){}
function UpdatePanelWidget(UIProtoWidget_Panel kWidget){}
function UpdateLineWidget(UIProtoWidget_Line kWidget){}
function UpdateMenuWidget(UIProtoWidget_Menu kWidget, optional bool bHighlightOnAdd){}
function UpdateColorPickerWidget(UIProtoWidget_ColorPicker kWidget){}
function UpdateCircleWidget(UIProtoWidget_Circle kWidget){}
function UIProtoWidget GetWidget(coerce name strName){}
function UIProtoWidget_Panel GetPanel(string strName){}
function UIProtoWidget_Text GetText(string strName){}
function UIProtoWidget_Rect GetRect(string strName){}
function UIProtoWidget_Line GetLine(string strName){}
function UIProtoWidget_Menu GetMenu(string strName){}
function UIProtoWidget_Image GetImage(string strName){}
function UIProtoWidget_BarGraph GetBarGraph(string strName){}
function UIProtoWidget_ColorPicker GetColorPicker(string strName){}
function UIProtoWidget_Circle GetCircle(string strName){}
function ShowFullColorPicker(string Widget, bool shouldBeLarge){}
function Color GetBarColorFromValue(float fValue, float fMaxValue){}
function HideBarGraph(string strLabel){}
function ShowBarGraph(string strLabel){}
function HideGroup(string strGroup){}
function ShowGroup(string strGroup){}
function int ToFlashAlpha(Color kColor){}
function string ToFlashHex(Color kColor){}
function string PadString(coerce string strText, int iSpace, optional string strPad){}
static function string ColorString(coerce string StrValue, Color clrNewColor){}

