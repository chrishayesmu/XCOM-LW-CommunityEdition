class AnimNotify_MEC extends AnimNotify
    native(Animation)
    editinlinenew
    collapsecategories
    hidecategories(Object);

enum EMECEvent
{
    eMEC_LegMove,
    eMEC_ArmMove,
    eMEC_HandThud,
    eMEC_BodyThud,
    eMEC_TakeDamage,
    eMEC_Footstep,
    eMEC_MAX
};

var() EMECEvent Event;
