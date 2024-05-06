class UIUnitFlag extends UI_FxsPanel
    notplaceable
    hidecategories(Navigation);

const WORLD_Y_OFFSET = 40;

enum EUnitFlagTargetingState
{
    eUnitFlagTargeting_None,
    eUnitFlagTargeting_Dim,
    eUnitFlagTargeting_Active,
    eUnitFlagTargeting_MAX
};

var protected Vector2D m_positionV2;
var protected int m_scale;
var protectedwrite XGUnit m_kUnit;
var protected XGCharacter m_kCharacter;
var bool m_bIsFriendly;
var private bool m_bIsDead;
var private bool m_bIsSelected;
var private bool m_bLockToReticle;
var private bool m_bShowingBuff;
var private bool m_bShowingDebuff;
var private int m_iScaleOverride;
var private int m_ekgState;
var private EUnitFlagTargetingState m_eState;
var private int m_WatchReticleLocation;
var private int m_WatchReticleVisibility;
var private UITargetingReticle m_kReticle;

defaultproperties
{
    m_bIsFriendly=true
    m_ekgState=-1
    m_WatchReticleLocation=-1
    s_name="<UnitFlag name is Dynamically Set>"
}