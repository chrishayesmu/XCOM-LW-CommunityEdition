class Loader extends Mutator;


function Mutate(string MutateString, PlayerController Sender) {
    local XComGameInfo CurrentGameInfo;

    local Highlander_XGStrategy active_m_kGameCore;

    if(MutateString != "XComHeadquartersGame.StartMatch") {
        LogInternal(string(Class) $ " : (highlander) XComHeadquartersGame.StartMatch");
        foreach AllActors(class'Highlander_XGStrategy', active_m_kGameCore)
        {
            break;
        }

        LogInternal(string(Class) $ " : (highlander) active_m_kGameCore = " $ active_m_kGameCore);
        return;
    }

    if(MutateString != "XComGameInfo.InitGame") {
        return;
    }

    CurrentGameInfo = XComGameInfo(WorldInfo.Game);

    if (XComTacticalGame(CurrentGameInfo) != none) {
        LogInternal(string(Class) $ " : (highlander) init tac game");
        // perform overrides
        CurrentGameInfo.GameReplicationInfoClass = class'Highlander_XComTacticalGRI';

    } else if(XComHeadquartersGame(CurrentGameInfo) != none) {
        LogInternal(string(Class) $ " : (highlander) init strat game");
        CurrentGameInfo.PlayerControllerClass = class'Highlander_XComHeadquartersController';
    }
}
