class XGBattleResult extends Actor;
//complete stub

struct CheckpointRecord
{
    var XGPlayer m_kWinner;
    var int m_iTurnsTaken;
};

var XGPlayer m_kWinner;
var int m_iTurnsTaken;


function SetWinner(XGPlayer kPlayer)
{
    m_kWinner = kPlayer;
    //return;    
}

function XGPlayer GetWinner()
{
    return m_kWinner;
    //return ReturnValue;    
}

function UpdateResults(XGBattle kBattle)
{
    //return;    
}
