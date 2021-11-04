class XComAlienPodManager extends Actor
    native(AI)
DependsOn(XGOvermindActor);
//complete stub

struct CheckpointRecord
{
    var array<XComAlienPod> m_arrPod;
    var bool m_bHasTerrorPods;
};

struct podscore
{
    var float fScore;
    var XComAlienPod kPod;
};

var array<XComAlienPod> m_arrPod;
var bool m_bHasTerrorPods;
var bool m_bIsBusy;
var bool m_bFirstResponse;
var bool m_bSpoken;
var bool m_bPodRevealAttack;
var bool m_bWaitForSaveLoad;
var array<XComAlienPod> m_arrRevealed;
var array<XComAlienPod> m_arrRevealPostponed;
var array<XComAlienPod> m_arrActivation;
var array<XComAlienPod> m_arrTriggered;
var array<XComAlienPod> m_arrDynamic;
var array<XComAlienPod> m_arrTripped;
var int m_iActivePodIdx;
var XGAIPlayer m_kPlayer;
var XGUnit m_kUnit;
var XGCameraView m_kSavedView;
var array<int> m_kLootList;
var XComAlienPod m_kLastPodCleared;
var Volume m_kExitVolume;
var int m_nActivatedAliens;
var array<XComAlienPod> m_arrContingent;
var int m_iRevealedCount;
var XComAlienPod m_kCommanderPod;
var array<XComAlienPod> m_arrSecondaryPod;
var array<TAlienSpawn> m_arrSpawnList;
var int m_iAttackChance;
var int m_nPods;
var int m_nReplacedPods;
var Vector m_vLastEnemyLoc;
var array<XComAlienPod> m_arrLastScored;

simulated function ActivateRevealPodEvent(XComAlienPod kPod){}
simulated function ActivateTriggeredPods(XComAlienPod kInitialPod){}
function AddSpecialtyPods(out array<XComAlienPod> kPodList){}
function ApplyCheckpointRecord(){}
simulated function bool AreAlienUnitsIdle(){}
simulated function BeginDynamicAIMovement(){}
static function int CalculateNumSecondaryPods(int nTotal2ndAliens, int nTotal2ndPods, int nTotalAliens, optional float fDesiredRatioToRegular){}
function bool CheckAlienCounts(out array<XComAlienPod> kPodList){}
simulated function bool CheckForVisiblePods(XGUnit kUnit){}
simulated function CleanUpRespawns(){}
function ClearPodQueues(){}
simulated function bool ConvertPodType(int iSpawnIdx){}
function DebugLogAllPods(){}
function DebugLogHang(){}
simulated function DrawDebugLabel(Canvas kCanvas){}
simulated function EnemyPreMoveInit(XGUnit kUnit, Vector vDestination);
simulated function GenerateSpawnList(out array<XComAlienPod> kPodList, out array<XComAlienPod> kDynamic, int iPodGroup){}
simulated function XComAlienPod GetActivePod(){}
function EPawnType GetAlienPawnType(XComAlienPod kPod, int iNum){}
function bool GetIntersectingPods(const out XComAlienPod kSourcePod, out array<XComAlienPod> arrIntersecting){}
simulated function XComAlienPod GetNearestPod(Vector vLoc, optional bool bDormantOnly){}
simulated function XComAlienPod GetPod(int iPod){}
simulated function XComAlienPod GetPodByName(string szName){}
simulated function array<XGGameData.ECharacter> GetPodCharArray(out TAlienPod kPod, out array<EItemType> arrAltWeapon){}
event GetPodSplashDamageActors(Vector vLocation, float fRadius, out array<XComUnitPawnNativeBase> arrPawns_Out, optional out array<XComAlienPod> arrPods_Out){}
simulated function bool HasHiddenTerrorPods(){}
simulated function bool HasPodsInGroup(int IGroup){}
simulated function InitAction(XGUnit kUnit){}
simulated function InitDynamicAI(out array<XComAlienPod> kDynamic, const out array<XComAlienPod> kPodList){}
simulated function InitPlayer(XGAIPlayer kPlayer){}
simulated function InitPods(){}
function InitTerroristAlien(XGUnit kAlien, int iNum){}
simulated function InitTurn(){}
simulated function bool IsBusy(optional bool bCheckPods, optional XGUnit kActiveUnit){}
simulated function bool IsContingent(XGUnit kUnit){}
simulated function bool IsDeployed(XComAlienPod kPod){}
simulated function bool IsDoingPodReveal(){}
simulated function bool IsRevealed(XComAlienPod kPod){}
function bool IsTileInPodArea(int iTileX, int iTileY, int iTileZ, const out XComAlienPod kIgnore){}
simulated function bool IsValidPod(XComAlienPod kPod, int iPodGroup, optional array<XComAlienPod> kExcludeList){}
simulated function LoadInit(XGAIPlayer kPlayer){}
simulated function NotifyUnitKilled(XGUnit kUnit){}
function OnBeginSplashDamage(DamageEvent kDmg, out array<XComUnitPawnNativeBase> arrPawns_Out){}
simulated function OnEndTurn(){}
simulated function OnHearCall(Vector vSource, XGUnit kSource){}
function OnPostLoadInit(){}
simulated function int OvermindSpawn(int iSpawn){}
function XGGameData.EItemType PopRandomLootType(){}
simulated function PullFromPods(int nAliensToPull, optional bool bRemove){}
simulated function QueuePodReveal(XComAlienPod kPod, XGUnit kRevealedTo, optional bool bForceActivate, optional bool bForcePatrol){}
simulated function QueueUnitReveal(XGUnit kUnit, XGUnit kRevealedTo, int eReveal){}
simulated function RemoveAllPods(){}
simulated function RemoveContingentPods(array<XComAlienPod> arrRemoveList){}
simulated function RestoreCamera(){}
simulated function RevealNextPod(){}
simulated function RevealPod(int iPodIdx){}
simulated function RevealPods(XGUnit kUnit, optional bool bTestAllUnits){}
simulated function SaveCamera(){}
function SelectSpecialtyPods(const out array<XComAlienPod> arrExclude, int iPodGroup){}
function SetDynamicAI(XComAlienPod kPod){}
simulated function Vector SpawnAlienOutsidePlayerVisibility(EPawnType inputPawnType, optional float fMaxRadius=640.0){}
simulated function int SpawnAllPodAliens(int iPodGroup, optional bool bForceActivate){}
simulated function int SpawnPodAliens(XComAlienPod kPod, optional bool bForceActivate, optional bool bPresetCounts){}
function UnrevealPod(XComAlienPod kPod){}
simulated function UpdateContingentList(){}
simulated function UpdateCurrState();
simulated function UpdatePodQueue(){}
simulated function bool UpdatePodVisibility(XGUnit kUnit, optional bool bTestAllUnits){}
simulated function UpdateTriggered(){}
simulated function UpdateUnactivatedSeenPods(){}
function bool WaitingOnUnit(XGUnit kUnit){}

state Active
{
    function DebugLogHang()
    {
        if(m_iActivePodIdx < m_arrActivation.Length)
        {
        }
        if(m_arrTriggered.Length > 0)
        {
        }
        super.DebugLogHang();
    }

    simulated function RevealPods(XGUnit kUnit, optional bool bTestAllUnits)
    {
        bTestAllUnits = false;
        RevealNextPod();
    }

    simulated function SortActivationList()
	{}
	simulated function BeginState(name P)
    {
        SaveCamera();
        m_iActivePodIdx = 0;
        SortActivationList();
        m_bSpoken = false;
        m_iRevealedCount = 0;
        RevealNextPod();
        m_bIsBusy = true;
    }

    simulated function EndState(name N)
    {
        m_arrActivation.Remove(0, m_arrActivation.Length);
        m_iActivePodIdx = 0;
        RestoreCamera();
        CleanUpRespawns();
        UpdateContingentList();
    }
}
state DynamicAI extends Active
{
    simulated function BeginState(name P)
    {
        super.BeginState(P);
        InitTurn_DynamicAI();
    }

    simulated function EndState(name N)
    {
        super.EndState(N);
    }

    simulated function bool InitTurn_DynamicAI()
    {
        local XComAlienPod kPod;

        m_arrDynamic.Remove(0, m_arrDynamic.Length);
        foreach m_arrPod(kPod)
        {
            if(!kPod.IsAlive())
            {
                kPod.GotoState('Inactive');
                continue;                
            }
            if(kPod.m_bDynamicAI)
            {
                m_arrDynamic.AddItem(kPod);
                kPod.InitTurn_DynamicAI();
            }            
        }        
        return m_arrDynamic.Length > 0;
    }
	simulated function bool UpdateDynamicAI(optional out XComAlienPod kPod)
    {
        foreach m_arrDynamic(kPod)
        {
            if(kPod.IsUpdating())
            {                
                return true;
            }            
        }        
        return false;
    }

    simulated function bool UpdateDynamicReveals()
	{}
	function DebugLogHang()
    {
        local XComAlienPod kPod;

        if(UpdateDynamicAI(kPod))
        {
        }
        super.DebugLogHang();
    }
}

auto state Inactive
{
    simulated function UpdateCurrState()
    {
    }
       
}
state InitialSpawn
{  
}
state PostLoadQueue
{
    simulated function BeginState(name N);

    simulated function EndState(name N);

    function PrepPodForQueue(XComAlienPod kPod)
    {
    }

    function bool PodIsReady(XComAlienPod kPod)
    {
    }

    function QueueNextPostponed()
    {
    }
}