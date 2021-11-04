class XGAISpawnMethod_DropIn extends XGAISpawnMethod;
//complete stub

var() int m_iDropHeight;

function InitDropIn(int iDropHeight, bool bUseOverwatch, bool bTriggerOverwatch, bool bPlaySound, bool bRevealSpawn, bool bSpawnImmediately, XGGameData.EPawnType ForceAlienType, optional SoundCue AdditionalSoundCue, optional SeqAct_SpawnAlien kSeqAct, optional int iAttackChance)
{
}

function bool OnActivate_UpdateSpawnPoint(out XComSpawnPoint_Alien kSpawnPt, out Vector vSpawnLoc)
{
}
function bool OnSpawnAlien_AddTraversal(XComSpawnPoint_Alien kSpawnPt, Vector vSpawnLoc){}
