class UIProtoWidget extends UI_FxsPanel
    abstract
    notplaceable
    hidecategories(Navigation);
//complete stub

var protected string m_strGroup;
var protected bool m_bIdSet;
var protected bool m_bCenterHorizontal;
var protected bool m_bCenterVertical;
var protected bool m_bImmediateUpdate;
var protected float m_x;
var protected float m_y;
var protected Color m_kColor;

function Init(UIProtoScreen _screen){}
simulated function OnInit(){}
function EndMultipleUpdate(){}
function BeginMultipleUpdate(){}
function Update();
function SetName(coerce name strName){}

function name GetName(){}
function SetGroup(string strGroup){}
function string GetGroup(){}
function SetX(float fX){}
function float GetX(){}
function SetY(float fY){}
function float GetY(){}
function SetXY(float fX, float fY){}
function SetCentered(optional bool bHorizontal, optional bool bVertical){}
function SetColor(Color kNewColor){}
function SetColorFromEnum(EWidgetColor eColor, optional EColorShade eShade){}
function SetAlpha(byte byAlpha){}
function bool isOnScreen(){}
function bool IsCenteredHorizontally(){}
function bool IsCenteredVertically(){}
function Color GetColor(){}
static function Color CreateColor(EWidgetColor eColor, optional EColorShade eShade, optional int A=255){}
function RemoveFlashObject(){}
simulated function Hide(){}
simulated function Show(){}
