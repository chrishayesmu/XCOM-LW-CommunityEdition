class XGDeployAI extends XGOvermindActor
    notplaceable
    hidecategories(Navigation);

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