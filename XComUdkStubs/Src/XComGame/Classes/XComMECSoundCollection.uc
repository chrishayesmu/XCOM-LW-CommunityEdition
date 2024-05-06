class XComMECSoundCollection extends Object
    dependson(AnimNotify_MEC);

struct MECSoundEvent
{
    var() EMECEvent Event;
    var() SoundCue SoundCue;
};

var() array<MECSoundEvent> Events;