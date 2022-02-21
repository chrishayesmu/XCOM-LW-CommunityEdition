class LWCE_XGDropshipCargoInfo extends XGDropshipCargoInfo;

struct CheckpointRecord_LWCE_XGDropshipCargoInfo extends CheckpointRecord
{
    var LWCEItemContainer m_kArtifactsContainer;
    var array<LWCE_TTech> m_arrCETechHistory;
    var array<LWCE_TFoundryTech> m_arrCEFoundryHistory;
};

var LWCEItemContainer m_kArtifactsContainer;
var array<LWCE_TTech> m_arrCETechHistory;
var array<LWCE_TFoundryTech> m_arrCEFoundryHistory;

function Init()
{
    m_kArtifactsContainer = Spawn(class'LWCEItemContainer');
}

function bool HasFoundryTech(int iTechId)
{
    return m_arrCEFoundryHistory.Find('iTechId', iTechId) != INDEX_NONE;
}

function bool HasTech(int iTechId)
{
    return m_arrCETechHistory.Find('iTechId', iTechId) != INDEX_NONE;
}