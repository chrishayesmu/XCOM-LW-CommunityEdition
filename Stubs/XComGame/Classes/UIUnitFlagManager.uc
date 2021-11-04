class UIUnitFlagManager extends UI_FxsScreen
	DependsOn(XGAbility_Targeted);
//complete stub

var array<UIUnitFlag> m_arrFlags;
var bool m_bDebugHardHide;
var bool m_bFlagsInitiallyLoaded;
var bool m_bHideFriendlies;
var bool m_bHideEnemies;
var XGUnit m_lastActiveUnit;

simulated function Init(XComTacticalController _controllerRef, UIFxsMovie _manager){}
simulated function OnInit(){}
simulated function Update(){}
simulated function ForceUpdateBuffs(){}
simulated function AddFlag(XGUnit kUnit){}
simulated function RemoveFlag(UIUnitFlag kFlag){}
simulated function RemoveFlagForUnit(XGUnit kUnit){}
simulated function SetUnitFlagScale(XGUnit kUnit, int iScale){}
simulated function PreviewMoves(XGUnit kUnit, int iMoves){}
simulated function StartTurn(){}
simulated function EndTurn(){}
simulated function Show(){}
simulated function Hide(){}
simulated function ShowAllFriendlyFlags(){}
simulated function HideAllFriendlyFlags(){}
simulated function ShowAllEnemyFlags(){}
simulated function HideAllEnemyFlags(){}
simulated function DebugHardHide(bool bVisible){}
simulated function RefreshAllHealth(){}
simulated function SetShotFlagInfo(array<XGUnit> arrTargets, TShotResult kResult){}
simulated function SetShieldedShotFlagInfo(UIUnitFlag kFlag, XGUnit kUnit, int iPossibleDamage){}
simulated function LockFlagToReticle(bool bShouldLock, UITargetingReticle kReticle, XGUnit kTargetedUnit){}
simulated function ClearShotFlagInfo(){}
simulated function RealizeTargetedStates(){}
simulated function RealizeCover(){}
