class XComAlienPawn extends XComUnitPawn
    config(Game)
    hidecategories(Navigation,Physics,Collision,PrimitiveComponent,Rendering);
//complete stub

var() XComCharacterVoice Voice;
var() bool m_bShouldWeaponExplodeOnDeath;
var protectedwrite bool m_bDeathExploded;
var init const string WeaponFragmentEffectName;

replication
{
    if(bNetDirty && Role == ROLE_Authority)
        m_bDeathExploded;
}

simulated event PostBeginPlay(){}
simulated function int GetDeathExplosionDamage(XGUnit kUnit){}
simulated function float GetDeathExplosionRadius(XGUnit kUnit){}
function Explode(XGUnit kUnit, optional class<DamageType> kDamageType=class'XComDamageType_Explosion'){}
function DeathExplosion(){}
simulated event bool RestoreAnimSetsToDefault(){}
simulated function MeshSwap(){};
reliable client simulated function UnitSpeak(ECharacterSpeech Event){}
function bool ShouldTearOffOnDeath(){}
function SpawnWeaponSelfDestructFX(){}
function ThrowWeaponOnDeath(){}

defaultproperties
{
    m_bShouldWeaponExplodeOnDeath=true
    WeaponFragmentEffectName="FX_WP_PlasmaShared.P_Weapon_Fragmenting"
}