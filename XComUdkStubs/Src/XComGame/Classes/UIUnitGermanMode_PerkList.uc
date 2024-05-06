class UIUnitGermanMode_PerkList extends UI_FxsPanel
    dependson(XComPerkManager)
    notplaceable
    hidecategories(Navigation);

struct UIPerkData
{
    var string strName;
    var string strDescription;
    var string strIcon;
    var EPerkBuffCategory buffCategory;
};

var private string m_strTitle;
var private array<UIPerkData> m_arrPerkData;