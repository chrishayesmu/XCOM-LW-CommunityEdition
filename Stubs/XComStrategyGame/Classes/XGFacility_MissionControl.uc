class XGFacility_MissionControl extends XGFacility
    config(GameData)
    notplaceable
    hidecategories(Navigation);

struct CheckpointRecord_XGFacility_MissionControl extends CheckpointRecord
{
    var bool m_bDetectedOverseer;
    var int m_iNoJetsCounter;
};

var bool m_bDetectedOverseer;
var int m_iNoJetsCounter;

function Init(bool bLoadingFromSave)
{ 
}

function InitNewGame()
{
    //return;    
}

function Enter(int iView)
{
}

function Exit()
{
}

DefaultProperties
{
}
