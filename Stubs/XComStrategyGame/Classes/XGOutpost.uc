class XGOutpost extends XGStrategyActor
    config(GameData);
//complete stub

struct CheckpointRecord
{
    var string m_strName;
    var int m_iContinent;
    var XGEntity m_kEntity;

    structdefaultproperties
    {
        m_strName=""
        m_iContinent=0
        m_kEntity=none
    }
};

var string m_strName;
var int m_iContinent;

function Init(int iContinent){}
function int GetFreeHangerSpots(){}
function Vector2D GetCoords(){}
function int GetContinent(){}
