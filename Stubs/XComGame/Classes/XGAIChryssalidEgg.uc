class XGAIChryssalidEgg extends Actor;
//complete stub

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
var XGAIChryssalidEgg.EEggDevStage m_eStage;
var XGPlayer m_kPlayer;
var bool m_bZombieKilled;
var XGPod m_kPod;

function int GetStageLength(EEggDevStage eStage){}
function Init(XGUnit kHost, XGPlayer kPlayer, XGAIChryssalidEgg.EEggDevStage eStage, optional bool bKilled=true, optional XGPod kPod){}
static function bool CanSurviveDamage(class<DamageType> kDamageType){}
simulated function int GetTurnsToHatch(){}
function Vector GetLocation(){}
function XGUnit OnStageComplete(optional bool bKilled=true){}

