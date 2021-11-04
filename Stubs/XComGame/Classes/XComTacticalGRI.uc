class XComTacticalGRI extends XComGameReplicationInfo
    native(Core)
    config(Game)
    hidecategories(Navigation,Movement,Collision);
//complete stub

enum EXComTacticalEvent
{
    PAWN_INDOOR_OUTDOOR,
    PAWN_SELECTED,
    PAWN_UNSELECTED,
    PAWN_CHANGED_FLOORS,
    PAWN_MAX
};

struct native XComDelegateListToEvent
{
    var EXComTacticalEvent EEvent;
    var array< delegate<XComTacticalDelegate> > DelegateList;
};

var XGCharacterGenerator m_CharacterGen;
var XGBattle m_kBattle;
var StrategyGameTransport m_kTransferSave;
var XComOnlineProfileSettings m_kProfileSettings;
var SimpleShapeManager mSimpleShapeManager;
var XComTraceManager m_kTraceMgr;
var XComPrecomputedPath m_kPrecomputedPath;
var class<XGPlayer> m_kPlayerClass;
var XComDirectedTacticalExperience DirectedExperience;
//var delegate<XComTacticalDelegate> __XComTacticalDelegate__Delegate;
var array<XComDelegateListToEvent> TacticalDelegateLists;

replication
{
    if(Role == ROLE_Authority)
        m_kBattle, m_kPrecomputedPath;
}

delegate XComTacticalDelegate(Object Params);
final function int FindDelegateListForEvent(EXComTacticalEvent EEvent){}
simulated function StartMatch(){}
function InitBattle(){}
function UninitBattle(){}
simulated function XGBattle GetBattle(){}
function SaveData(int iSlot);
function LoadData(string strSaveFile);
simulated event int GetCurrentPlayerTurn(){}
simulated event int GetNumberOfPlayers(){}
native simulated function bool IsValidLocation(Vector vLoc, optional XGUnitNativeBase kUnit, optional bool bLogFailures, optional bool bAvoidNoSpawnZones);
native simulated function Vector GetClosestValidLocation(Vector vLoc, XGUnitNativeBase kUnit, optional bool bAllowFlying, optional bool bPrioritizeZ=true, optional bool bAvoidNoSpawnZones);
// Export UXComTacticalGRI::execGetPathLengthToDestination(FFrame&, void* const)
native simulated function float GetPathLengthToDestination(Vector vDest, XGUnitNativeBase kUnit);

// Export UXComTacticalGRI::execPostLoad_LoadRequiredContent(FFrame&, void* const)
native function PostLoad_LoadRequiredContent(XComContentManager ContentMgr);
simulated function XComLadder FindLadder(Vector vLocation, optional int iRadius=96, optional int iMaxHeightDiff=100){}
simulated function RegisterTacticalDelegate(delegate<XComTacticalDelegate> D, EXComTacticalEvent EEvent){}
simulated function NotifyOfEvent(EXComTacticalEvent EEvent, Object Params){}


