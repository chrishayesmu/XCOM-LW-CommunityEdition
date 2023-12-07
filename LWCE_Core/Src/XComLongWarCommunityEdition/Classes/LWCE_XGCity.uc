class LWCE_XGCity extends XGCity;

struct CheckpointRecord_LWCE_XGCity extends XGCity.CheckpointRecord
{
    var name m_nmCity;
    var name m_nmCountry;
};

var name m_nmCity;
var name m_nmCountry;

function int GetCountry()
{
    `LWCE_LOG_DEPRECATED_CLS(GetCountry);

    return -1;
}

function name LWCE_GetCountry()
{
    return m_nmCountry;
}

function int GetContinent()
{
    `LWCE_LOG_DEPRECATED_CLS(GetContinent);

    return -1;
}

function name LWCE_GetContinent()
{
    return `LWCE_XGCOUNTRY(m_nmCountry).LWCE_GetContinent();
}

function string GetFullName()
{
    return m_strName $ ", " $ `LWCE_XGCOUNTRY(m_nmCountry).GetName();
}