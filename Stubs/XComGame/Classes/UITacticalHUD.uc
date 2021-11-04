class UITacticalHUD extends UI_FxsScreen;
//complete stub

enum eUI_ReticleMode
{
    eUIReticle_NONE,
    eUIReticle_Offensive,
    eUIReticle_Overshoulder,
    eUIReticle_Defensive,
    eUIReticle_MAX
};

var array<UITargetingReticle> m_arrReticles;
var eUI_ReticleMode m_eReticleMode;
var UITacticalHUD_WeaponContainer m_kWeaponContainer;
var UITacticalHUD_InfoPanel m_kInfoBox;
var UITacticalHUD_AbilityContainer m_kAbilityHUD;
var UITacticalHUD_SoldierStatsContainer m_kStatsContainer;
var UITacticalHUD_Radar m_kRadar;
var UITacticalHUD_PerkContainer m_kPerks;
var UITacticalHUD_ObjectivesList m_kObjectives;
var UITacticalHUD_MouseControls m_kMouseControls;
var UIStrategyTutorialBox m_kTutorialHelpBox;
var bool m_isMenuRaised;
var private bool m_bForceOverheadView;
var bool m_bHelpTipsDisabled;
var string m_strReticleMsg;
var float m_fReticleAimPercentage;
var float m_fReticleAimCritical;

simulated function OnToggleHUDElements(SeqAct_ToggleHUDElements Action)
{}
simulated function Init(XComTacticalController _controllerRef, UIFxsMovie _manager){}
simulated function OnInit(){}
simulated function bool CalcDependantVariablesAreInitialized(){}
simulated function bool OnUnrealCommand(int Cmd, int Arg){}
simulated function bool OnMouseEvent(int Cmd, array<string> args){}
simulated function SetForceOverheadView(){}
simulated function bool SelectNextTarget(){}
simulated function bool SelectPreviousTarget(){}
simulated function RaiseTargetSystem(){}
simulated function LowerTargetSystem(){}
simulated function CancelTargetingAction(){}
simulated function OnFireActionCanceled(){}
simulated function UpdateAbilityMenu(out XGUnit kUnit){}
simulated function RealizeTargettingReticules(out XGUnit kUnit){}
simulated function Update(){}
simulated function OnAbilityChanged(){}
simulated function OnFreeAimChange(){}
function CreateReticles(XGAbility_Targeted kAbility){}
function ClearReticles(){}
simulated function SetReticleMessages(string msg){}
simulated function LockTheReticles(bool bLock){}
simulated function SetReticleAimPercentages(float fPercent, float fCritical){}
simulated function UITargetingReticle GetReticle(int Index){}
simulated function XGAbility GetCurrentAbility(){}
simulated function eUI_ReticleMode GetReticleMode(){}
simulated function SetReticleMode(eUI_ReticleMode eMode){}
simulated function Show(){}
simulated function Hide(){}
simulated function InitializeMouseControls(){}
simulated function bool IsMenuRaised(){}
simulated function OpenGermanMode(){}
simulated function bool CanOpenGermanMode(){}
simulated function ShowTutorialHelp(string strHelpText, float DisplayTime){}
simulated function HideTutorialHelp(){}
