class UIProtoWidget_BarGraph extends UIProtoWidget
    notplaceable
    hidecategories(Navigation);
//complete stub

var protected float m_fWidth;
var protected float m_fHeight;
var protected float m_fPercentage;
var UIProtoWidget_Panel m_kBGBar;
var UIProtoWidget_Panel m_kValueBar;
var UIProtoWidget_Text m_txtLabel;
var UIProtoWidget_Text m_txtValue;
var protected string m_strLabel;
var protected string m_strValue;


function Init(UIProtoScreen _screen){}
function SetValues(float fX, float fY, float fWidth, float fHeight, string strLabel, string StrValue, float fPercentage){}
function UpdateValue(float fNewPercentage, string strNewValue, optional float fNewThreshold){}
simulated function bool IsInited(){}
function InitWidgets(){}
function Update(){}
simulated function Hide(){}
simulated function Show(){}
