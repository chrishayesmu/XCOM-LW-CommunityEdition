class XGAbility extends Actor
    native(Core)
    notplaceable
    DependsOn(XGTacticalGameCoreNativeBase);
//complete stub

struct CheckpointRecord
{
    var string strName;
    var int iType;
    var XGUnit m_kUnit;
    var int aTargetStats[ECharacterStat];
    var int iDuration;
    var bool m_bReactionFire;
    var int iCategory;
};
struct native InitialReplicationData_XGAbility
{
    var XGUnit m_kUnit;
    var int iType;
    var int iCategory;
    var int iTargetType;
    var int iRange;
    var int iTargetMsgColor;
    var int iPerformerMsgColor;
    var int iPossibleDamage;
    var int iReactionCost;
    var bool m_bAvailable;
    var bool m_bReactionFire;
};
struct native ExecutionReplicationInfo_XGAbility
{
    var int m_iReplicatedExecutionCount;
    var int m_iMaxExecutions;
    var XGAction_Fire m_kRequiredFireAction;
    var bool m_bRequiredFireActionNone;
    var bool m_bCompleteActionAfterExecution;
    var int m_iActionIDToComplete;
};

var XGUnit m_kUnit;
var XGTacticalGameCoreNativeBase m_kGameCore;
var XComPerkManager m_kPerkManager;
var string strName;
var int iType;
var int iCategory;
var int iTargetType;
var int iRange;
var int iDuration;
var int iCooldown;
var repnotify int aDisplayProperties[EAbilityDisplayProperty];
var int aTargetStats[ECharacterStat];
var string strHelp;
var string strTargetMessage;
var int iTargetMsgColor;
var string strPerformerMessage;
var int iPerformerMsgColor;
var int iPossibleDamage;
var int iReactionCost;
var int m_iAIPriority;
var bool m_bReactionFire;
var bool m_bDelayApplyCost;
var private bool m_bInitialReplicationDataReceived_XGAbility;
var private bool m_bInitialReplicationComplete;
var bool m_bCompleteActionAfterExecution;
var bool m_bExecutionReplicationInfoReceived_XGAbility;
var protectedwrite bool m_bExecutionComplete;
var repnotify bool m_bCachedAvailable;
var repnotify InitialReplicationData_XGAbility m_kInitialReplicationData_XGAbility;
var int m_iExecutionCount;
var int m_iMaxExecutions;
var repnotify ExecutionReplicationInfo_XGAbility m_kExecutionReplicationInfo_XGAbility;
var array<XComTacticalController> m_aNetClientsDecRefExecutedBeforeServer;
var array<XComTacticalController> m_aNetExecutingClients;
var array<XComTacticalController> m_aNetRemovingClients;
var int m_iAbilityID;
var repnotify XGTacticalGameCoreData.EAbilityAvailableCode m_eAvailableCode;

replication
{
    if(bNetInitial && Role == ROLE_Authority)
        m_kInitialReplicationData_XGAbility;

    if(bNetDirty && Role == ROLE_Authority)
        aDisplayProperties, aTargetStats, 
        iCooldown, iDuration, 
        m_bCachedAvailable, m_eAvailableCode, 
        m_iAbilityID, m_kExecutionReplicationInfo_XGAbility;
}

simulated event ReplicatedEvent(name VarName){}
simulated function TimerUpdateAbilitiesUIOnReceivedUnit(){}
final simulated function bool IsExecutionReplicationComplete(){}
protected simulated function bool InternalIsExecutionReplicationComplete(){}
simulated function WaitForExecutionReplication(){}
final simulated event bool IsInitialReplicationComplete(){}
simulated function bool InternalIsInitialReplicationComplete(){}
simulated function OnInitialReplicationComplete(){}
simulated function ApplyEffect();
function ApplyCost(){}
simulated function EndTurnCheck(){}
simulated function int GetCharge(){}
simulated event PreBeginPlay(){}
simulated event PostBeginPlay(){}
native function Init(int iAbility);
simulated function bool ShowAbility(){}
simulated function bool DoesDamage(){}
simulated function bool ShouldUnhideUser(){}
simulated function bool ShouldAnimateAWeaponFire(){}
simulated function int CalcSuppression(){}
function Reset();
simulated function int GetType(){}
simulated function string GetTypeString(){}
simulated function string GetName(){}
simulated function string GetHelpText(){}
native simulated function bool CheckAvailable();
native simulated function GetTacticalGameCore();
native simulated function GetPerkTree();
native function bool InternalCheckAvailable();
simulated function bool Execute(optional bool bCompleteActionAfterExecution){}
reliable server function ServerExecute(optional bool bCompleteActionAfterExecution){}
function bool NeedToSendRequiredFireActionToClient(){}
simulated function InternalExecute(){}
simulated function PostExecute();
simulated function DoClientLoopedExecution(){}
function int CalcMaxExecutions(){}

simulated function SetMaxExecutions(int iMaxExecutions){}
simulated event Destroyed(){}
simulated function Deselected(){};
function DecRefExecutingClient(XComTacticalController kTacticalController){}
simulated function bool Projectile_OverrideStartPositionAndDir(out Vector tempTrace, out Vector tempDir){}
simulated function bool IsOverheadCamera(){}
simulated function bool UtilizeCursorMoving(){}
// Export UXGAbility::execHasEffect(FFrame&, void* const)
native simulated function bool HasEffect(XGTacticalGameCoreData.EAbilityEffect iAbilityEffect);

// Export UXGAbility::execHasProperty(FFrame&, void* const)
native simulated function bool HasProperty(XGTacticalGameCoreData.EAbilityProperty eProp);

// Export UXGAbility::execHasDisplayProperty(FFrame&, void* const)
native simulated function bool HasDisplayProperty(XGTacticalGameCoreData.EAbilityDisplayProperty eDisplayProp);

// Export UXGAbility::execIsGrenadeAbility(FFrame&, void* const)
native simulated function bool IsGrenadeAbility();

simulated function bool IsPermanent(){}
simulated function int GetCategory(){}
simulated function XComPresentationLayer PRES(){}
simulated function int GetReactionCost(){}
simulated function bool IsReactionShot(){}
simulated function bool IsReadyForDestruction(){}
final simulated function TimeForDestroy(){}
simulated function SetupDestroyTimer(){}
simulated function DestroyTimer(){}

simulated state WaitingForExecutionReplication
{
    simulated event PushedState()
    {
        SetTickIsDisabled(false);
    }

    simulated event PoppedState()
    {
        DoClientLoopedExecution();
        SetTickIsDisabled(true);
    }
}