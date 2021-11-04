class UITacticalHUD_AbilityContainer extends UI_FxsPanel
    notplaceable
    hidecategories(Navigation)
	dependson(XGTacticalGameCoreData)
	dependson(UIDialogueBox);
//complete stub

const MAX_NUM_ABILITIES = 15;
const MAX_NUM_ABILITIES_PER_ROW = 7;

var int m_iCurrentIndex;
var array<XGAbility> m_arrAbilities;
var int m_iMouseTargetedAbilityIndex;
var XGUnit m_kTargetingRequestUnit;
var int m_kWatchVar_Enemy;
var int m_iUseOnlyAbility;
var int m_iSelectionOnButtonDown;
var array<UITacticalHUD_AbilityItem> m_arrUIAbilityData;
var const localized string m_sNoTargetsHelp;
var const localized string m_sNoAmmoHelp;
var const localized string m_sNoMedikitTargetsHelp;
var const localized string m_sNoMedikitChargesHelp;
var const localized string m_sNewDefensiveLabel;
var const localized string m_sNewOffensiveLabel;
var const localized string m_sCanFreeAimHelp;
var const localized string m_sHowToFreeAimHelp;
var const localized string m_sNoTarget;
var const localized string m_strAbilityHoverConfirm;
var const localized string m_strHitFriendliesTitle;
var const localized string m_strHitFriendliesBody;
var const localized string m_strHitFriendliesAccept;
var const localized string m_strHitFriendliesCancel;
var const localized string m_strHitFriendlyObjectTitle;
var const localized string m_strHitFriendlyObjectBody;
var const localized string m_strHitFriendlyObjectAccept;
var const localized string m_strHitFriendlyObjectCancel;
var const localized string m_strMeleeAttackName;
var const localized string m_strCooldownPrefix;
var const localized string m_strChargePrefix;

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager, UI_FxsScreen _screen){}
simulated function OnInit(){}
simulated function SetSelectionOnInputPress(int ucmd){}
simulated function bool OnUnrealCommand(int ucmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
function ResetMouse(){}
simulated function TacticalInputRequestSelectAbility(int iIndex){}
function DirectPickAbility(int Index){}
simulated function bool OnAccept(optional string strOption){}
function HitFriendliesDialogue(){}
function HitFriendlyObjectDialogue(){}
simulated function HitFriendliesDialogueCallback(EUIAction eAction){}
function HitFriendliesAccepted(){}
function HitFriendliesDeclined();
simulated function OnFireActionCanceled(){}
simulated function BuildAbilities(XGUnit kUnit){}
simulated function PopulateFlash(out XGUnit kUnit){}
simulated function bool CheckForAvailability(XGAbility kDisplayedAbility){}
simulated function CycleAbilitySelection(int Step){}
simulated function CycleAbilitySelectionRow(int Step){}
simulated function SelectAbility(int Index){}
simulated function int FindAbilityUsingWeapon(XGWeapon kWeapon){}
simulated function int FindAbilityByType(EAbility eType){}
function OnCycleWeapons(){}
simulated function bool AlreadyHaveThisAbilityType(out array<XGAbility> arrAbilities, XGAbility kAbility, XGUnit kTarget){}
simulated function SetAbilityByIndex(int iUnitIndex){}
simulated function int GetFirstActiveAbility(){}
function XGUnit GetMouseTargetedUnit(){}
simulated function XGAbility GetSelectedAbility(optional int Index=-1){}
simulated function XGAbility GetDisplayedAbility(){}
simulated function bool IsSelectedValue(int I){}
simulated function int GetSelectedIndex(){}
simulated function bool CheckForNotifier(XGUnit kUnit){}
simulated function bool IsAbilityValidWithoutTarget(XGAbility kAbility){}
simulated function CheckForHelpMessages(){}
simulated function UpdateHelpMessage(string strMsg){}
simulated function UpdateWatchVariables(){}
simulated function OnFreeAimChange(){}
simulated function bool IsEmpty(){}
simulated function AS_SetShotInfoOKButton(string okLabel){}
simulated function AS_SetConsoleButtonHelp(string Icon){}
simulated function AS_SetNumActiveAbilities(int numAbilies){}
