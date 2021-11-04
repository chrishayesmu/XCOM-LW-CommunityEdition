class XComGrenadeManager extends XComCountdownObjectManager;
//complete stub

var array<XComDestructibleActor> m_arrDestructibleActors;
var Vector vLookAt;

simulated function AddDestructingActor(XComDestructibleActor kDestruct){}
simulated function LookAt(){}
simulated function Explode(){}
simulated function InitCountdownObjectLoop(){}
simulated function bool HasCountdownObjects(){}
simulated function bool IsCountdownObjectVisible(){}
simulated function CountdownObjectLoop_Iterate(){}
simulated function bool HasTickingObjects(){}

state Active
{
    simulated event BeginState(name PreviousStateName)
    {    }

    simulated event EndState(name NextStateName)
    {    }

    simulated function bool IsWaitingForOthers()
    {    }
   
}
