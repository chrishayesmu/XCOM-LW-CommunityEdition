class XComCountdownObjectManager extends Actor;
//complete stub

var Actor m_kTargetObject;
var XGCameraView m_kSavedView;
var XGCameraView m_kGrenadeView;
var float m_fPreExplodeWait;
var float m_fPostExplodeWait;

simulated function Init(){}
simulated function UpdateActiveCountdownObjects();
simulated function bool HasTickingObjects(){}
simulated function Update(){}
simulated function LookAt(){}
simulated function string GetDebugLabel(Actor kObj){}
simulated function bool GetNextActive(out Actor kObj){}
function DrawDebugLabel(Canvas kCanvas){}
simulated function bool IsBusy(){}
simulated function Explode();
simulated function InitCountdownObjectLoop();
simulated function bool HasCountdownObjects(){}
simulated function bool IsCountdownObjectVisible(){}
simulated function CountdownObjectLoop_Iterate();

auto state Inactive{}

state Active{
	simulated function Update();
	simulated function UpdateActiveCountdownObjects();    simulated function bool IsBusy(){}
	simulated event EndState(name NextStateName);	
	simulated event BeginState(name PreviousStateName){}
    simulated function bool IsWaitingForOthers(){}
    simulated function bool IsAutoZoomProcessing(){}
}

