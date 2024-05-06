class XComSectopod extends XComAlienPawn
    config(Game)
    hidecategories(Navigation,Physics,Collision,PrimitiveComponent,Rendering);

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

defaultproperties
{
    m_strDeathMesh="CHA_Sectopod_MOD.Meshes.SectoDeathMesh"
    m_strDamageFX="FX_CHA_Sectopod_B.P_Damaged"
    m_strClusterBombTargetingFX="FX_CHA_Sectopod_B.P_Mortar_Target_Marker"
    DeathMeshOffset=(X=-256.0,Y=0.0,Z=0.0)
    RagdollFlag=ERagdoll_Never
    fPhysicsMotorForce=100000.0
    bUseObstructionShader=false
    m_bShouldTurnBeforeMoving=true
}