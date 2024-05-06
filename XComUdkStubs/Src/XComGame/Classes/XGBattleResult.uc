class XGBattleResult extends Actor
    abstract
    notplaceable
    hidecategories(Navigation);

struct CheckpointRecord
{
    var XGPlayer m_kWinner;
    var int m_iTurnsTaken;
};

var protected XGPlayer m_kWinner;
var protected int m_iTurnsTaken;

defaultproperties
{
    RemoteRole=ROLE_SimulatedProxy
    bTickIsDisabled=true
    bAlwaysRelevant=true
}