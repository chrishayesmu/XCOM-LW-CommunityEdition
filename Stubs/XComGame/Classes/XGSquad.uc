class XGSquad extends XGSquadNativeBase
	dependsOn(XGTacticalGameCore);
//complete stub

struct CheckpointRecord_XGSquad extends CheckpointRecord
{
    var XGDropshipCargoInfo m_kDropshipCargo;
    var int m_iBadge;
    var XGVolume m_aVolumes;
    var int m_iNumVolumes;
};

var XGVolume m_aVolumes[16];
var int m_iNumVolumes;
var XGDropshipCargoInfo m_kDropshipCargo;
var int m_iBadge;
var array<XGUnit> m_arrSortedUnits;
var delegate<VisitUnitDelegate> __VisitUnitDelegate__Delegate;
//var delegate<CheckUnitDelegate> __CheckUnitDelegate__Delegate;

simulated event ReplicatedEvent(name VarName){}
simulated function DebugPrintCurrentSquadActions(){}
simulated function SortUnits(optional XGUnit kFirstUnit){}
simulated function GetUnsortedUnits(out array<XGUnit> arrUnits){}
simulated function XGUnit GetClosestUnit(const XGUnit kCloseToUnit, const out array<XGUnit> arrUnits){}
function AddUnit(XGUnit kUnit, optional bool bTemporary){}
function AddPermanentUnit(XGUnit kAddUnit){}
function AddUnitToEnd(XGUnit kAddUnit){}
function RemoveUnit(XGUnit kUnit){}
function ReAddUnit(XGUnit kAddUnit, int iPermanentIndex){}
function Uninit(){}
simulated function int GetNumPermanentMembers(){}
simulated function int GetNumOutsideDropship(optional bool checkForAbortGame){}
simulated function int GetNumInsideDropship(){}
simulated function XGUnit GetPermanentMemberAt(int iIndex){}
simulated function int GetIndex(XGUnit kUnit){}
simulated function int GetSortedIndex(XGUnit kUnit){}
simulated function int GetPermanentIndex(XGUnit kUnit){}
simulated function XGPlayer GetPlayer(){}
function AddCloseUnit(XGUnit kUnit){}
function RemoveCloseUnit(XGUnit kUnit){}
function int GetNumCloseUnits(){}
function PreCloseCombatInit(XGUnit kInstigator){}
function bool HasPostCloseCombatTurn(int iUnit){}
simulated function BeginTurn(optional bool bLoadedFromCheckpoint){}
simulated function bool IsNetworkIdle(bool bCountPathActionsAsIdle){}
function EndTurn(){}
function OnMoraleEvent(XGTacticalGameCore.EMoraleEvent EEvent, XGUnit kIgnoreUnit){}
function InitLoadedMembers(){}
simulated function bool IsAnyoneElseAttacking(XGUnit kIgnoreUnit, optional out XGUnit kUnitIsAttacking){}
simulated function bool IsAnyoneElsePerformingAction(XGUnit kIgnoreUnit, optional out XGUnit kUnitIsDoingSomething){}
delegate bool CheckUnitDelegate(XGUnit kUnit);
delegate VisitUnitDelegate(XGUnit kUnit);
simulated function bool IsAnyoneElse_CheckUnitDelegate(delegate<CheckUnitDelegate> fnCheckUnit, XGUnit kIgnoreUnit, optional out XGUnit kFoundUnit){}
function VisitUnit(delegate<VisitUnitDelegate> fnVisitUnit, optional bool bIgnoreTime=true, optional bool bVisitDead, optional bool bSkipPanicked=true){}
simulated function XGUnit GetNextGoodMember(optional XGUnit kUnit, optional bool IgnoreTime=true, optional bool bWraparound=true, optional bool bSkipPanicked=true, optional bool bSortedList, optional bool bSkipStrangling=true, optional bool bIncludeBattleScanners){}
simulated function XGUnit GetPrevGoodMember(optional XGUnit kUnit, optional bool IgnoreTime=true, optional bool bSortedList, optional bool bSkipStrangling=true){}
simulated function Color GetColor(){}
simulated function string GetName(){}
function SetName(string strNewName){}
simulated function XGDropshipCargoInfo GetDropshipCargoInfo(){}
function SetDropshipCargoInfo(XGDropshipCargoInfo kNewDrop){}
simulated function string GetMotto(){}
simulated function int GetBadge(){}
simulated function bool IsInitialReplicationComplete(){}
simulated function bool AllPermanentUnitsHaveReplicated(){}
simulated function bool AllUnitsHaveReplicated(){}
simulated function Box GetBoundingBox(){}
function AddSightVolume(XGVolume kVolume){}
function RemoveSightVolume(XGVolume kVolume){}
function AddVolume(XGVolume kVolume){}
function RemoveVolume(XGVolume kVolume){}
