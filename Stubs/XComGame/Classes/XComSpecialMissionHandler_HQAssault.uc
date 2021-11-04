class XComSpecialMissionHandler_HQAssault extends XComSpecialMissionHandler
    notplaceable
    hidecategories(Navigation);
//complete stub

const SPAWN_TIMEOUT = 10.0f;

enum ERequestStep
{
    eStep_Unknown,
    eStep_Appearance,
    eStep_Inventory,
    eStep_Perks,
    eStep_Finished,
    eStep_MAX
};

struct PendingTraversal
{
    var XGUnit m_kUnit;
    var XComSpawnPoint m_kSpawnPt;
    var Vector m_vSpawnLoc;
};

struct CheckpointRecord_XComSpecialMissionHandler_HQAssault extends CheckpointRecord
{
    var array<TTransferSoldier> m_arrReinforcements;
};

var array<TTransferSoldier> m_arrReinforcements;
var int m_iCurrentSoldierContent;
var bool m_bThrowawayContent;
var array<PendingTraversal> m_arrTraversals;
var array<PendingTraversal> m_arrSpawningUnits;
var float m_fSpawnWaitTime;
var array<TSoldierPawnContent> m_arrContentToBurn;
var array<Object> m_arrContent;
var XComSpecialMissionHandler_HQAssault.ERequestStep m_eRequestStep;

function Initialize(){}
function StartRequestingContent(){}
function RequestSoldierContent(){}
function SoldierContentLoaded(Object Content, int ContentId, int SubID){}
function XGUnit SpawnNextReinforcement(XComSpawnPoint DestinationSpawnPt, XComSpawnPoint OriginPoint, bool bLast){}
function XGUnit SpawnUnit(XComSpawnPoint SpawnPt, TTransferSoldier kTransfer, XGGameData.EPawnType ePawn, bool bWillMove){}
function AddPendingTraversal(XGUnit kUnit, XComSpawnPoint kSpawnPt, Vector vSpawnLoc){}
function Tick(float DeltaTime){}
function CheckTraversals(){}
function bool AddTraversal(XGUnit kUnit, XComSpawnPoint kSpawnPt, Vector vSpawnLoc){}
function ForceNormalPathToPoint(XGUnit kUnit, Vector vDestination, XComSpawnPoint kSpawnPt){}

state WhatAreTheyAfter
{}
state DefendFirstPoint
{    
	function SetObjectives(){}
}
state DefendSecondPoint
{
    function SetObjectives(){}
}
state AllUnitsLost
{
}