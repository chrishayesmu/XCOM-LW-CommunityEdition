class XComFloorComponent extends ActorComponent
    hidecategories(Object);

var transient bool bCutdown;
var transient bool bCutout;
var transient bool bHidden;
var transient bool bToggleHidden;
var transient bool bCutoutStateChanged;
var transient bool bCutdownStateChanged;
var transient bool bHeightStateChanged;
var transient bool bHiddenStateChanged;
var transient bool bToggleHiddenStateChanged;
var transient bool bVisStateChanged;
var transient bool bFadeTransition;
var transient bool bCurrentFadeOut;
var transient bool bComponentNeedsTick;
var transient float fTargetFade;
var transient float fTargetOpacityMaskHeight;
var transient float fTargetCutoutMaskHeight;
var transient float fTargetCutdownMaskHeight;

defaultproperties
{
    bCurrentFadeOut=true
    TickGroup=TG_PostAsyncWork
}