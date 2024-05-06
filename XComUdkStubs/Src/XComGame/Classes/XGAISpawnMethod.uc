class XGAISpawnMethod extends Object;

var() bool m_bEnabled;
var() bool m_bUseOverwatch;
var() bool m_bTriggerOverwatch;
var() bool m_bPlaySound;
var() bool m_bRevealSpawn;
var() bool m_bSpawnImmediately;
var bool bOverrideSpawnPointRestrictions;
var() int m_iChanceToAttackOnSpawn;
var XGUnit m_kSpawnedUnit;
var EPawnType m_kForceAlienType;
var XComWaveSystem.ESpawnMethod m_eSpawnType;
var array<XComSpawnPoint_Alien> m_arrSpawnPoint;
var array<XComSpawnPoint_Alien> m_arrOriginPoint;
var name m_strGroupSpawnedEvent;
var SoundCue m_kAdditionalSoundCue;
var SeqAct_SpawnAlien m_kSeqAct;

defaultproperties
{
    m_bEnabled=true
}