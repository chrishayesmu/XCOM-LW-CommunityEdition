class XComGameReplicationInfo extends GameReplicationInfo
    native(Core)
    config(Game)
    hidecategories(Navigation,Movement,Collision);

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

defaultproperties
{
    m_bOnReceivedGameClassGetNewMPINI=true
    SoundManagerClassToSpawn=class'XComSoundManager'
    AnimMapping(0)=None
    AnimMapping(1)=MV_RunFwd_StopA
    AnimMapping(2)=AC_HL_Run2CoverStartA
    AnimMapping(3)=AC_HR_Run2CoverStartA
    AnimMapping(4)=AC_HR_Run2CoverStopA
    AnimMapping(5)=AC_HL_Run2CoverStopA
    AnimMapping(6)=AC_LL_Run2CoverStopA
    AnimMapping(7)=AC_LR_Run2CoverStopA
    AnimMapping(8)=AC_NO_JetUpAir_StartA
    AnimMapping(9)=AC_NO_JetUpAir_StopA
    AnimMapping(10)=AC_NO_JetDownAir_StartA
    AnimMapping(11)=AC_NO_JetDownAir_StopA
    AnimMapping(12)=AC_NO_JetUpGround_StartA
    AnimMapping(13)=AC_NO_JetDownGround_StopA
    AnimMapping(14)=AC_NO_WindowBreakThroughA
    AnimMapping(15)=AC_NO_BullRushA
    AnimMapping(16)=AC_NO_Door_OpenBreakA
    AnimMapping(17)=AC_NO_CallOthersA
    AnimMapping(18)=AC_NO_CallOthersA
    AnimMapping(19)=AC_NO_ClimbLadderUp_StartA
    AnimMapping(20)=MV_ClimbLadderUp_LoopA
    AnimMapping(21)=MV_ClimbDrainUp_LoopA
    AnimMapping(22)=AC_NO_ClimbLadderUp_StopA
    AnimMapping(23)=AC_NO_ClimbLadderUp_StopB
    AnimMapping(24)=AC_NO_ClimbLadderDwn_StartA
    AnimMapping(25)=AC_NO_ClimbLadderDwn_StartB
    AnimMapping(26)=MV_ClimbLadderDwn_LoopA
    AnimMapping(27)=MV_ClimbDrainDwn_LoopA
    AnimMapping(28)=AC_NO_ClimbLadderDwn_StopA
    AnimMapping(29)=AC_NO_ClimbWallUp_StartA
    AnimMapping(30)=MV_ClimbWallUp_LoopA
    AnimMapping(31)=AC_NO_ClimbWallUp_StopA
    AnimMapping(32)=AC_NO_ClimbWallUp_StopB
    AnimMapping(33)=AC_NO_DeathA
    AnimMapping(34)=FF_FireA_DroneHack
    AnimMapping(35)=FF_FireA_RepairSHIV
    AnimMapping(36)=AC_NO_BullRushStartA
    AnimMapping(37)=AC_NO_HealA
    AnimMapping(38)=AC_NO_OverloadA
    AnimMapping(39)=AC_NO_HotPotatoA
    AnimMapping(40)=FF_FireB
    AnimMapping(41)=AC_NO_ClimbAlienLiftUp_StartA
    AnimMapping(42)=MV_ClimbAlienLiftUp_LoopA
    AnimMapping(43)=AC_NO_ClimbAlienLiftUp_StopA
    AnimMapping(44)=AC_NO_ClimbAlienLiftDown_StartA
    AnimMapping(45)=MV_ClimbAlienLiftDown_LoopA
    AnimMapping(46)=AC_NO_ClimbAlienLiftDown_StopA
    AnimMapping(47)=AC_NO_DeathCollapseA
    AnimMapping(48)=AC_NO_PukeA
    AnimMapping(49)=AC_NO_BloodCallA
    AnimMapping(50)=AC_NO_ElectroPulse
    AnimMapping(51)=AC_NO_RestorativeMist
    AnimMapping(52)=AC_NO_Strangle_StartA
}