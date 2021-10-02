class Highlander_XGBattle_SPDebug extends XGBattle_SP;

function int GetNumTanks(XGPlayer kPlayer)
{
    return 1;
}

function bool IsVictory(bool bIgnoreBusyCheck)
{
    return false;
}

function bool IsDefeat()
{
    return false;
}