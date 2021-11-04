class UISoldierPromotion extends UI_FxsScreen
	implements(IScreenMgrInterface);

const BONUS_STATS_TEXT_SIZE = 20;
const UNKNOWN_ICON_LABEL = "unknown";

enum EColumnHighlightState
{
    eCHS_Off,
    eCHS_On,
    eCHS_Faded,
    eCHS_Locked,
    eCHS_MAX
};

var const localized string m_strStatHealth;
var const localized string m_strStatWill;
var const localized string m_strStatDefense;
var const localized string m_strStatOffense;
var const localized string m_strOKCantPromote;
var const localized string m_strCantConfirmBodyText;
var const localized string m_strTitleConfirmPromotion;
var const localized string m_strTitleCannotDoPromotion;
var const localized string m_strOKPromote;
var const localized string m_strCancelPromote;
var const localized string m_strAcceptBodyText;
var const localized string m_strConfirmBodyText;
var const localized string m_strNormalAbilitiesTitle;
var const localized string m_strPsiAbilitiesTitle;
var XGSoldierUI m_kLocalMgr;
var string m_strCameraTag;
var name DisplayTag;
var SkeletalMeshActor m_kCameraRig;
var Vector m_kCameraRigDefaultLocation;
var float m_kCameraRigMecVerticalOffset;
var bool m_bPsiPromotion;
var bool m_bMECPromotion;
var XGStrategySoldier m_kSoldier;
var UIStrategyComponent_SoldierInfo m_kSoldierHeader;
var UIStrategyComponent_SoldierStats m_kSoldierStats;
var UISoldierPromotion_MecBonusAbility m_kMecSoldierStats;

simulated function Init(XGStrategySoldier kSoldier, XComPlayerController _controllerRef, UIFxsMovie _manager, bool _psiPromote, bool _mecPromote){}
simulated function XGSoldierUI GetMgr(optional int iStaringView){}
simulated function OnInit(){}
simulated function InitializeTree(){}
simulated function CheckForAutoAssignPerk(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function UpdateAbilityData(){}
final simulated function RealizeSelected(optional bool bFirstCall){}
simulated function OnReceiveFocus(){}
simulated function OnMousePrevSoldier(){}
simulated function PrevSoldier(){}
simulated function OnMouseNextSoldier(){}
simulated function NextSoldier(){}
final simulated function UpdateButtonHelp(){}
simulated function GoToView(int iView){}
simulated function bool OnAccept(optional string Str){}
simulated function OnMouseCancel(){}
simulated function bool OnCancel(optional string Str){}
simulated function AcceptDialogue(){}
final function ConfirmDialogue(){}
simulated function CannotAssignPerkDialogueCallback(UIDialogueBox.EUIAction eAction){}
simulated function bool GivePromotion(){}
simulated function AcceptDialogueCallback(UIDialogueBox.EUIAction eAction){}
simulated function ConfirmDialogueCallback(UIDialogueBox.EUIAction eAction){}
simulated function Remove(){}
final simulated function AS_InitializeTree(string titleLabel, string titleIconLabel, bool psi){}
simulated function AS_SetAbilityIcon(int column, int Row, string iconLabel, bool isHighlighted){}
simulated function AS_SetColumnData(int ColumnIndex, string Label, int State){}
simulated function AS_SetSelectedIcon(int column, int Row){}
simulated function AS_SetAbilityDescription(string abilityName, string abilityDescription){}
simulated function AS_SetSoldierStats(string _health, string _will, string _defense, string _offense){}
function OnDeactivate(){}
event Destroyed(){}
