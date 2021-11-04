class XComMECSoundCollection extends Object;

//complete stub

struct MECSoundEvent
{
    var() AnimNotify_MEC.EMECEvent Event;
    var() SoundCue SoundCue;
};

var() array<MECSoundEvent> Events;

simulated function PlaySoundForEvent(Pawn P, EMECEvent Event){}
