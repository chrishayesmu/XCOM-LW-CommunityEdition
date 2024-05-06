class UITacticalHUD_AbilityItem extends Object;

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