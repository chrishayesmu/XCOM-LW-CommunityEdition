class XComCharacterVoiceBank extends Object
    hidecategories(Object)
    native(Unit)
	dependson(XGGameData);
//complete stub

var() SoundCue HunkerDown;
var() SoundCue Reload;
var() SoundCue Overwatching;
var() SoundCue Moving;
var() SoundCue Dashing;
var() SoundCue JetPackMove;
var() SoundCue LowAmmo;
var() SoundCue OutOfAmmo;
var() SoundCue Suppressing;
var() SoundCue AreaSuppressing;
var() SoundCue FlushingTarget;
var() SoundCue HealingAlly;
var() SoundCue StabilizingAlly;
var() SoundCue RevivingAlly;
var() SoundCue CombatStim;
var() SoundCue FragOut;
var() SoundCue SmokeGrenadeThrown;
var() SoundCue SpyGrenadeThrown;
var() SoundCue FiringRocket;
var() SoundCue GhostModeActivated;
var() SoundCue JetPackDeactivated;
var() SoundCue ArcThrower;
var() SoundCue RepairSHIV;
var() SoundCue Kill;
var() SoundCue MultiKill;
var() SoundCue Missed;
var() SoundCue TargetSpotted;
var() SoundCue TargetSpottedHidden;
var() SoundCue HeardSomething;
var() SoundCue TakingFire;
var() SoundCue FriendlyKilled;
var() SoundCue Panic;
var() SoundCue PanickedBreathing;
var() SoundCue Wounded;
var() SoundCue Died;
var() SoundCue Flanked;
var() SoundCue Suppressed;
var() SoundCue PsiControlled;
var() SoundCue CivilianRescued;
var() SoundCue MeldSpotted;
var() SoundCue MeldCollected;
var() SoundCue RunAndGun;
var() SoundCue GrapplingHook;
var() SoundCue AlienRetreat;
var() SoundCue AlienMoving;
var() SoundCue AlienNotStunned;
var() SoundCue AlienReinforcements;
var() SoundCue AlienSighting;
var() SoundCue DisablingShot;
var() SoundCue ShredderRocket;
var() SoundCue PsionicsMindfray;
var() SoundCue PsionicsPanic;
var() SoundCue PsionicsInspiration;
var() SoundCue PsionicsTelekineticField;
var() SoundCue SoldierControlled;
var() SoundCue StunnedAlien;
var() SoundCue Explosion;
var() SoundCue RocketScatter;
var() SoundCue PsiRift;
var() SoundCue Poisoned;
var() SoundCue HiddenMovement;
var() SoundCue HiddenMovementVox;
var() SoundCue ExaltChatter;
var() SoundCue Strangled;
var() SoundCue CollateralDamage;
var() SoundCue ElectroPulse;
var() SoundCue Flamethrower;
var() SoundCue JetBoots;
var() SoundCue KineticStrike;
var() SoundCue OneForAll;
var() SoundCue ProximityMine;
var private native Map_Mirror EventToPropertyMap;

// Export UXComCharacterVoiceBank::execGetSoundCue(FFrame&, void* const)
native final function SoundCue GetSoundCue(ECharacterSpeech Event);

// Export UXComCharacterVoiceBank::execSetSoundCue(FFrame&, void* const)
native final function SetSoundCue(ECharacterSpeech Event, SoundCue CueIn);