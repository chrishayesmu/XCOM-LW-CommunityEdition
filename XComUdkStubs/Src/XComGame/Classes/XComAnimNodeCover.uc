class XComAnimNodeCover extends AnimNodeBlendList
    native(Animation)
    hidecategories(Object,Object,Object,Object);

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
var() bool bCanUseOnlyLowCoverAnims;

defaultproperties
{
    bProcessTickAnim=true
    bCanUseOnlyLowCoverAnims=true
    bPlayActiveChild=true
    Children(0)=(Name="No Cover")
    Children(1)=(Name="Low Left")
    Children(2)=(Name="Low Right")
    Children(3)=(Name="High Left")
    Children(4)=(Name="High Right")
    Children(5)=(Name="SwitchSides LL to LR (Optional)")
    Children(6)=(Name="SwitchSides HL to HR (Optional)")
    bFixNumChildren=true
}