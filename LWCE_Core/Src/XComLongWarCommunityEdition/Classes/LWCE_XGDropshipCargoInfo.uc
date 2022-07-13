class LWCE_XGDropshipCargoInfo extends XGDropshipCargoInfo;

struct CheckpointRecord_LWCE_XGDropshipCargoInfo extends CheckpointRecord
{
    var LWCEItemContainer m_kArtifactsContainer;
    var array<name> m_arrCETechHistory;
    var array<name> m_arrCEFoundryHistory;
    var array<LWCE_TTransferSoldier> m_arrCESoldiers;
    var LWCE_TTransferSoldier m_kCECovertOperative;
};

var LWCEItemContainer m_kArtifactsContainer;
var array<name> m_arrCETechHistory;
var array<name> m_arrCEFoundryHistory;
var array<LWCE_TTransferSoldier> m_arrCESoldiers;
var LWCE_TTransferSoldier m_kCECovertOperative;

function Init()
{
    m_kArtifactsContainer = Spawn(class'LWCEItemContainer');
}

function bool HasFoundryProject(name ProjectName)
{
    return m_arrCEFoundryHistory.Find(ProjectName) != INDEX_NONE;
}

function bool HasTech(name TechName)
{
    return m_arrCETechHistory.Find(TechName) != INDEX_NONE;
}