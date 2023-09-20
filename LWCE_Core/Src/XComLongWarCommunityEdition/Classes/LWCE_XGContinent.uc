class LWCE_XGContinent extends XGContinent;

struct CheckpointRecord_LWCE_XGContinent extends XGContinent.CheckpointRecord
{
    var name nmContinent;
};

var name nmContinent;
var LWCEContinentTemplate m_kTemplate;

function ApplyCheckpointRecord()
{
    m_kTemplate = `LWCE_CONTINENT(nmContinent);
}

function InitNewGame()
{
    m_kTemplate = `LWCE_CONTINENT(nmContinent);
}

function string GetName()
{
    return m_kTemplate.strName;
}

function int GetID()
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(GetID);

    return -1;
}

function Vector2D GetHQLocation()
{
    return m_kTemplate.v2HQLocation;
}