class SpawnAlienQueue extends Actor;
//complete stub

var array<XComSpawnPoint_Alien> m_arrSpawnPoints;
var array<XGAISpawnMethod> m_arrSpawnActions;
var XComSpawnPoint_Alien m_kCompletedPoint;
var array<DelayedOverwatch> m_arrOverwatches;

function bool IsBusy(){}
function AddSpawnPoint(XComSpawnPoint_Alien kPoint, XGAISpawnMethod kSpawnMethod){}
function OnSpawnPointComplete(XComSpawnPoint_Alien kPoint){}
function ProcessQueue(){}
function StopProcessing(){}

state ProcessingSpawn{}
state SpawnPointComplete{}
