class Highlander_XGDropshipCargoInfo extends XGDropshipCargoInfo;

struct CheckpointRecord_Highlander_XGDropshipCargoInfo extends CheckpointRecord
{
    var HighlanderItemContainer m_kArtifactsContainer;
    var array<HL_TTech> m_arrHLTechHistory;
    var array<HL_TFoundryTech> m_arrHLFoundryHistory;
};

var HighlanderItemContainer m_kArtifactsContainer;
var array<HL_TTech> m_arrHLTechHistory;
var array<HL_TFoundryTech> m_arrHLFoundryHistory;

function Init()
{
    m_kArtifactsContainer = Spawn(class'HighlanderItemContainer');
}

function bool HasFoundryTech(int iTechId)
{
    return m_arrHLFoundryHistory.Find('iTechId', iTechId) != INDEX_NONE;
}

function bool HasTech(int iTechId)
{
    return m_arrHLTechHistory.Find('iTechId', iTechId) != INDEX_NONE;
}