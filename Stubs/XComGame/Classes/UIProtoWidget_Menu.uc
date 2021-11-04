class UIProtoWidget_Menu extends UIProtoWidget
    notplaceable
    hidecategories(Navigation)
	dependsOn(UIProtoScreen);
//complete stub

var protected float m_fMenuItemOffset;
var protected array<UIProtoWidget_Text> m_arrItems;
var protected array<UIProtoScreen.EMenuStates> m_arrItemStates;
var protected bool m_bUniformWidth;
var protected bool m_bCanScroll;
var private bool m_bUpdatePending;
var protected int m_iFontSize;
var protected float m_fOptionWidth;
var protected int m_iCurrentSelection;
var protected int m_iNumVisibleOptions;
var protected int m_iScrollIndex;
var protected Color m_clrText;
var protected UIProtoWidget_Image m_kImage_ArrowUp;
var protected UIProtoWidget_Image m_kImage_ArrowDown;

function Init(UIProtoScreen _screen){}
simulated function OnInit(){}
function Update(){}
function SetTextColor(Color clrText){}
function Color GetTextColor(){}
function AddMenuItem(string strText, optional string Id){}
function RemoveMenuItem(int iItemIndex){}
function ClearMenuItems(){}
function UIProtoWidget_Text GetMenuItem(int iItem){}
function array<UIProtoWidget_Text> GetMenuItems(){}
function int GetNumMenuItems(){}
function SetScrollLimit(int scrollLimit){}
function CreateScrollArrows(){}
function ShowScrollbar(){}
function HideScrollbar(){}
private final function SetSelected(int iItem){}
function SetSelectedBoundsCheck(int iItem){}
function UpdateScrolledDisplay(){}
function int GetSelectedIndex(){}
function array<UIProtoScreen.EMenuStates> GetMenuItemStates(){}
function SetMenuItemOffset(float fNewOffset){}
function float GetMenuItemOffset(){}
function SetFontSize(int iPointSize){}
function int GetFontSize(){}
function SetMenuItemState(int iMenuItem, UIProtoScreen.EMenuStates eState){}
function SetOptionWidth(float fWidth){}
function bool IsUniformWidth(){}
function SetUniformWidth(bool bUniform){}
