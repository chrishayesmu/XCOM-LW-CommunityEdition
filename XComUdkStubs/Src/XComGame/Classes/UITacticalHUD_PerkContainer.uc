class UITacticalHUD_PerkContainer extends UI_FxsPanel
    notplaceable
    hidecategories(Navigation);

struct TUIPerkInfo
{
    var string strPerkName;
    var string strPerkImage;
    var string strCooldown;
    var string strCharges;
};

var private array<TUIPerkInfo> m_arrPerkData;
var const localized string m_strCooldownPrefix;
var const localized string m_strChargePrefix;

defaultproperties
{
    s_name="perkContainer"
}