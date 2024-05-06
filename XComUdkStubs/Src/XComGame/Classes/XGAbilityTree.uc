class XGAbilityTree extends Actor
    native(Core)
    notplaceable
    hidecategories(Navigation);

const SHREDDER_ROCKET_DAMAGE_MULTIPLIER = 0.33f;
const GUNSLINGER_DAMAGE_BONUS = 2;
const BUBONIC_CURE_COUNT = 5;

var int m_iCurrentCategory;
var array<TAbility> m_arrAbilities;
var privatewrite bool m_bInitialized;
var const localized string AbilityNames[EAbility];
var const localized string HelpMessages[EAbility];
var const localized string TargetMessages[EAbility];
var const localized string PerformerMessages[EAbility];
var const localized string AbilityAvailableMessages[EAbilityAvailableCode];
var const localized string AbilityDryReload;
var const localized string ShotDamageCoverTargetAbility;
var const localized string AbilityEffectRevealed;
var const localized string AbilitySentinelFlyover;

defaultproperties
{
    RemoteRole=ROLE_SimulatedProxy
    bAlwaysRelevant=true
}