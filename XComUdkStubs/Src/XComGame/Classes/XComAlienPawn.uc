class XComAlienPawn extends XComUnitPawn
    config(Game)
    hidecategories(Navigation,Physics,Collision,PrimitiveComponent,Rendering);

var() privatewrite XComCharacterVoice Voice;
var() bool m_bShouldWeaponExplodeOnDeath;
var protectedwrite bool m_bDeathExploded;
var init const string WeaponFragmentEffectName;

defaultproperties
{
    m_bShouldWeaponExplodeOnDeath=true
    WeaponFragmentEffectName="FX_WP_PlasmaShared.P_Weapon_Fragmenting"
}