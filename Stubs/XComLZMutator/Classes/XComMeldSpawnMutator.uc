class XComMeldSpawnMutator extends XComSpawnMutator
	config(RandomSpawns);

var config int NumContainers;
var config float EqSlope;
var config float EqConst;
var array<vector> MeldSpawnPts;

function PostLevelLoaded(PlayerController Sender){}
function RemoveOriginalSpawnPoints(){}
function AddNewSpawnPoints(){}