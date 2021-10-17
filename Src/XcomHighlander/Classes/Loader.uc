class Loader extends Mutator;

function Mutate(string MutateString, PlayerController Sender) {
    local XComGameInfo CurrentGameInfo;
    local Highlander_XGStrategy active_m_kGameCore;

    if (MutateString == "XComHeadquartersGame.StartMatch") {
        `HL_LOG(string(Class) $ " : (highlander) XComHeadquartersGame.StartMatch");
        foreach AllActors(class'Highlander_XGStrategy', active_m_kGameCore)
        {
            break;
        }

        `HL_LOG(string(Class) $ " : (highlander) active_m_kGameCore = " $ active_m_kGameCore);
    }
    else if (MutateString == "XComGameInfo.InitGame") {
        CurrentGameInfo = XComGameInfo(WorldInfo.Game);

        if (XComTacticalGame(CurrentGameInfo) != none) {
            `HL_LOG(string(Class) $ " : (highlander) init tac game");
            // perform overrides
            CurrentGameInfo.GameReplicationInfoClass = class'Highlander_XComTacticalGRI';
        }
        else if (XComHeadquartersGame(CurrentGameInfo) != none) {
            `HL_LOG(string(Class) $ " : (highlander) init strat game");
            CurrentGameInfo.PlayerControllerClass = class'Highlander_XComHeadquartersController';
        }
    }

    super.Mutate(MutateString, Sender);
}