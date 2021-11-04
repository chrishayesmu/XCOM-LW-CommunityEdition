class XComSectopod extends XComAlienPawn
    config(Game)
    hidecategories(Navigation,Physics,Collision,PrimitiveComponent,Rendering);
//complete stub

var string m_strDeathMesh;
var string m_strDamageFX;
var string m_strClusterBombTargetingFX;
var() ParticleSystem DamageFX;
var() ParticleSystem ClusterBombTargetingFX;
var() StaticMesh DeathMesh;
var() Vector DeathMeshOffset;
var export editinline ParticleSystemComponent m_kDamageFX;
var export editinline StaticMeshComponent m_kDeathMesh;
var transient XComEmitter m_kTargetEmitter;

simulated function OnDeathDeactivateEffects(){}
simulated event PostBeginPlay(){}
simulated function BeginTargetAnim(){}
simulated function EnableClusterBombTargeting(optional bool bEnable=true){}
simulated function UpdateTargetingLocation(Vector vNewLoc, optional bool bEnableTargeting=true){}
simulated function SetDamageLevel(int iNewHP, int iMaxHP){}
simulated event TakeDirectDamage(const DamageEvent Dmg){}
simulated function MeshSwap(){}
function SetDyingPhysics(){}
