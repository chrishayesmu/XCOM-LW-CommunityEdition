class XComShellCheatManager extends XComCheatManager within XComPlayerControllerNativeBase;

exec function Help(optional string tok){}
function HelpDESC(string func, string Description){}
function OutputMsg(string msg){}
exec function setpodgroup(int iPodGroup){}
exec function listui(){}
exec function uitracethings(int numTraces){}
exec function uinotrace(int numTraces){}
exec function FlushOnlineStats(optional name SessionName = 'Game'){}
exec function displaympmatchcriteria(){}