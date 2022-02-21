class Loader extends Mutator;

function Mutate(string MutateString, PlayerController Sender) {
    local XComGameInfo CurrentGameInfo;
    local LWCE_XGStrategy active_m_kGameCore;

    if (MutateString == "XComHeadquartersGame.StartMatch") {
        `LWCE_LOG_CLS("(LWCE) XComHeadquartersGame.StartMatch");
        foreach AllActors(class'LWCE_XGStrategy', active_m_kGameCore)
        {
            break;
        }

        `LWCE_LOG_CLS("(LWCE) active_m_kGameCore = " $ active_m_kGameCore);
    }
    else if (MutateString == "XComGameInfo.InitGame") {
        CurrentGameInfo = XComGameInfo(WorldInfo.Game);

        if (XComTacticalGame(CurrentGameInfo) != none) {
            `LWCE_LOG_CLS("(LWCE) init tac game");
            // perform overrides
            //CurrentGameInfo.GameReplicationInfoClass = class'LWCE_XComTacticalGRI';
        }
        else if (XComHeadquartersGame(CurrentGameInfo) != none) {
            `LWCE_LOG_CLS("(LWCE) init strat game");
            //CurrentGameInfo.PlayerControllerClass = class'LWCE_XComHeadquartersController';
        }
    }

    super.Mutate(MutateString, Sender);
}