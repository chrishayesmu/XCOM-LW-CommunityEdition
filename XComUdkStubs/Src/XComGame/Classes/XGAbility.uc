class XGAbility extends Actor
    native(Core)
    notplaceable
    hidecategories(Navigation);

const XGABILITY_INVALID_ID = -1;
const UNDERHAND_DISTANCE = 450;

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

    structdefaultproperties
    {
        m_iMaxExecutions=1
        m_iActionIDToComplete=-1
    }
};

var XGUnit m_kUnit;
var XGTacticalGameCoreNativeBase m_kGameCore;
var XComPerkManager m_kPerkManager;
var string strName;
var int iType;
var int iCategory; // EAbilityType
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
var privatewrite bool m_bCompleteActionAfterExecution;
var privatewrite bool m_bExecutionReplicationInfoReceived_XGAbility;
var protectedwrite bool m_bExecutionComplete;
var repnotify bool m_bCachedAvailable;
var repnotify repretry InitialReplicationData_XGAbility m_kInitialReplicationData_XGAbility;
var privatewrite int m_iExecutionCount;
var privatewrite int m_iMaxExecutions;
var privatewrite repnotify repretry ExecutionReplicationInfo_XGAbility m_kExecutionReplicationInfo_XGAbility;
var array<XComTacticalController> m_aNetClientsDecRefExecutedBeforeServer;
var array<XComTacticalController> m_aNetExecutingClients;
var array<XComTacticalController> m_aNetRemovingClients;
var int m_iAbilityID;
var repnotify EAbilityAvailableCode m_eAvailableCode;

defaultproperties
{
    m_iMaxExecutions=1
    m_kExecutionReplicationInfo_XGAbility=(m_iReplicatedExecutionCount=0,m_iMaxExecutions=1,m_kRequiredFireAction=none,m_bRequiredFireActionNone=false,m_bCompleteActionAfterExecution=false,m_iActionIDToComplete=-1)
    m_iAbilityID=-1
    RemoteRole=ROLE_SimulatedProxy
    bTickIsDisabled=true
    bAlwaysRelevant=true
}