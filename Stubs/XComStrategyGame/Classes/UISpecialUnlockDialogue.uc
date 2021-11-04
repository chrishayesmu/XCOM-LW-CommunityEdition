class UISpecialUnlockDialogue extends UI_FxsScreen
    hidecategories(Navigation);
//complete stub

enum ESpecialUnlockType
{
    eSU_Mech,
    eSU_GeneMod,
    eSU_MAX
};

struct TSpecialUnlockData
{
    var ESpecialUnlockType eType;
    var string strImage;
    var EPerkType genePerk;
    var EItemType mecWeapon0;
    var EItemType mecWeapon1;
    var string strMecName;
};

var const localized string m_strMechUnlockTitle;
var const localized string m_strGeneModUnlockTitle;
var const localized string m_strMechRequirement;
var const localized string m_strGeneModRequirement;
var const localized string m_strButtonLabel;
var const localized string m_kTheOrString;
var XComPerkManager m_kPerkMgr;
var private array<TItemUnlock> m_arrData;
var private int m_iCurrentDataIndex;

simulated function Init(XComPlayerController _controllerRef, UIFxsMovie _manager){}
simulated function OnInit(){}
simulated function AddDialog(TItemUnlock kData){}
simulated function Realize(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function bool OnCancel(optional string Arg){}
simulated function Remove(){}
simulated function AS_SetTitle(string txt){}
simulated function AS_SetRequirement(string txt){}
simulated function AS_SetMechData(string mecName, string abilityName0, string abilityDescription0, string abilityIcon0, string abilityName1, string abilityDescription1, string abilityIcon1, string theOrString){}
simulated function AS_SetGeneModData(string abilityName, string abilityDescription, string abilityIcon){}
simulated function AS_SetMechImage(string imgPath){}
simulated function AS_SetGeneModImage(string imgPath){}
simulated function AS_SetButtonData(string Label, string Icon){}
