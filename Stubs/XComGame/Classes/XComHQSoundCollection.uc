class XComHQSoundCollection extends Object
    hidecategories(Object);
//complete stub

enum EMusicCue
{
    eMusic_None,
    eMusic_MC,
    eMusic_HQ,
    eMusic_HQ_ActI,
    eMusic_HQ_ActII,
    eMusic_HQ_ActIII,
    eMusic_Memorial,
    eMusic_Interception,
    eMusic_ChooseSquad,
    eMusic_YouWin,
    eMusic_YouLose,
    eMusic_MAX
};

enum EAmbienceCue
{
    eAmbience_None,
    eAmbience_MC,
    eAmbience_HQ,
    eAmbience_Labs,
    eAmbience_Barracks,
    eAmbience_Hangar,
    eAmbience_Engineering,
    eAmbience_SitRoom,
    eAmbience_Foundry,
    eAmbience_Gollop,
    eAmbience_GeneLabs,
    eAmbience_MAX
};


var(Music) array<string> MusicCueNames;
var(Ambient) array<string> AmbientCueNames;
var(UI) SoundCue SFX_UI_Yes;
var(UI) SoundCue SFX_UI_No;
var(UI) SoundCue SFX_UI_AbductionSwitch;
var(UI) SoundCue SFX_UI_BigOpen;
var(UI) SoundCue SFX_UI_BigClose;
var(UI) SoundCue SFX_UI_SmallOpen;
var(UI) SoundCue SFX_UI_SmallClose;
var(UI) SoundCue SFX_UI_IntOpen;
var(UI) SoundCue SFX_UI_IntClose;
var(UI) SoundCue SFX_UI_EquipWeapon;
var(UI) SoundCue SFX_UI_EquipArmor;
var(UI) SoundCue SFX_UI_CommLink;
var(UI) SoundCue SFX_UI_TechStarted;
var(UI) SoundCue SFX_UI_ItemStarted;
var(UI) SoundCue SFX_UI_ItemDeleted;
var(UI) SoundCue SFX_UI_FacilityStarted;
var(UI) SoundCue SFX_UI_ExcavationStarted;
var(UI) SoundCue SFX_UI_FacilityRemoved;
var(UI) SoundCue SFX_UI_CashReceived;
var(UI) SoundCue SFX_UI_ChoosePromotion;
var(UI) SoundCue SFX_UI_OTSUpgrade;
var(UI) SoundCue SFX_UI_ToggleSelectContinent;
var(UI) SoundCue SFX_UI_ActivateSoldierPromotion;
var(UI) SoundCue SFX_UI_ScienceLabScreenOpen;
var(UI) SoundCue SFX_UI_HologlobeActivation;
var(UI) SoundCue SFX_UI_HologlobeDeactivation;
var(UI) SoundCue SFX_UI_SatelliteLaunch;
var(Unlock) SoundCue SFX_Unlock_Item;
var(Unlock) SoundCue SFX_Unlock_Facility;
var(Unlock) SoundCue SFX_Unlock_Foundry;
var(Unlock) SoundCue SFX_Unlock_Objective;
var(MissionControl) SoundCue SFX_MC_UFOScan;
var(MissionControl) SoundCue SFX_MC_SmallUFOEngine;
var(MissionControl) SoundCue SFX_MC_BigUFOEngine;
var(MissionControl) SoundCue SFX_MC_OverseerUFOEngine;
var(MissionControl) SoundCue SFX_MC_InterceptorEngine;
var(MissionControl) SoundCue SFX_MC_FirestormEngine;
var(MissionControl) SoundCue SFX_MC_SkyrangerEngine;
var(Alert) SoundCue SFX_Alert_PanicRising;
var(Alert) SoundCue SFX_Alert_Abduction;
var(Alert) SoundCue SFX_Alert_Terror;
var(Alert) SoundCue SFX_Alert_UFOContact;
var(Alert) SoundCue SFX_Alert_UFOLanded;
var(Alert) SoundCue SFX_Alert_UFOLost;
var(Alert) SoundCue SFX_Alert_ResearchComplete;
var(Alert) SoundCue SFX_Alert_ItemProjectComplete;
var(Alert) SoundCue SFX_Alert_FoundryProjectComplete;
var(Alert) SoundCue SFX_Alert_FacilityComplete;
var(Alert) SoundCue SFX_Alert_PsiTrainingComplete;
var(Alert) SoundCue SFX_Alert_UrgentMessage;
var(Alert) SoundCue SFX_Alert_FundingCouncil;
var(Alert) SoundCue SFX_Alert_SatelliteLost;
var(Alert) SoundCue SFX_Alert_DropArrive;
var(Notify) SoundCue SFX_Notify_JetRepaired;
var(Notify) SoundCue SFX_Notify_JetTransferred;
var(Notify) SoundCue SFX_Notify_JetArrived;
var(Notify) SoundCue SFX_Notify_JetArmed;
var(Notify) SoundCue SFX_Notify_SatelliteOperational;
var(Notify) SoundCue SFX_Notify_SoldiersArrived;
var(Notify) SoundCue SFX_Notify_SoldierHealed;
var(Notify) SoundCue SFX_Notify_ItemBuilt;
var(Notify) SoundCue SFX_Notify_ExcavationComplete;
var(Interception) SoundCue SFX_Int_Timer;
var(Interception) SoundCue SFX_Int_PilotEngage;
var(Interception) SoundCue SFX_Int_PilotAbort;
var(Interception) SoundCue SFX_Int_PilotUFOLost;
var(Interception) SoundCue SFX_Int_PilotUFOShotDown;
var(Interception) SoundCue SFX_Int_FirePhoenix;
var(Interception) SoundCue SFX_Int_FireAvalanche;
var(Interception) SoundCue SFX_Int_FireLaser;
var(Interception) SoundCue SFX_Int_FirePlasma;
var(Interception) SoundCue SFX_Int_FirePlasmaII;
var(Interception) SoundCue SFX_Int_FireFusion;
var(Interception) SoundCue SFX_Int_FireEmp;
var(Interception) SoundCue SFX_Int_JetExplode;
var(Interception) SoundCue SFX_Int_JetWarning;
var(Interception) SoundCue SFX_Int_JetIsHit;
var(Interception) SoundCue SFX_Int_UFOIsHit;
var(Interception) SoundCue SFX_Int_SmallUFOGoingDown;
var(Interception) SoundCue SFX_Int_BigUFOGoingDown;
var(Interception) SoundCue SFX_Int_SmallUFOEscape;
var(Interception) SoundCue SFX_Int_BigUFOEscape;
var(Interception) SoundCue SFX_Int_ConsumeAim;
var(Interception) SoundCue SFX_Int_ConsumeDodge;
var(Interception) SoundCue SFX_Int_ConsumeTrack;
var(Facility) SoundCue SFX_Facility_ConstructItem;
var(Facility) SoundCue SFX_Facility_DisassembleItem;

function string GetMusicCueName(XComHQSoundCollection.EMusicCue eCue){}
function string GetAmbienceCueName(XComHQSoundCollection.EAmbienceCue eCue){}
