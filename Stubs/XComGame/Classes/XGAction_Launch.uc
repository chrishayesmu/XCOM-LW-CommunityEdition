class XGAction_Launch extends XGAction_Move_Direct
    notplaceable
    hidecategories(Navigation);
//complete stub

struct InitialReplicationData_XGAction_Launch
{
    var XGAbility_Launch m_kLaunchAbility;

    structdefaultproperties
    {
        m_kLaunchAbility=none
    }
};

var private XComAnimNodeBlendByAction.EAnimAction m_eAnimation[3];
var private int m_iAnimsLooped;
var private int m_iWholeLoops;
var private int m_iCount;
var private int m_iAnim;
var private bool m_bLaunchComplete;
var private bool m_bInitialReplicationDataReceived_XGAction_Launch;
var bool m_bAddedLookat;
var bool m_bLaunchInitialized;
var Vector m_vTeleportHeight;
var float m_fDistToGround;
var private repnotify InitialReplicationData_XGAction_Launch m_kInitialReplicationData_XGAction_Launch;
var XGAbility_Launch m_kLaunchAbility;
var Vector m_vCurrLookat;

replication
{
    if(bNetInitial && Role == ROLE_Authority)
        m_kInitialReplicationData_XGAction_Launch;
}

simulated event ReplicatedEvent(name VarName){super.ReplicatedEvent(VarName);}
function bool InitLaunch(XGAbility_Launch kLaunchAbility){}
simulated event SimulatedInit(){}
simulated function bool InternalIsInitialReplicationComplete(){}
simulated function TeleportUnit(Vector vDestination, optional float fHeight=670.0){}
function bool CanBePerformed(){}
simulated function bool GetPathingDestination(out Vector OutDestination){}
function bool IsLaunchComplete(){}
simulated function bool IsUnitVisibleAtPosition(Vector vPos){}
simulated function EnforceValidZHeight(){}
simulated function InternalCompleteAction(){}

simulated state Executing
{
	simulated function SetDefaultView();
	simulated function SetInvisibleView();
    simulated function BeginState(name nmPrev){}
    simulated function LaunchLoopBegin(){}
    simulated function BeginAnimation(){}
    simulated function InitLaunchDescent(){}
    simulated function UpdateAnimation(){}
}