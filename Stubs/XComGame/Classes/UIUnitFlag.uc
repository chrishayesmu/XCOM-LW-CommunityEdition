class UIUnitFlag extends UI_FxsPanel;
//complete stub

enum EUnitFlagTargetingState
{
    eUnitFlagTargeting_None,
    eUnitFlagTargeting_Dim,
    eUnitFlagTargeting_Active,
    eUnitFlagTargeting_MAX
};

var Vector2D m_positionV2;
var int m_scale;
var XGUnit m_kUnit;
var XGCharacter m_kCharacter;
var bool m_bIsFriendly;
var bool m_bIsDead;
var bool m_bIsSelected;
var bool m_bLockToReticle;
var bool m_bShowingBuff;
var bool m_bShowingDebuff;
var int m_iScaleOverride;
var int m_ekgState;
var EUnitFlagTargetingState m_eState;
var int m_WatchReticleLocation;
var int m_WatchReticleVisibility;
var UITargetingReticle m_kReticle;

simulated function Init(XComPlayerController _controller, UIFxsMovie _manager, UI_FxsScreen _screen, XGUnit kUnit){}
simulated function OnInit(){}
simulated function UpdateBuffs(){}
simulated function Update(XGUnit kNewActiveUnit){}
simulated function SetPosition(int X, int Y, int Scale){}
simulated function SetScaleOverride(int iOverride){}
simulated function PreviewMoves(int iMoves){}
simulated function SetNames(string unitName, string unitNickName){}
simulated function SetDebugText(string strDisplayText){}
simulated function RealizeAim(){}
simulated function SetAim(int aimPercent){}
simulated function RealizeHitPoints(){}
simulated function RealizeCriticallyWounded(){}
simulated function RealizeStunned(){}
simulated function SetHitPoints(int _currentHP, int _maxHP){}
simulated function SetShieldPoints(int _currentShields, int _maxShields){}
simulated function SetHitPointsPreview(optional int _iPossibleDamage){}
simulated function SetShieldPointsPreview(optional int _iPossibleDamage){}
simulated function RealizeModifiers(){}
simulated function SetModifiers(bool bOffenseBuff, int iOffenseBuffArrows, bool bOffenseDebuff, int iOffenseDebuffArrows, bool bDefenseBuff, int iDefenseBuffArrows, bool bDefenseDebuff, int iDefenseDebuffArrows){}
simulated function RealizeRank(){}
simulated function SetRank(int Rank){}
simulated function SetWeapon(){}
simulated function RealizeMoves(){}
simulated function RealizeActive(){}
simulated function EndTurn(){}
simulated function RealizeCover(){}
simulated function ShowExtension(){}
simulated function HideExtension(){}
simulated function SetSelected(bool isSelected){}
simulated function RealizeAlphaSelection(){}
simulated function RealizeTargetedState(){}
simulated function RealizeEKG(){}
simulated function SetAlphaState(UIUnitFlag.EUnitFlagTargetingState eState){}
simulated function Show(){}
simulated function Hide(){}
simulated function bool IsAttachedToUnit(XGUnit possibleUnit){}
simulated function bool IsStunnedOutsider(){}
simulated function LockToReticle(bool bShouldLock, UITargetingReticle kReticle){}
simulated function UpdatePositionFromReticle(){}
simulated function UpdateVisibleFromReticle(){}
simulated function Remove(){}
simulated function RealizeBuffs(){}
simulated function RealizeDebuffs(){}
simulated function ShowBuff(bool bShow){}
simulated function ShowDebuff(bool bShow){}
