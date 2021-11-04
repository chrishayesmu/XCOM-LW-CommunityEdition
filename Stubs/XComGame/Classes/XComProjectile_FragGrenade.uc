class XComProjectile_FragGrenade extends XComProjectile
    native(Weapon)
    hidecategories(Navigation);
//complete stub

var bool m_bUsePrecomputedTrail;
var bool m_bShouldNotCauseDamageFlinch;
var bool m_bBattleScanner;
var private bool m_bMimicBeacon;
var float m_fPrecomputedPathTime;
var init const localized string m_sMineNowMessage;
var() ParticleSystem CombatDrugsTrailFX;
var protected export editinline ParticleSystemComponent MimicBeaconPersistComponent;
var ParticleSystem MimicBeaconParticleSystemPersist;

simulated event PostBeginPlay(){}
simulated function InitProjectile(Vector Direction, optional bool bPreviewOnly, optional bool bAnimNotify_FireWeaponCustom_DoDamage=true){}
simulated function InitNoAction(int iWeapon){}
simulated function bool HasProjectileExceededOutsideWorldGridTravelDistance(float fDeltaTime){}
simulated function RemoveGrenade(Vector HitLocation, Vector HitNormal, optional bool bHideExplosion=true){}
simulated event Tick(float DeltaTime){}
simulated function GetFloor(out Vector HitLocation, out Vector HitNormal){}
simulated event ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal){}
singular simulated event HitWall(Vector HitNormal, Actor Wall, PrimitiveComponent WallComp);
simulated function SpawnExplosionEffects(Vector HitLocation, Vector HitNormal){}
simulated function DisableEffects(){}
simulated function StartMimicBeacon(){}
simulated function InitPreview(){}
simulated function float GetSplashRadius(){}
