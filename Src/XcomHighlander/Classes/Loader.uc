class Loader extends Mutator;


function Mutate(string MutateString, PlayerController Sender) {
    local XComGameInfo CurrentGameInfo;

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
