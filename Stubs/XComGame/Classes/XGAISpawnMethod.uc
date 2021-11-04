class XGAISpawnMethod extends Object
	   dependsOn(XGGameData);
//complete stub

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

function InitParams(bool UseOverwatch, bool TriggerOverwatch, bool PlaySound, bool RevealSpawn, bool SpawnImmediately, XGGameData.EPawnType ForceAlienType, XComWaveSystem.ESpawnMethod eSpawnType, optional SoundCue AdditionalSoundCue, optional SeqAct_SpawnAlien kSeqAct, optional int iAttackChance){}
function Init(){}
function SetGroupSpawnedEvent(name strName){}
function AddSpawnPoint(XComSpawnPoint_Alien kSpawnPoint, optional XComSpawnPoint_Alien kOriginPoint){}
function bool OnActivate_UpdateSpawnPoint(out XComSpawnPoint_Alien kSpawnPt, out Vector vSpawnLoc){}
function bool OnSpawnAlien_AddTraversal(XComSpawnPoint_Alien kSpawnPt, Vector vSpawnLoc){}
function bool ActivateSpawnPoint(int iSpawnPt, optional bool bSpawnImmediate){}
function TriggerGroupSpawnedEvent(){}
function CheckContentLoaded(){}
