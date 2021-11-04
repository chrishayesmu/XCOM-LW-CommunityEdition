class UIProtoWidget_Rect extends UIProtoWidget
    notplaceable
    hidecategories(Navigation);
//complete stub

var UIProtoWidget_Line m_kTopBorder;
var UIProtoWidget_Line m_kBottomBorder;
var UIProtoWidget_Line m_kLeftBorder;
var UIProtoWidget_Line m_kRightBorder;
var protected float m_fTop;
var protected float m_fBottom;
var protected float m_fLeft;
var protected float m_fRight;

function Init(UIProtoScreen _screen){}
function Update(){}
simulated function OnInit(){}
function SetRect(float fTop, float fBottom, float fLeft, float fRight){}
function SetX(float fX){}
function SetY(float fY){}
function SetXY(float fX, float fY){}
function BuildLines(){}
function float GetWidth(){}
function float GetHeight(){}
function float GetRight(){}
function float GetLeft(){}
function float GetBottom(){}
function float GetTop(){}
function SetColor(Color kNewColor){}
function SetColorFromEnum(UI_FxsPanel.EWidgetColor eNewColor, optional UI_FxsPanel.EColorShade eShade){}
function SetLineWidth(int iNewWidth){}
function SetAlpha(byte byNewAlpha){}
function SpawnLines(){}
function SetGroup(string strGroup){}
function SetName(coerce name strName){}
simulated function Hide(){}
simulated function Show(){}
function RemoveFlashObject(){}
simulated function Remove(){}
