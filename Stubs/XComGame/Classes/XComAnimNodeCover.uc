class XComAnimNodeCover extends AnimNodeBlendList
    native(Animation);
//complete  stub

enum EAnimCover
{
    eAnimCover_None,
    eAnimCover_LowLeft,
    eAnimCover_LowRight,
    eAnimCover_HighLeft,
    eAnimCover_HighRight,
    eAnimCover_SwitchSidesLL2LR,
    eAnimCover_SwitchSidesHL2HR,
    eAnimCover_MAX
};

var bool bCanSwitchSides;
var bool bSwitchSidesBegun;
var bool bSwitchSidesLeftToRight;
var bool bProcessTickAnim;
var bool bCanUseOnlyLowCoverAnims;

