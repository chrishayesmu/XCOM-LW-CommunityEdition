class UITacticalHUD_PerkContainer extends UI_FxsPanel;
//complete stub

struct TUIPerkInfo
{
    var string strPerkName;
    var string strPerkImage;
    var string strCooldown;
    var string strCharges;
};

var array<TUIPerkInfo> m_arrPerkData;
var const localized string m_strCooldownPrefix;
var const localized string m_strChargePrefix;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager, UI_FxsScreen _screen){}
simulated function OnInit(){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function UpdatePerks(){}
simulated function AddPerk(int Index, string Image, optional string CoolDown="", optional string charges=""){}


DefaultProperties
{
}
