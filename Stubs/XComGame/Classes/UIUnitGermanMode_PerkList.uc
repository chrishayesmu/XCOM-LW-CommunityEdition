class UIUnitGermanMode_PerkList extends UI_FxsPanel
	dependson(XComPerkManager);
//complete stub

struct UIPerkData
{
    var string strName;
    var string strDescription;
    var string strIcon;
    var EPerkBuffCategory buffCategory;
};

var string m_strTitle;
var array<UIPerkData> m_arrPerkData;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, UI_FxsScreen _screen){}
simulated function PrepareData(EPerkBuffCategory buffCategory, string listTitle, array<int> perkArray, XGUnit kUnit){}
simulated function PrepareItemData(array<EItemType_Info> arrItemInfos){}
simulated function OnInit(){}
simulated function UpdateDisplay(){}
simulated function AS_SetTitle(string Title){}
simulated function AS_AddPerk(string _name, string _description, string _icon){}
