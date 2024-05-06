class UITacticalHUD_AbilityContainer extends UI_FxsPanel
    notplaceable
    hidecategories(Navigation);

const MAX_NUM_ABILITIES = 15;
const MAX_NUM_ABILITIES_PER_ROW = 7;

var int m_iCurrentIndex;
var private array<XGAbility> m_arrAbilities;
var private int m_iMouseTargetedAbilityIndex;
var XGUnit m_kTargetingRequestUnit;
var int m_kWatchVar_Enemy;
var int m_iUseOnlyAbility;
var int m_iSelectionOnButtonDown;
var private array<UITacticalHUD_AbilityItem> m_arrUIAbilityData;
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

defaultproperties
{
    m_iCurrentIndex=-1
    m_iMouseTargetedAbilityIndex=-1
    m_iUseOnlyAbility=-1
    s_name="<UIActionHUD NAME IS UNSET>"
}