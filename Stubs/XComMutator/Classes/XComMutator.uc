class XComMutator extends Mutator;

var bool m_bDisableLog;
var bool m_bLocalMutate;

function ModifyLogin(out string strOptions, out string strMessage){}
function Mutate(string MutateString, PlayerController Sender){}
function GameInfoInitGame(PlayerController Sender){}
function HeadQuartersInitNewGame(PlayerController Sender){}
function PostLevelLoaded(PlayerController Sender){}
function PostLoadSaveGame(PlayerController Sender){}
function DoWorldDataRebuild(PlayerController Sender){}
function MutateNotifyKismetOfLoad(PlayerController Sender){}
function MutateStrategyAI(PlayerController Sender){}
function MutateSpawnAlien(string SeqActObjName, PlayerController Sender){}
function MutateTacticalAI(string UnitObjName, PlayerController Sender){}
function MutateUpdateInteractClaim(string UnitObjName, PlayerController Sender){}
function MutateRecordKill(string UnitObjName, string VictimObjName, PlayerController Sender){}