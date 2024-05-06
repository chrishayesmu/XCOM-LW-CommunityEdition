class UITacticalHUD extends UI_FxsScreen
    notplaceable
    hidecategories(Navigation);

enum eUI_ReticleMode
{
    eUIReticle_NONE,
    eUIReticle_Offensive,
    eUIReticle_Overshoulder,
    eUIReticle_Defensive,
    eUIReticle_MAX
};

var private array<UITargetingReticle> m_arrReticles;
var private eUI_ReticleMode m_eReticleMode;
var UITacticalHUD_WeaponContainer m_kWeaponContainer;
var UITacticalHUD_InfoPanel m_kInfoBox;
var UITacticalHUD_AbilityContainer m_kAbilityHUD;
var UITacticalHUD_SoldierStatsContainer m_kStatsContainer;
var UITacticalHUD_Radar m_kRadar;
var UITacticalHUD_PerkContainer m_kPerks;
var UITacticalHUD_ObjectivesList m_kObjectives;
var UITacticalHUD_MouseControls m_kMouseControls;
var UIStrategyTutorialBox m_kTutorialHelpBox;
var privatewrite bool m_isMenuRaised;
var private bool m_bForceOverheadView;
var bool m_bHelpTipsDisabled;
var string m_strReticleMsg;
var float m_fReticleAimPercentage;
var float m_fReticleAimCritical;

defaultproperties
{
    s_package="/ package/gfxTacticalHUD/TacticalHUD"
    s_screenId="gfxTacticalHUD"
    e_InputState=eInputState_Evaluate
    s_name="theTacticalHUD"
}