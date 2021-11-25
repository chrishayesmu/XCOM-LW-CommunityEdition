class XComPodSpawnMutator extends XComSpawnMutator
	config(RandomSpawns);

var int NumPods;
var array<vector> PodSpawnPts;
var bool bKeepCommander;

function int MissionType(){}
function EShipType ShipType(){}
function PostLevelLoaded(PlayerController Sender){}
function vector GetRandomCommandPoint(vector Origin, vector Extent){}
function GenerateCommanderSpawnPt(){}
function RemoveOriginalSpawnPoints(){}
function AddNewSpawnPoints(){}