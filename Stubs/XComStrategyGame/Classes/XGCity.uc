class XGCity extends XGStrategyActor
    config(GameData)
    notplaceable
    hidecategories(Navigation);

struct CheckpointRecord
{
    var Vector2D m_v2Coords;
    var string m_strName;
    var int m_iID;
    var int m_iCountry;
    var int m_iTerrorized;

    structdefaultproperties
    {
        m_v2Coords=(X=0.0,Y=0.0)
        m_strName=""
        m_iID=0
        m_iCountry=0
        m_iTerrorized=0
    }
};

var Vector2D m_v2Coords;
var string m_strName;
var int m_iID;
var int m_iCountry;
var int m_iTerrorized;

function string GetFullName()
{
    return (m_strName $ ", ") $ Country(m_iCountry).GetName();
    //return ReturnValue;    
}

function string GetName()
{
    return m_strName;
    //return ReturnValue;    
}

function int GetCountry()
{
    return m_iCountry;
    //return ReturnValue;    
}

function int GetContinent()
{
    return Country(m_iCountry).GetContinent();
    //return ReturnValue;    
}

function Vector2D GetCoords()
{
    return m_v2Coords;
    //return ReturnValue;    
}

defaultproperties
{
    m_iTerrorized=-1
}