class XGBattle_SPTerror extends XGBattle_SP;
//complete stub

struct CheckpointRecord_XGBattle_SPTerror extends CheckpointRecord
{
    var int m_iNumStartingCivilians;
    var int m_iNumCiviliansDead;
    var int m_iNumCiviliansSaved;
};

var int m_iNumStartingCivilians;
var int m_iNumCiviliansDead;
var int m_iNumCiviliansSaved;

function string GetIntroMovie()
{
    return "tactical_intro.bik";
}