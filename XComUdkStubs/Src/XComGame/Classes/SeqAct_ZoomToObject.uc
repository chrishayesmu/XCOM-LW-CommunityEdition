class SeqAct_ZoomToObject extends SeqAct_XComWaitCondition
    native(Level)
    editinlinenew
    hidecategories(Object);

var Actor TargetActor;
var() float ZoomLevel;
var() float WaitTime;
var() float CameraYaw;
var() bool bSetToThisRotation;
var() bool bOnlyIfOffscreen;
var() bool bHighPriority;
var() bool bSkipReturnYaw;
var transient bool bTimerActive;
var transient bool bSkipUpdate;
var transient float TimeActive;
var transient float StartTime;
var transient float fStartYaw;
var transient int iState;

defaultproperties
{
    ZoomLevel=1.0
    WaitTime=1.0
    CameraYaw=-1.0
    OutputLinks(0)=(LinkDesc="Out")
    OutputLinks(1)=(LinkDesc="Aborted")
    VariableLinks(0)=(ExpectedType=Class'Engine.SeqVar_Object',LinkDesc="Target Actor",PropertyName=TargetActor)
    ObjName="Camera Zoom and Wait"
}