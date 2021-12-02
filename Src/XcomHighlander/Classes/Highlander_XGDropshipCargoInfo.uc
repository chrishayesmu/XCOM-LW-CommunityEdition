class Highlander_XGDropshipCargoInfo extends XGDropshipCargoInfo;

struct CheckpointRecord_Highlander_XGDropshipCargoInfo extends CheckpointRecord
{
    var HighlanderItemContainer m_kArtifactsContainer;
    var array<HL_TTech> m_arrHLTechHistory;
};

var HighlanderItemContainer m_kArtifactsContainer;
var array<HL_TTech> m_arrHLTechHistory;

function Init()
{
    m_kArtifactsContainer = Spawn(class'HighlanderItemContainer');
}