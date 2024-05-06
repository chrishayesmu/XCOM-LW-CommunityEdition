class XGAIChryssalidEgg extends Actor
    notplaceable
    hidecategories(Navigation);

enum EEggDevStage
{
    eZombieSpawn,
    eZombieDeath,
    eChryssalidSpawn,
    EEggDevStage_MAX
};

struct CheckpointRecord
{
    var XGUnit m_kHost;
    var int m_iTurnToHatch;
    var EEggDevStage m_eStage;
    var XGPlayer m_kPlayer;
    var bool m_bZombieKilled;
    var XGPod m_kPod;
};

var XGUnit m_kHost;
var int m_iTurnToHatch;
var EEggDevStage m_eStage;
var XGPlayer m_kPlayer;
var bool m_bZombieKilled;
var XGPod m_kPod;

defaultproperties
{
    RemoteRole=ROLE_SimulatedProxy
    bAlwaysRelevant=true
}