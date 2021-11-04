class XComGameReplicationInfo extends GameReplicationInfo
    native(Core)
    config(Game)
    hidecategories(Navigation,Movement,Collision);
//complete stub

enum ESingleAnim
{
    eAnim_None,
    eAnim_Running2NoCoverStart,
    eAnim_Running2CoverLeftStart,
    eAnim_Running2CoverRightStart,
    eAnim_Running2CoverRightHighStop,
    eAnim_Running2CoverLeftHighStop,
    eAnim_Running2CoverLeftLowStop,
    eAnim_Running2CoverRightLowStop,
    eAnim_FlightUp_Start,
    eAnim_FlightUp_Stop,
    eAnim_FlightDown_Start,
    eAnim_FlightDown_Stop,
    eAnim_FlightToggledOn,
    eAnim_FlightToggledOff,
    eAnim_ClimbThruWindow,
    eAnim_BreakWall,
    eAnim_KickDoor,
    eAnim_CallOthers,
    eAnim_SignalEnemyTarget,
    eAnim_ClimbUpGetOnLadder,
    eAnim_ClimbUpLadder,
    eAnim_ClimbUpDrain,
    eAnim_ClimbUpGetOffLadder,
    eAnim_ClimbUpGetOffLadderDropDown,
    eAnim_ClimbDownGetOnLadder,
    eAnim_ClimbDownGetOnLadderClimbOver,
    eAnim_ClimbDownLadder,
    eAnim_ClimbDownDrain,
    eAnim_ClimbDownGetOffLadder,
    eAnim_ClimbUpStart,
    eAnim_ClimbUpLoop,
    eAnim_ClimbUpStop,
    eAnim_ClimbUpStopDropDown,
    eAnim_ChryssalidBirthVomit,
    eAnim_ShotDroneHack,
    eAnim_ShotRepairSHIV,
    eAnim_BullRushStart,
    eAnim_DroneRepair,
    eAnim_ShotOverload,
    eAnim_HotPotatoPickup,
    eAnim_UnderhandGrenade,
    eAnim_UpAlienLiftStart,
    eAnim_UpAlienLiftLoop,
    eAnim_UpAlienLiftStop,
    eAnim_DownAlienLiftStart,
    eAnim_DownAlienLiftLoop,
    eAnim_DownAlienLiftStop,
    eAnim_ArcThrowerStunned,
    eAnim_ZombiePuke,
    eAnim_MutonBloodCall,
    eAnim_MEC_ElectroPulse,
    eAnim_MEC_RestorativeMist,
    eAnim_Strangle,
    eAnim_MAX
};

var repnotify XGTacticalGameCore m_kGameCore;
var repnotify XComPerkManager m_kPerkTree;
var XComMPData m_kMPData;
var bool m_bOnReceivedGameClassGetNewMPINI;
var XComCameraManager m_kCameraManager;
var class<XComSoundManager> SoundManagerClassToSpawn;
var XComSoundManager SoundManager;
var XComAutosaveMgr m_kAutosaveMgr;
var array<name> AnimMapping;

replication
{
    if(bNetDirty && Role == ROLE_Authority)
        m_kGameCore, m_kPerkTree;
}

simulated event PostBeginPlay(){}
simulated event ReplicatedEvent(name VarName){}
simulated function DoRemoteEvent(name Evt, optional bool bRunOnClient){}
simulated function XComSoundManager GetSoundManager(){}
simulated function ReceivedGameClass(){}
simulated function XComAutosaveMgr GetAutosaveMgr(){}
