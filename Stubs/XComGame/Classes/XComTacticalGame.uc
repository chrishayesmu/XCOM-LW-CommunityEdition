class XComTacticalGame extends XComGameInfo
    hidecategories(Navigation,Movement,Collision)
    config(Game);
//complete sub

var bool bDebugCombatRequested;
var bool bNoVictory;
var bool m_bLoadingFromShell;
var bool m_bDisableLoadingScreen;
var name ForcedSpawnGroupTag;
var int ForcedSpawnGroupIndex;
var string strSaveFile;
var XComProfileGrid m_kProfileGrid;

function StartMatch(){}
function InitResources(){}
event InitGame(string Options, out string ErrorMessage){}
event GameEnding(){}
function NavigationPoint FindPlayerStart(Controller Player, optional byte InTeam, optional string IncomingName){}
event PlayerController Login(string Portal, string Options, const UniqueNetId UniqueId, out string ErrorMessage){}
event PostLogin(PlayerController NewPlayer){}
exec function SetupPIE(){};
function string GetSavedGameDescription(){}
function string GetSavedGameCommand(){}
event GetSeamlessTravelActorList(bool bToTransitionMap, out array<Actor> ActorList){}
event PostSeamlessTravel(){}
event HandleSeamlessTravelPlayer(out Controller C){}
simulated function TItemCard GetItemCard(){}
simulated function KillAliensQuietly(){}

auto state PendingMatch{
    function bool IsLoading(){}

}
