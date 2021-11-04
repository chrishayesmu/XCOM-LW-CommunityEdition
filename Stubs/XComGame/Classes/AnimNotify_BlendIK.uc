class AnimNotify_BlendIK extends AnimNotify
    native(Animation)
    editinlinenew
    collapsecategories
    hidecategories(Object);
//complete stub

enum BlendIKType
{
    eBlendIKFootUp,
    eBlendIKFootDown,
    eBlendIKLeftHandOverrideOn,
    eBlendIKLeftHandOverrideOff,
    eBlendIKLeftHandOverrideDisable,
    BlendIKType_MAX
};

var() name IKControlName;
var() float fBlendTime;
var() float fBlendTarget;
var() BlendIKType EBlendType;