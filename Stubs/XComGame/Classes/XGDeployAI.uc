class XGDeployAI extends XGOvermindActor;

//complete stub

enum EDeploymentFlags
{
    eDeploy_Random,
    eDeploy_ClosestFirst,
    eDeploy_FurthestFirst,
    eDeploy_Custom,
    eDeploy_MAX
};

struct CheckpointRecord
{
    var TAlienSquad m_kSquad;
    var array<TAlienSpawn> m_arrDeployments;
    var array<XComAlienPod> m_arrPossibleSpawns;
    var array<XComAlienPod> m_arrOriginalSpawns;
    var array<XComAlienPod> m_arrBackupSpawns;
    var array<int> m_arrFlags;
    var Vector m_vPlayerSpawn;
    var int m_iNumSoldierSpawns;
    var int m_iNumSoldiers;
    var int m_iNumHunterSpawns;
    var int m_iNumHunters;
};


var TAlienSquad m_kSquad;
var array<TAlienSpawn> m_arrDeployments;
var array<XComAlienPod> m_arrPossibleSpawns;
var array<XComAlienPod> m_arrOriginalSpawns;
var array<XComAlienPod> m_arrBackupSpawns;
var array<int> m_arrFlags;
var Vector m_vPlayerSpawn;
var int m_iNumSoldierSpawns;
var int m_iNumSoldiers;
var int m_iNumHunterSpawns;
var int m_iNumHunters;

function array<TAlienSpawn> DeployPods(out TAlienSquad kAlienSquad){}
function SetDeploymentFlags(){}
function DeployMissionCommander(){}
function DeploySecondaryAliens(){}
function DeploySoldiers(){}
function DeployRoaming(){}
function KismetRoamingNumber(int iNum){}
function DeployHunters();
function array<XComAlienPod> GetPossibleCommanderSpawns(){}
function array<XComAlienPod> GetPossibleSecondarySpawns(){}
function array<XComAlienPod> GetPossibleSoldierSpawns(){}
function BuildSpawn(XComAlienPod kSpawnLoc, TAlienPod kPod, EPodAnimation eAnim, optional EItemType ePodDevice){}
function GetPossibleSpawns(){}
function GetPlayerStart(){}
function SetFlag(EDeploymentFlags eFlag){}
function ClearFlag(EDeploymentFlags eFlag){}
function bool GetFlag(EDeploymentFlags eFlag){}
