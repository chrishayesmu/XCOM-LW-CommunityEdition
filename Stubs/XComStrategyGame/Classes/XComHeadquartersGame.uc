class XComHeadquartersGame extends XComGameInfo
	config(Game);

var PlayerController CursorController;
var PlayerController PlayerController;
var protected XGStrategy m_kGameCore;
var string m_strSaveFile;
var XComGeoscapeData m_kGeoscapeData;
var bool m_bLoadDemoFromShell;
var bool m_bDebugStrategyFromShell;
var bool m_bControlledStartFromShell;
var bool m_bEnableIronmanFromShell;
var bool m_bEnableProgenyFromShell;
var bool m_bEnableMeldTutorialFromShell;
var bool m_bEnableSlingshotFromShell;
var bool m_bSuppressFirstTimeNarrative;
var XComEarth m_kEarth;

function XGStrategy GetGameCore(){}
function XComEarth GetEarth(){}
simulated function TItemCard GetItemCard(){}
function MissionBriefing(){};
function StartMatch(){}
function InitResources(){}
function KillTransports(){}
function InitEarth(){}
event GameEnding(){}
function Uninit(){}
function InitGeoscapeDataObject(){}
event InitGame(string Options, out string ErrorMessage){}
event PlayerController Login(string Portal, string Options, const UniqueNetId UniqueId, out string ErrorMessage){}
function string GetSavedGameDescription(){}
function string GetSavedGameCommand(){}
event GetSeamlessTravelActorList(bool bToTransitionMap, out array<Actor> ActorList){}
event PostSeamlessTravel(){}
event HandleSeamlessTravelPlayer(out Controller C){}

state Headquarters{
	event BeginState(name P);
	event EndState(name N);
}

auto state PendingMatch{}
