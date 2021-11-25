class XComMutatorLoader extends XComMutator
	config(MutatorLoader);

var config array<config string> arrTacticalMutators;
var config array<config string> arrStrategicMutators;
var config bool bDisableLog;

function GameInfoInitGame(PlayerController Sender){}