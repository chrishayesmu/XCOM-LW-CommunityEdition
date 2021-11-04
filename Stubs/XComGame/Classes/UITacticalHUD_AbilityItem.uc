class UITacticalHUD_AbilityItem extends Object;
//complete stub

enum eBGColor
{
    eBGC_Cyan,
    eBGC_Purple,
    eBGC_Yellow,
    eBGC_MAX
};

var int m_iType;
var int m_iWeapon;
var int m_iCooldown;
var int m_iCharge;
var bool m_bAvailable;
var bool m_bShowConsoleButtonHelp;
var UITacticalHUD_AbilityItem.eBGColor m_eBgColor;
var string m_strHotkeyLabel;
var UIFxsMovie m_kMovieMgr;
var XComPlayerController m_kController;
var UITacticalHUD_AbilityContainer m_kContainer;

simulated function UpdateData(int Index, XGAbility kAbility, out array<ASValue> arrData){}
simulated function QueueFunctionString(string func, string Param, out array<ASValue> arrData){}
simulated function QueueFunctionNum(string func, float Param, out array<ASValue> arrData){}
simulated function QueueFunctionBool(string func, bool Param, out array<ASValue> arrData){}
simulated function QueueFunctionNull(string func, out array<ASValue> arrData){}
