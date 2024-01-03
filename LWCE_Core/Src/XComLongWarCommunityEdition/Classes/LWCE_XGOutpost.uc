class LWCE_XGOutpost extends XGOutpost;

struct CheckpointRecord_LWCE_XGOutpost extends XGOutpost.CheckpointRecord
{
    var name m_nmContinent;
};

var name m_nmContinent;

function Init(int iContinent)
{
    `LWCE_LOG_DEPRECATED_CLS(Init);
}

function LWCE_Init(name nmContinent)
{
    m_nmContinent = nmContinent;
    SetEntity(Spawn(class'LWCE_XGBaseEntity'), eEntityGraphic_Hangar);
}

function Vector2D GetCoords()
{
    return `LWCE_XGCONTINENT(m_nmContinent).GetHQLocation();
}

function int GetContinent()
{
    `LWCE_LOG_DEPRECATED_CLS(GetContinent);

    return -100;
}

function name LWCE_GetContinent()
{
    return m_nmContinent;
}

function int GetFreeHangerSpots()
{
    `LWCE_LOG_DEPRECATED_NOREPLACE_CLS(GetFreeHangerSpots);

    return -100;
}