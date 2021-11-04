class XComFloorComponent extends ActorComponent
    hidecategories(Object)
    native(Level);
//complete  stub

var native transient bool bCutdown;
var native transient bool bCutout;
var native transient bool bHidden;
var native transient bool bToggleHidden;
var native transient bool bCutoutStateChanged;
var native transient bool bCutdownStateChanged;
var native transient bool bHeightStateChanged;
var native transient bool bHiddenStateChanged;
var native transient bool bToggleHiddenStateChanged;
var native transient bool bVisStateChanged;
var transient bool bFadeTransition;
var transient bool bCurrentFadeOut;
var native transient bool bComponentNeedsTick;
var native transient float fTargetFade;
var native transient float fTargetOpacityMaskHeight;
var native transient float fTargetCutoutMaskHeight;
var native transient float fTargetCutdownMaskHeight;

// Export UXComFloorComponent::execSetTargetCutdown(FFrame&, void* const)
native simulated function SetTargetCutdown(bool bInCutdown);

// Export UXComFloorComponent::execSetTargetCutout(FFrame&, void* const)
native simulated function SetTargetCutout(bool bInCutout);

// Export UXComFloorComponent::execSetTargetHidden(FFrame&, void* const)
native simulated function SetTargetHidden(bool bInHidden);

// Export UXComFloorComponent::execSetTargetToggleHidden(FFrame&, void* const)
native simulated function SetTargetToggleHidden(bool bInToggleHidden);

// Export UXComFloorComponent::execSetTargetVisHeights(FFrame&, void* const)
native simulated function SetTargetVisHeights(float fInTargetCutdownHeight, float fInTargetCutoutHeight);

// Export UXComFloorComponent::execPreTransition(FFrame&, void* const)
private native final simulated function PreTransition();

// Export UXComFloorComponent::execOnBeginFadeTransition(FFrame&, void* const)
private native final simulated function OnBeginFadeTransition(bool bFadeOut, bool bResetFade, out float fCutoutFade, out float fTargetCutoutFade);

// Export UXComFloorComponent::execOnFinishedFadeTransition(FFrame&, void* const)
private native final simulated function OnFinishedFadeTransition(float fCutdownHeight, float fCutoutHeight);

// Export UXComFloorComponent::execStopTransition(FFrame&, void* const)
private native final simulated function StopTransition();
