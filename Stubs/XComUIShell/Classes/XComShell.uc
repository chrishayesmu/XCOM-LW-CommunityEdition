class XComShell extends XComGameInfo
    config(Game)
    hidecategories(Navigation,Movement,Collision);

const EXECUTE_COMMAND_TIMEOUT = 0.5;

event InitGame(string Options, out string ErrorMessage){}
event PostLogin(PlayerController NewPlayer){}
simulated function ShutDownAndExecute(string Command){}